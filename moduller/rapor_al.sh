function raporAl() {
    while true
    do
        SECIM=$(
            zenity --list \
                   --title="Rapor Menüsü" \
                   --text="<span font='10' foreground='#2D3436'>Rapor türünü seçiniz.</span>" \
                   --column="No" --column="Rapor" \
                   1 "Stokta Azalan Ürünler" \
                   2 "En Yüksek Stok Miktarına Sahip Ürünler" \
                   3 "Kategori Bazlı Rapor" \
                   4 "Fiyat Aralığı Raporu" \
                   5 "Geri Dön" \
                   --width=420 --height=500 \
                   --icon="gtk-directory"
        )
        if [ -z "$SECIM" ]; then
            break
        fi

        case "$SECIM" in
            "1") stoktaAzalanRaporu ;;
            "2") yuksekStokRaporu ;;
            "3") kategoriBazliRapor ;;
            "4") fiyatAraligiRaporu ;;
            "5") break ;;
            *) continue ;;
        esac
    done
}

function stoktaAzalanRaporu() {
    local esik
    esik=$(zenity --entry --title="Stok Eşiği" --text="Şu değerden az olan ürünleri listele:")

    if [ -z "$esik" ]; then
        zenity --info --text="İşlem iptal edildi."
        return
    fi

    if [[ ! "$esik" =~ ^[0-9]+$ ]]; then
        zenity --error --text="Eşik değeri pozitif bir tam sayı olmalıdır!"
        return
    fi

    if [ ! -s "$DEPO_FILE" ]; then
        zenity --info --text="Hiç ürün yok. Rapor boş."
        return
    fi

    local output="No,Ürün_Adı,Stok,Birim_Fiyat,Kategori\n"
    while IFS=',' read -r no ad stok fiyat kat
    do
        if (( stok < esik )); then
            output+="$no,$ad,$stok,$fiyat,$kat\n"
        fi
    done < "$DEPO_FILE"

    if [ "$output" == "No,Ürün_Adı,Stok,Birim_Fiyat,Kategori\n" ]; then
        zenity --info --text="Stokta değeri $esik altına düşen ürün bulunamadı."
        return
    fi

    echo -e "$output" | column -t -s "," | zenity --text-info \
        --title="Stokta Azalan Ürünler (Eşik: $esik)" \
        --width=600 --height=400 \
        --font="Monospace 10"
}

function yuksekStokRaporu() {
    local esik
    esik=$(zenity --entry --title="Stok Eşiği" --text="Şu değerden yüksek/eşit olan ürünleri listele:")

    if [ -z "$esik" ]; then
        zenity --info --text="İşlem iptal edildi."
        return
    fi

    if [[ ! "$esik" =~ ^[0-9]+$ ]]; then
        zenity --error --text="Eşik değeri pozitif bir tam sayı olmalıdır!"
        return
    fi

    if [ ! -s "$DEPO_FILE" ]; then
        zenity --info --text="Hiç ürün yok. Rapor boş."
        return
    fi

    local output="No,Ürün_Adı,Stok,Birim_Fiyat,Kategori\n"
    while IFS=',' read -r no ad stok fiyat kat
    do
        if (( stok >= esik )); then
            output+="$no,$ad,$stok,$fiyat,$kat\n"
        fi
    done < "$DEPO_FILE"

    if [ "$output" == "No,Ürün_Adı,Stok,Birim_Fiyat,Kategori\n" ]; then
        zenity --info --text="Stok değeri $esik veya üstünde ürün bulunamadı."
        return
    fi

    echo -e "$output" | column -t -s "," | zenity --text-info \
        --title="En Yüksek Stoklu Ürünler (Eşik: $esik)" \
        --width=600 --height=400 \
        --font="Monospace 10"
}

