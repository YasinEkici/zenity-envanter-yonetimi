#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# 1) MODULLER, GENEL TANIMLAR VE SİNYAL YAKALAMA
# ------------------------------------------------------------------------------
source moduller/program_yonetimi.sh
source moduller/urun_yonetimi.sh
source moduller/rapor_al.sh
source moduller/hareket_yonetimi.sh
source moduller/kullanici_yonetimi.sh
DEPO_FILE="depo.csv"
KULLANICI_FILE="kullanici.csv"
LOG_FILE="log.csv"
HAREKET_FILE="hareket.csv"

# Varsayılan yönetici bilgileri (kullanici.csv yoksa ilk satıra eklenecek)
DEFAULT_ADMIN_USERNAME="admin"
DEFAULT_ADMIN_AD="Admin"
DEFAULT_ADMIN_SOYAD="User"
DEFAULT_ADMIN_ROL="Yonetici"
# 12345'in MD5'i => 827ccb0eea8a706c4c34a16891f84e7b
DEFAULT_ADMIN_PASSWORD_MD5="827ccb0eea8a706c4c34a16891f84e7b"
DEFAULT_ADMIN_KILITLI="hayir"

#Temiz kapatma için gerekenler
TMP_FILE_U="depo.csv.tmp"      # Ürünle ilgili geçici dosya
TMP_FILE_K="kullanici.csv.tmp" # Kullanıcıyla ilgili geçici dosya
trap "temizKapat" SIGINT SIGTERM

# Giriş yapmış kullanıcının kimliği
GIRIS_YAPMIS_KULLANICI=""
GIRIS_YAPMIS_ROL=""

trap "temizKapat" SIGINT SIGTERM

function temizKapat() {
    # 1) Geçici dosyaları kaldırmak
    if [ -f "$TMP_FILE_U" ]; then
        rm -f "$TMP_FILE_U"
    fi
    if [ -f "$TMP_FILE_K" ]; then
        rm -f "$TMP_FILE_K"
    fi

    #Log’a bu kapanmayı not düşmek
    local zaman=$(date '+%Y-%m-%d %H:%M:%S')
    echo "TRAP,$zaman,root,Program Ani Kapatma,Sinyal ile sonlandırma" >> "$LOG_FILE"
    # Veriyi anında diske yazmak (sync)
    sync  # Yazma tamponlarını temizle
    zenity --info --text="Program güvenli şekilde sonlandırılıyor..."
    exit 0
}

# ------------------------------------------------------------------------------
# 2) LOG KAYIT FONKSİYONU
# ------------------------------------------------------------------------------

function logKaydet() {
    local hataNo="$1"
    local kullaniciAdi="$2"
    local islem="$3"
    local mesaj="$4"
    local zaman
    zaman=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$hataNo,$zaman,$kullaniciAdi,$islem,$mesaj" >> "$LOG_FILE"
}

# ------------------------------------------------------------------------------
# 3) DOSYA KONTROLÜ (CSV’ler yoksa oluştur, admin ekle)
# ------------------------------------------------------------------------------

function dosyaKontrol() {
    if [ ! -f "$DEPO_FILE" ]; then
        touch "$DEPO_FILE"
    fi

    if [ ! -f "$KULLANICI_FILE" ]; then
        touch "$KULLANICI_FILE"
        # Sütun: kullanici_no,ad,soyad,rol,md5_parola,kilitli_mi
        echo "1,$DEFAULT_ADMIN_USERNAME,$DEFAULT_ADMIN_AD,$DEFAULT_ADMIN_SOYAD,$DEFAULT_ADMIN_ROL,$DEFAULT_ADMIN_PASSWORD_MD5,$DEFAULT_ADMIN_KILITLI,0" >> "$KULLANICI_FILE"
    fi

    if [ ! -f "$LOG_FILE" ]; then
        touch "$LOG_FILE"
        # Sütun: hata_numarası,tarih_saat,kullanıcı_adı,işlem,mesaj
    fi
    
    if [ ! -f "$HAREKET_FILE" ]; then
        touch "$HAREKET_FILE"
        #hareket_no,urun_no,islem_tarihi,tip,adet,kullanici 
    fi
}

