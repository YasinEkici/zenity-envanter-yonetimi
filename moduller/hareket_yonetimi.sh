function stokHareketiMenu() {
    # Kullanıcıyı stok işlemlerinden birini seçmesi için Zenity arayüzü ile yönlendirir.
    while true
    do
        # İşlem seçimi için liste menüsü
        SECIM=$(zenity --list \
            --title="Stok Hareketi" \
            --text="Hangi işlemi yapmak istiyorsunuz?" \
            --column="No" --column="İşlem" \
            1 "Stok Girişi" \
            2 "Stok Çıkışı" \
            3 "Hareketleri Listele" \
            4 "Geri Dön" \
            --width=400 --height=350)

        # Kullanıcı bir seçim yapmazsa döngüden çık
        [ -z "$SECIM" ] && break

        # Seçime göre ilgili işlemi çağır
        case "$SECIM" in
            "1") stokGirisi ;;        # Stok girişi işlemi
            "2") stokCikisi ;;        # Stok çıkışı işlemi
            "3") hareketleriListele ;;# Stok hareketlerini listeleme
            "4") break ;;             # Menüyü sonlandır
        esac
    done
}

function stokGirisi() {
    # Kullanıcıdan stok girişi bilgilerini almak için form aç
    local FORM_RESULT
    FORM_RESULT=$(zenity --forms --title="Stok Girişi" \
        --text="Stok girişi yapılacak ürün ve adet giriniz." \
        --add-entry="Ürün No" \
        --add-entry="Adet" \
        --separator=",")

    # Kullanıcı formu doldurmazsa işlemi iptal et
    if [ -z "$FORM_RESULT" ]; then
        zenity --info --text="İşlem iptal edildi."
        return
    fi

    # Formdan gelen ürün no ve adet bilgilerini ayıkla
    local urunNo adet
    urunNo=$(echo "$FORM_RESULT" | cut -d',' -f1)
    adet=$(echo "$FORM_RESULT" | cut -d',' -f2)

    # Ürün depo.csv dosyasında mevcut mu kontrol et
    local satir
    satir=$(grep "^$urunNo," "$DEPO_FILE")
    if [ -z "$satir" ]; then
        zenity --error --text="Bu no değerine sahip ürün bulunamadı!"
        return
    fi

    # Ürünün mevcut stok bilgilerini ve diğer detaylarını al
    local no urunAdi eskiStok fiyat kategori
    no=$(echo "$satir" | cut -d',' -f1)
    urunAdi=$(echo "$satir" | cut -d',' -f2)
    eskiStok=$(echo "$satir" | cut -d',' -f3)
    fiyat=$(echo "$satir" | cut -d',' -f4)
    kategori=$(echo "$satir" | cut -d',' -f5)

    # Adet sayısal bir değer mi kontrol et
    if [[ ! "$adet" =~ ^[0-9]+$ ]]; then
        zenity --error --text="Adet sadece sayısal olmalı!"
        return
    fi

    # Yeni stok miktarını hesapla
    local yeniStok=$((eskiStok + adet))

    # Stok güncelleme işlemini görselleştir
    (
      echo "0"
      sleep 1
      echo "50"
      sleep 1
      echo "100"
    ) | zenity --progress --title="Stok Güncelleniyor" \
              --text="Stok girişi yapılıyor..." \
              --auto-close --no-cancel

    # Depo dosyasını yeni stok bilgisiyle güncelle
    grep -v "^$no," "$DEPO_FILE" > "$DEPO_FILE.tmp"
    echo "$no,$urunAdi,$yeniStok,$fiyat,$kategori" >> "$DEPO_FILE.tmp"
    mv "$DEPO_FILE.tmp" "$DEPO_FILE"

    # Yeni stok hareketini hareket.csv dosyasına ekle
    local maxHareketNo=0
    if [ -s "$HAREKET_FILE" ]; then
        maxHareketNo=$(awk -F',' '{print $1}' $HAREKET_FILE | sort -n | tail -1)
    fi
    local yeniHareketNo=$((maxHareketNo + 1))
    local now=$(date '+%Y-%m-%d %H:%M:%S')

    # Hareket bilgilerini dosyaya yaz
    echo "$yeniHareketNo,$no,$now,giris,$adet,$GIRIS_YAPMIS_KULLANICI" >> "$HAREKET_FILE"

    # İşlem tamamlandığında kullanıcıyı bilgilendir
    zenity --info --text="Stok girişi başarılı!\nYeni stok: $yeniStok"
}