function kategoriBazliRapor() {
    # Kullanıcıya bir kategori soralım.
    local secilenKategori
    secilenKategori=$(zenity --entry --title="Kategori Bazlı Rapor" \
        --text="Hangi kategorideki ürünleri listelemek istiyorsunuz?\n(Örn: Elektronik, Gıda, Kırtasiye)")

    if [ -z "$secilenKategori" ]; then
        zenity --info --text="İşlem iptal edildi."
        return
    fi

    if [ ! -s "$DEPO_FILE" ]; then
        zenity --info --text="Hiç ürün yok. Rapor boş."
        return
    fi

    local output="No,Ürün_Adı,Stok,Birim_Fiyat,Kategori\n"
    while IFS=',' read -r no ad stok fiyat kat
    do
        # Kategori eşleşmesi
        if [ "$kat" == "$secilenKategori" ]; then
            output+="$no,$ad,$stok,$fiyat,$kat\n"
        fi
    done < "$DEPO_FILE"

    if [ "$output" == "No,Ürün_Adı,Stok,Birim_Fiyat,Kategori\n" ]; then
        zenity --info --text="Bu kategoride ürün bulunamadı: $secilenKategori"
        return
    fi

    echo -e "$output" | column -t -s "," | zenity --text-info \
        --title="Kategori Bazlı Rapor: $secilenKategori" \
        --width=600 --height=400 \
        --font="Monospace 10"
}

function fiyatAraligiRaporu() {
    # İki eşik değeri (minFiyat, maxFiyat) isteyelim.
    local FORM_RESULT
    FORM_RESULT=$(zenity --forms --title="Fiyat Aralığı Raporu" \
        --text="Listelemek istediğiniz ürünlerin fiyat aralığını giriniz." \
        --add-entry="Minimum Fiyat" \
        --add-entry="Maksimum Fiyat (Boş bırakılırsa üst sınır yok)" \
        --separator=",")

    if [ -z "$FORM_RESULT" ]; then
        zenity --info --text="İşlem iptal edildi."
        return
    fi

    local minFiyat maxFiyat
    minFiyat=$(echo "$FORM_RESULT" | cut -d',' -f1)
    maxFiyat=$(echo "$FORM_RESULT" | cut -d',' -f2)

    # minFiyat sayı mı?
    if [[ ! "$minFiyat" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        zenity --error --text="Minimum fiyat pozitif bir sayısal değer olmalıdır!"
        return
    fi

    # maxFiyat boş olabilir veya sayısal olabilir
    if [ -n "$maxFiyat" ]; then
        if [[ ! "$maxFiyat" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            zenity --error --text="Maksimum fiyat geçerli bir sayı olmalıdır!"
            return
        fi
    fi

    if [ ! -s "$DEPO_FILE" ]; then
        zenity --info --text="Hiç ürün yok. Rapor boş."
        return
    fi

    local output="No,Ürün_Adı,Stok,Birim_Fiyat,Kategori\n"
    while IFS=',' read -r no ad stok fiyat kat
    do

        # 1) fiyat >= minFiyat?
        local isGeMin
        isGeMin=$(echo "$fiyat >= $minFiyat" | bc -l)
        # isGeMin = 1 => true, 0 => false

        # 2) varsa fiyat <= maxFiyat?
        if [ -n "$maxFiyat" ]; then
            local isLeMax
            isLeMax=$(echo "$fiyat <= $maxFiyat" | bc -l)

            if [ "$isGeMin" -eq 1 ] && [ "$isLeMax" -eq 1 ]; then
                output+="$no,$ad,$stok,$fiyat,$kat\n"
            fi
        else
            # maxFiyat girilmemişse sadece minFiyat kontrol
            if [ "$isGeMin" -eq 1 ]; then
                output+="$no,$ad,$stok,$fiyat,$kat\n"
            fi
        fi
    done < "$DEPO_FILE"

    if [ "$output" == "No,Ürün_Adı,Stok,Birim_Fiyat,Kategori\n" ]; then
        zenity --info --text="Bu fiyat aralığında ürün bulunamadı."
        return
    fi

    echo -e "$output" | column -t -s "," | zenity --text-info \
        --title="Fiyat Aralığı Raporu: $minFiyat - ${maxFiyat:-Sınırsız}" \
        --width=600 --height=400 \
        --font="Monospace 10"
}