# ------------------------------------------------------------------------------
# 4) GİRİŞ EKRANI (LOGIN)
# ------------------------------------------------------------------------------

function kullaniciGirisiYap() {
    # CSV format: no,username,ad,soyad,rol,md5_parola,kilitli_mi,deneme_sayisi

    while true
    do
        GIRIS_BILGILERI=$(zenity --forms \
            --title="Giriş Ekranı" \
            --text="Lütfen kullanıcı adınızı (username) ve parolanızı giriniz." \
            --add-entry="Kullanıcı Adı" \
            --add-password="Parola" \
            --separator=",")

        if [ -z "$GIRIS_BILGILERI" ]; then
            # Kullanıcı “İptal” ya da pencereyi kapattı
            zenity --question --title="Çıkış" --text="Programdan çıkmak istediğinize emin misiniz?"
            if [ $? -eq 0 ]; then
                exit 0
            else
                continue
            fi
        fi

        local girilenUsername girilenParola
        girilenUsername=$(echo "$GIRIS_BILGILERI" | cut -d',' -f1)
        girilenParola=$(echo "$GIRIS_BILGILERI" | cut -d',' -f2)

        local girilenParolaMD5
        girilenParolaMD5=$(echo -n "$girilenParola" | md5sum | awk '{print $1}')

        # CSV'de 2. sütun = username
        local satir
        satir=$(grep ",$girilenUsername," "$KULLANICI_FILE")

        if [ -z "$satir" ]; then
            zenity --error --text="Kullanıcı bulunamadı veya hatalı kullanıcı adı!"
            continue
        else
            # no,username,ad,soyad,rol,md5_parola,kilitli_mi,deneme_sayisi
            local no username ad soyad rol parolaMd5 kilitliMi denemeSayisi
            no=$(echo "$satir" | cut -d',' -f1)
            username=$(echo "$satir" | cut -d',' -f2)
            ad=$(echo "$satir" | cut -d',' -f3)
            soyad=$(echo "$satir" | cut -d',' -f4)
            rol=$(echo "$satir" | cut -d',' -f5)
            parolaMd5=$(echo "$satir" | cut -d',' -f6)
            kilitliMi=$(echo "$satir" | cut -d',' -f7)
            denemeSayisi=$(echo "$satir" | cut -d',' -f8)

            # Kilitli mi?
            if [ "$kilitliMi" == "evet" ]; then
                zenity --error --text="Hesabınız kilitli. Lütfen yöneticiye başvurun."
                continue
            fi

            # Parola kontrolü
            if [ "$girilenParolaMD5" == "$parolaMd5" ]; then
                # Başarılı giriş
                zenity --info --text="Hoşgeldiniz, $ad $soyad!"
                GIRIS_YAPMIS_KULLANICI="$username"
                GIRIS_YAPMIS_ROL="$rol"

                # denemeSayisi=0 sıfırla, kilitliMi=hayir
                denemeSayisi=0
                kilitliMi="hayir"
                local guncelSatir="$no,$username,$ad,$soyad,$rol,$parolaMd5,$kilitliMi,$denemeSayisi"

                grep -v "^$no," "$KULLANICI_FILE" > "$KULLANICI_FILE.tmp"
                echo "$guncelSatir" >> "$KULLANICI_FILE.tmp"
                mv "$KULLANICI_FILE.tmp" "$KULLANICI_FILE"

                # while'dan çık
                break
            else
                # Yanlış parola => denemeSayisi++
                denemeSayisi=$((denemeSayisi+1))

                if [ $denemeSayisi -ge 3 ]; then
                    kilitliMi="evet"
                    zenity --error --text="3 kez hatalı parola girdiniz, hesap kilitlendi!"
                else
                    zenity --error --text="Hatalı parola (Deneme $denemeSayisi / 3)"
                fi

                local guncelSatir="$no,$username,$ad,$soyad,$rol,$parolaMd5,$kilitliMi,$denemeSayisi"
                grep -v "^$no," "$KULLANICI_FILE" > "$KULLANICI_FILE.tmp"
                echo "$guncelSatir" >> "$KULLANICI_FILE.tmp"
                mv "$KULLANICI_FILE.tmp" "$KULLANICI_FILE"
            fi
        fi
    done
}

