function kullaniciYonetimi() {
    # Kullanıcı yönetimi menüsü
    while true
    do
        # Kullanıcıdan bir işlem seçmesi istenir
        SECIM=$(
            zenity --list \
                   --title="Kullanıcı Yönetimi" \
                   --text="<span font='10' foreground='#2D3436'>Yapmak istediğiniz işlemi seçiniz.</span>" \
                   --column="No" --column="İşlem" \
                   1 "Yeni Kullanıcı Ekle" \
                   2 "Kullanıcıları Listele" \
                   3 "Kullanıcı Güncelle" \
                   4 "Kullanıcı Sil" \
                   5 "Geri Dön" \
                   --width=400 --height=420 \
                   --icon="gtk-preferences"
        )

        # Seçim yapılmazsa döngüden çıkılır
        if [ -z "$SECIM" ]; then
            break
        fi

        # Seçime göre işlem çağırılır
        case "$SECIM" in
            "1") yeniKullaniciEkle ;;       # Yeni kullanıcı ekleme
            "2") kullanicilariListele ;;    # Kullanıcıları listeleme
            "3") kullaniciGuncelle ;;       # Kullanıcı güncelleme
            "4") kullaniciSil ;;            # Kullanıcı silme
            "5") break ;;                   # Menüyü kapatma
        esac
    done
}

function yeniKullaniciEkle() {
    # Yeni kullanıcı bilgilerini almak için form açılır
    local FORM_RESULT
    FORM_RESULT=$(
        zenity --forms \
               --title="Yeni Kullanıcı Ekle" \
               --text="<span foreground='#2D3436'>Kullanıcı bilgilerini giriniz.</span>" \
               --add-entry="Kullanıcı Adı" \
               --add-entry="Ad" \
               --add-entry="Soyad" \
               --add-combo="Rol" --combo-values="Yonetici|Kullanici" \
               --add-password="Parola" \
               --separator="," \
               --width=400 --height=300
    )

    # Kullanıcı formu iptal ederse işlem durdurulur
    if [ -z "$FORM_RESULT" ]; then
        zenity --info --text="<span foreground='#636e72'>Kullanıcı ekleme iptal edildi.</span>"
        return
    fi

    # Form verileri ayrıştırılır
    local uname ad soyad rol sifre
    uname=$(echo "$FORM_RESULT" | cut -d',' -f1)
    ad=$(echo "$FORM_RESULT" | cut -d',' -f2)
    soyad=$(echo "$FORM_RESULT" | cut -d',' -f3)
    rol=$(echo "$FORM_RESULT" | cut -d',' -f4)
    sifre=$(echo "$FORM_RESULT" | cut -d',' -f5)

    # Tüm alanların doldurulup doldurulmadığı kontrol edilir
    if [[ -z "$uname" || -z "$ad" || -z "$soyad" || -z "$rol" || -z "$sifre" ]]; then
        zenity --error --title="Hata" \
               --text="<span foreground='red'>Tüm alanları doldurmalısınız!</span>"
        logKaydet "ERR_USER_001" "$GIRIS_YAPMIS_KULLANICI" "Kullanıcı Ekle" "Boş alan"
        return
    fi

    # Geçerli rol kontrolü
    if [ "$rol" != "Yonetici" ] && [ "$rol" != "Kullanici" ]; then
        zenity --error --title="Hata" \
               --text="<span foreground='red'>Geçersiz rol seçimi: $rol</span>"
        logKaydet "ERR_USER_002" "$GIRIS_YAPMIS_KULLANICI" "Kullanıcı Ekle" "Hatalı rol ($rol)"
        return
    fi

    # Parola MD5 hash'i alınır
    local md5_sifre
    md5_sifre=$(echo -n "$sifre" | md5sum | awk '{print $1}')

    # Yeni kullanıcı numarası belirlenir
    local maxNo=0
    if [ -s "$KULLANICI_FILE" ]; then
        maxNo=$(awk -F',' '{print $1}' "$KULLANICI_FILE" | sort -n | tail -1)
    fi
    local yeniNo=$((maxNo+1))

    # Kullanıcı ekleme işlemi için ilerleme çubuğu gösterilir
    (
      echo "0"
      sleep 1
      echo "50"
      sleep 1
      echo "100"
    ) | zenity --progress \
          --title="Kullanıcı Ekleniyor" \
          --text="Kullanıcı ekleniyor..." \
          --auto-close --no-cancel \
          --width=350 --height=100

    # Yeni kullanıcı bilgileri dosyaya yazılır
    echo "$yeniNo,$uname,$ad,$soyad,$rol,$md5_sifre,hayir,0" >> "$KULLANICI_FILE"

    # Kullanıcıya başarı mesajı gösterilir
    zenity --info --title="Başarılı" \
           --text="<span foreground='#00b894'><b>Yeni kullanıcı eklendi:</b> $ad $soyad ($rol)</span>"
}