function stokCikisi() {
    # Kullanıcıdan stok çıkışı bilgilerini almak için form aç
    local FORM_RESULT
    FORM_RESULT=$(zenity --forms --title="Stok Çıkışı" \
        --text="Stok çıkışı yapılacak ürün ve adet giriniz." \
        --add-entry="Ürün No" \
        --add-entry="Adet" \
        --separator=",")

    # Kullanıcı formu doldurmazsa işlemi iptal et
    if [ -z "$FORM_RESULT" ]; then
        zenity --info --text="İşlem iptal edildi."
        return
    fi

    # Formdan gelen ürün no ve adet bilgilerini ayıkla
    local urunNo adet
    urunNo=$(echo "$FORM_RESULT" | cut -d',' -f1)
    adet=$(echo "$FORM_RESULT" | cut -d',' -f2)

    # Ürün depo.csv dosyasında mevcut mu kontrol et
    local satir
    satir=$(grep "^$urunNo," "$DEPO_FILE")
    if [ -z "$satir" ]; then
        zenity --error --text="Bu no değerine sahip ürün bulunamadı!"
        return
    fi

    # Ürünün mevcut stok bilgilerini ve diğer detaylarını al
    local no urunAdi eskiStok fiyat kategori
    no=$(echo "$satir" | cut -d',' -f1)
    urunAdi=$(echo "$satir" | cut -d',' -f2)
    eskiStok=$(echo "$satir" | cut -d',' -f3)
    fiyat=$(echo "$satir" | cut -d',' -f4)
    kategori=$(echo "$satir" | cut -d',' -f5)

    # Adet sayısal bir değer mi kontrol et
    if [[ ! "$adet" =~ ^[0-9]+$ ]]; then
        zenity --error --text="Adet sadece sayısal olmalı!"
        return
    fi

    # Yeterli stok var mı kontrol et
    if [ "$eskiStok" -lt "$adet" ]; then
        zenity --error --text="Stok yetersiz! Eski stok: $eskiStok, çıkış: $adet"
        return
    fi

    # Yeni stok miktarını hesapla
    local yeniStok=$((eskiStok - adet))

    # Stok güncelleme işlemini görselleştir
    (
      echo "0"
      sleep 1
      echo "50"
      sleep 1
      echo "100"
    ) | zenity --progress --title="Stok Güncelleniyor" \
              --text="Stok çıkışı yapılıyor..." \
              --auto-close --no-cancel

    # Depo dosyasını yeni stok bilgisiyle güncelle
    grep -v "^$no," "$DEPO_FILE" > "$DEPO_FILE.tmp"
    echo "$no,$urunAdi,$yeniStok,$fiyat,$kategori" >> "$DEPO_FILE.tmp"
    mv "$DEPO_FILE.tmp" "$DEPO_FILE"

    # Yeni stok hareketini hareket.csv dosyasına ekle
    local maxHareketNo=0
    if [ -s "$HAREKET_FILE" ]; then
        maxHareketNo=$(awk -F',' '{print $1}' $HAREKET_FILE | sort -n | tail -1)
    fi
    local yeniHareketNo=$((maxHareketNo + 1))
    local now=$(date '+%Y-%m-%d %H:%M:%S')

    # Hareket bilgilerini dosyaya yaz
    echo "$yeniHareketNo,$no,$now,cikis,$adet,$GIRIS_YAPMIS_KULLANICI" >> "$HAREKET_FILE"

    # İşlem tamamlandığında kullanıcıyı bilgilendir
    zenity --info --text="Stok çıkışı başarılı!\nKalan stok: $yeniStok"
}

function hareketleriListele() {
    # Stok hareket dosyasında kayıt var mı kontrol et
    if [ ! -s "$HAREKET_FILE" ]; then
        zenity --info --text="Henüz stok hareket kaydı bulunmuyor."
        return
    fi

    # Hareket dosyasını formatlı olarak oku ve ekranda göster
    local output="Hareket_No,Urun_No,Tarih,Tip,Adet,Kullanici\n"
    while IFS=',' read -r hno uno tarih tip adet kullanici
    do
        output+="$hno,$uno,$tarih,$tip,$adet,$kullanici\n"
    done < "$HAREKET_FILE"

    # Zenity ile hareket listesini göster
    echo -e "$output" | column -t -s ',' | zenity --text-info \
        --title="Stok Hareketleri" \
        --width=700 --height=400 \
        --font="Monospace 10"
}