# ------------------------------------------------------------------------------
# 5) ANA MENÜ
# ------------------------------------------------------------------------------

function anaMenu() {
    while true
    do
        if [ "$GIRIS_YAPMIS_ROL" == "Yonetici" ]; then
            SECIM=$(
                zenity --list \
                       --title="Ana Menü (Yönetici)" \
                       --text="<span font='12'>Lütfen yapmak istediğiniz işlemi seçiniz.</span>" \
                       --column="Numara" --column="İşlem" \
                       1 "Ürün İşlemleri" \
                       2 "Stok Hareketi" \
                       3 "Rapor Al" \
                       4 "Kullanıcı Yönetimi" \
                       5 "Program Yönetimi" \
                       6 "Çıkış" \
                       --width=560 --height=420 \
                       --icon="gtk-home"
            )
        else
            SECIM=$(
                zenity --list \
                       --title="Ana Menü (Kullanıcı)" \
                       --text="<span font='9' foreground='#2D3436'>Lütfen yapmak istediğiniz işlemi seçiniz.</span>" \
                       --column="Numara" --column="İşlem" \
                       1 "Ürün İşlemleri" \
                       2 "Stok Hareketi (Yönetici)" \
                       3 "Rapor Al" \
                       4 "Kullanıcı Yönetimi (Yönetici)" \
                       5 "Program Yönetimi (Yönetici)" \
                       6 "Çıkış" \
                       --width=560 --height=420 \
                       --icon="gtk-home"
            )
        fi

        if [ -z "$SECIM" ]; then
            zenity --question \
                   --title="Çıkış" \
                   --text="<span foreground='#d63031'>Programdan çıkmak istediğinize emin misiniz?</span>" \
                   --icon-name="gtk-quit" \
                   --width=350 --height=150
            if [ $? -eq 0 ]; then
                exit 0
            else
                continue
            fi
        fi

        case "$SECIM" in
            "1")
                urunMenu
                ;;
            "2")
        	if [ "$GIRIS_YAPMIS_ROL" == "Yonetici" ]; then
                    stokHareketiMenu
                else
                    zenity --error --text="<span foreground='red'>Bu işlemi yapmaya yetkiniz yok!</span>"
            	fi
            	;;
            "3")
                raporAl
                ;;
            "4")
                if [ "$GIRIS_YAPMIS_ROL" == "Yonetici" ]; then
                    kullaniciYonetimi
                else
                    zenity --error --text="<span foreground='red'>Bu işlemi yapmaya yetkiniz yok!</span>"
                fi
                ;;
            "5")
                if [ "$GIRIS_YAPMIS_ROL" == "Yonetici" ]; then
                    programYonetimi
                else
                    zenity --error --text="<span foreground='red'>Bu işlemi yapmaya yetkiniz yok!</span>"
                fi
                ;;
            "6")
                zenity --question \
                       --title="Çıkış" \
                       --text="<span foreground='#d63031'>Programdan çıkmak istediğinize emin misiniz?</span>" \
                       --icon-name="gtk-quit" \
                       --width=350 --height=150
                if [ $? -eq 0 ]; then
                    exit 0
                fi
                ;;
            *)
                continue
                ;;
        esac
    done
}


# ------------------------------------------------------------------------------
# 6) ANA AKIŞ
# ------------------------------------------------------------------------------

# a) Dosyaları oluştur
dosyaKontrol

# b) Giriş
kullaniciGirisiYap

# c) Eğer giriş başarılıysa ana menüye git
if [ -n "$GIRIS_YAPMIS_KULLANICI" ]; then
    anaMenu
fi