function kullanicilariListele() {
    # Kullanıcı dosyasının mevcut olup olmadığı kontrol edilir
    if [ ! -s "$KULLANICI_FILE" ]; then
        zenity --info --text="Hiç kullanıcı bulunmuyor."
        return
    fi

    # Kullanıcı listesi formatlanır
    local output="No,Username,Ad,Soyad,Rol,MD5_Parola,Kilitli,Deneme\n"

    # Kullanıcı verileri dosyadan okunur
    while IFS=',' read -r no username ad soyad rol parolaMd5 kilitliMi denemeSayisi
    do
        output+="$no,$username,$ad,$soyad,$rol,$parolaMd5,$kilitliMi,$denemeSayisi\n"
    done < "$KULLANICI_FILE"

    # Kullanıcı listesi Zenity ile gösterilir
    echo -e "$output" | column -t -s "," | zenity --text-info \
        --title="Kullanıcı Listesi" \
        --width=900 --height=450 \
        --ok-label="Kapat" \
        --font="Monospace 10"
}

function kullaniciSil() {
    # Silinecek kullanıcı için no değeri istenir
    local silNo
    silNo=$(zenity --entry \
        --title="Kullanıcı Sil" \
        --text="Silinecek kullanıcının No değerini giriniz:" \
        --width=350 --height=150)

    # No verilmediyse işlem iptal edilir
    if [ -z "$silNo" ]; then
        zenity --info --text="<span foreground='#636e72'>İşlem iptal edildi.</span>"
        return
    fi

    # Kullanıcı aranır
    local satir
    satir=$(grep "^$silNo," "$KULLANICI_FILE")
    if [ -z "$satir" ]; then
        zenity --error --title="Hata" \
               --text="<span foreground='red'>Bu no değerine sahip kullanıcı yok!</span>"
        logKaydet "ERR_USER_004" "$GIRIS_YAPMIS_KULLANICI" "Kullanıcı Silme" "Bulunamadı ($silNo)"
        return
    fi

    # Silme işlemi için onay istenir
    zenity --question \
           --title="Kullanıcı Sil" \
           --text="<span foreground='#d63031'>Bu kullanıcıyı silmek istediğinize emin misiniz?\n\n$satir</span>" \
           --icon-name="gtk-delete" \
           --width=400 --height=200
    if [ $? -ne 0 ]; then
        return
    fi

    # Silme işlemi için ilerleme çubuğu gösterilir
    (
      echo "0"
      sleep 1
      echo "50"
      sleep 1
      echo "100"
    ) | zenity --progress \
          --title="Kullanıcı Siliniyor" \
          --text="Lütfen bekleyin..." \
          --auto-close --no-cancel \
          --width=350 --height=100

    # Kullanıcı dosyadan silinir
    grep -v "^$silNo," "$KULLANICI_FILE" > "$KULLANICI_FILE.tmp"
    mv "$KULLANICI_FILE.tmp" "$KULLANICI_FILE"

    # Kullanıcıya başarı mesajı gösterilir
    zenity --info --title="Silindi" \
           --text="<span foreground='#e74c3c'><b>Kullanıcı silindi:</b> $silNo</span>"
}

