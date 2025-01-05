function urunMenu() {
    while true
    do
        SECIM=$(zenity --list \
            --title="Ürün İşlemleri" \
            --text="Hangi işlemi yapmak istiyorsunuz?" \
            --column="No" --column="İşlem" \
            1 "Ürün Ekle" \
            2 "Ürün Listele" \
            3 "Ürün Güncelle" \
            4 "Ürün Sil" \
            5 "Geri Dön" \
            --width=400 --height=400)

        [ -z "$SECIM" ] && break

        case "$SECIM" in
            "1") if [ "$GIRIS_YAPMIS_ROL" == "Yonetici" ]; then
                    urunEkle
                else
                    zenity --error --text="<span foreground='red'>Bu işlemi yapmaya yetkiniz yok!</span>"
            	fi
            	;; 
            "2") urunListele ;;
            "3") if [ "$GIRIS_YAPMIS_ROL" == "Yonetici" ]; then
                    urunGuncelle
                else
                    zenity --error --text="<span foreground='red'>Bu işlemi yapmaya yetkiniz yok!</span>"
            	fi 
            	;;
            "4") if [ "$GIRIS_YAPMIS_ROL" == "Yonetici" ]; then
                    urunSil
                else
                    zenity --error --text="<span foreground='red'>Bu işlemi yapmaya yetkiniz yok!</span>"
            	fi 
            	;;
            "5") break ;;
        esac
    done
}
function urunEkle() {
    local FORM_RESULT
    FORM_RESULT=$(
        zenity --forms \
               --title="Ürün Ekle" \
               --icon="gtk-add" \
               --text="<span font='10' foreground='#2D3436'>Yeni ürün bilgilerini giriniz.</span>" \
               --add-entry="Ürün Adı" \
               --add-entry="Stok" \
               --add-entry="Birim Fiyatı" \
               --add-entry="Kategori" \
               --separator="," \
               --width=400 --height=300
    )

    if [ -z "$FORM_RESULT" ]; then
        zenity --info \
               --title="İptal" \
               --text="<span foreground='#636e72'>Ürün ekleme iptal edildi.</span>" \
               --width=300
        return
    fi

    local urunAdi stok birimFiyat kategori
    urunAdi=$(echo "$FORM_RESULT" | cut -d',' -f1)
    stok=$(echo "$FORM_RESULT" | cut -d',' -f2)
    birimFiyat=$(echo "$FORM_RESULT" | cut -d',' -f3)
    kategori=$(echo "$FORM_RESULT" | cut -d',' -f4)

    # Boşluk kontrolü
    if [[ "$urunAdi" =~ [[:space:]] ]] || [[ "$kategori" =~ [[:space:]] ]]; then
        zenity --error --title="Hata" \
               --text="<span foreground='red'>Ürün adı ve kategori alanlarında boşluk olmamalı!</span>"
        logKaydet "ERR_PROD_001" "$GIRIS_YAPMIS_KULLANICI" "Ürün Ekleme" "Boşluk hatası ($urunAdi/$kategori)"
        return
    fi

    # Stok integer kontrolü
    if [[ ! "$stok" =~ ^[0-9]+$ ]]; then
        zenity --error --title="Hata" \
               --text="<span foreground='red'>Stok miktarı (0 veya +) rakam olmalı!</span>"
        logKaydet "ERR_PROD_002" "$GIRIS_YAPMIS_KULLANICI" "Ürün Ekleme" "Geçersiz stok ($stok)"
        return
    fi

    # Fiyat float mu?
    if [[ ! "$birimFiyat" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        zenity --error --title="Hata" \
               --text="<span foreground='red'>Birim fiyat sayısal (örnek: 12.50) olmalı!</span>"
        logKaydet "ERR_PROD_003" "$GIRIS_YAPMIS_KULLANICI" "Ürün Ekleme" "Geçersiz fiyat ($birimFiyat)"
        return
    fi

    # Aynı ad var mı?
    local varmi
    varmi=$(awk -F',' -v ad="$urunAdi" -v kat="$kategori" \
        '{if($2==ad && $5==kat) print $0}' "$DEPO_FILE")

    if [ -n "$varmi" ]; then
        zenity --error --text="Bu ürün adı + kategori kombinasyonuyla kayıt zaten var. Lütfen farklı bir ad veya kategori seçin."
        logKaydet "ERR_PROD_004" "$GIRIS_YAPMIS_KULLANICI" "Ürün Ekleme" "Aynı ürün adı ($urunAdi)"
        return
    fi

    local maxNo=0
    if [ -s "$DEPO_FILE" ]; then
        maxNo=$(awk -F',' '{print $1}' "$DEPO_FILE" | sort -n | tail -1)
    fi
    local yeniNo=$((maxNo+1))

    (
      echo "0"
      sleep 1
      echo "50"
      sleep 1
      echo "100"
    ) | zenity --progress \
          --title="Ürün Ekleniyor" \
          --text="Yeni ürün kaydı ekleniyor..." \
          --auto-close --no-cancel \
          --width=400 --height=100

    echo "$yeniNo,$urunAdi,$stok,$birimFiyat,$kategori" >> "$DEPO_FILE"

    zenity --info --title="Başarılı" \
           --text="<span foreground='#00b894'>Ürün başarıyla eklendi\n(Ürün No: $yeniNo)</span>" \
           --width=300
}

function urunListele() {
    if [ ! -s "$DEPO_FILE" ]; then
        zenity --info --title="Bilgi" \
               --text="<span foreground='#636e72'>Envanterde henüz ürün yok.</span>"
        return
    fi

    local output="No,Ürün_Adı,Stok,Birim_Fiyat,Kategori\n"
    while IFS=',' read -r no ad stok fiyat kat
    do
        output+="$no,$ad,$stok,$fiyat,$kat\n"
    done < "$DEPO_FILE"

    echo -e "$output" | column -t -s "," | zenity --text-info \
        --title="Ürün Listesi" \
        --width=650 --height=450 \
        --ok-label="Kapat" \
        --font="Monospace 10"
}

function urunGuncelle() {
    local guncelAd
    guncelAd=$(zenity --entry --title="Ürün Güncelle" \
        --text="Güncellenecek ürünün adını giriniz:")

    if [ -z "$guncelAd" ]; then
        zenity --info --text="İşlem iptal edildi."
        return
    fi

    # -F => Fixed string araması (regex özel karakter sorunlarını önler)
    # Aradığımız string: ",$guncelAd," => CSV'de tam sütun eşleşmesi
    local satir
    satir=$(grep -F ",$guncelAd," "$DEPO_FILE")

    if [ -z "$satir" ]; then
        zenity --error --text="Bu isimde bir ürün bulunamadı!"
        logKaydet "ERR_PROD_005" "$GIRIS_YAPMIS_KULLANICI" "Ürün Güncelleme" "Ürün yok ($guncelAd)"
        return
    fi

    local no eskiAd eskiStok eskiFiyat eskiKat
    no=$(echo "$satir" | cut -d',' -f1)
    eskiAd=$(echo "$satir" | cut -d',' -f2)
    eskiStok=$(echo "$satir" | cut -d',' -f3)
    eskiFiyat=$(echo "$satir" | cut -d',' -f4)
    eskiKat=$(echo "$satir" | cut -d',' -f5)

    local FORM_RESULT
    FORM_RESULT=$(zenity --forms --title="Ürün Güncelle" \
        --text="Ürünün yeni stok ve fiyatını giriniz.\n(Eski stok: $eskiStok, eski fiyat: $eskiFiyat)" \
        --add-entry="Yeni Stok" \
        --add-entry="Yeni Birim Fiyat" \
        --separator=",")

    if [ -z "$FORM_RESULT" ]; then
        zenity --info --text="Güncelleme iptal edildi."
        return
    fi

    local yeniStok yeniFiyat
    yeniStok=$(echo "$FORM_RESULT" | cut -d',' -f1)
    yeniFiyat=$(echo "$FORM_RESULT" | cut -d',' -f2)

    # Validasyon
    if [[ ! "$yeniStok" =~ ^[0-9]+$ ]]; then
        zenity --error --text="Stok miktarı yalnızca sayısal değer olmalıdır!"
        logKaydet "ERR_PROD_006" "$GIRIS_YAPMIS_KULLANICI" "Ürün Güncelleme" "Geçersiz stok ($yeniStok)"
        return
    fi

    if [[ ! "$yeniFiyat" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        zenity --error --text="Birim fiyat yalnızca sayısal bir değer olmalıdır!"
        logKaydet "ERR_PROD_007" "$GIRIS_YAPMIS_KULLANICI" "Ürün Güncelleme" "Geçersiz fiyat ($yeniFiyat)"
        return
    fi

    (
      echo "0"
      sleep 1
      echo "50"
      sleep 1
      echo "100"
    ) | zenity --progress \
          --title="Ürün Güncelleniyor" \
          --text="Lütfen bekleyin..." \
          --auto-close --no-cancel

    # Burada da silerken no+ad eşleşmesine dikkat
    grep -v "^$no,$eskiAd," "$DEPO_FILE" > "$DEPO_FILE.tmp"
    echo "$no,$eskiAd,$yeniStok,$yeniFiyat,$eskiKat" >> "$DEPO_FILE.tmp"
    mv "$DEPO_FILE.tmp" "$DEPO_FILE"

    zenity --info --text="Ürün güncellendi: $eskiAd (Yeni Stok: $yeniStok, Yeni Fiyat: $yeniFiyat)"
}

function urunSil() {
    local silAd
    silAd=$(zenity --entry --title="Ürün Sil" \
        --text="Silmek istediğiniz ürünün adını giriniz:")

    if [ -z "$silAd" ]; then
        zenity --info --text="İşlem iptal edildi."
        return
    fi

    #-F kullanarak sabit dizge araması yapıyoruz
    local satir
    satir=$(grep -F ",$silAd," "$DEPO_FILE")

    if [ -z "$satir" ]; then
        zenity --error --text="Bu isimde bir ürün bulunamadı!"
        logKaydet "ERR_PROD_008" "$GIRIS_YAPMIS_KULLANICI" "Ürün Silme" "Ürün yok ($silAd)"
        return
    fi

    zenity --question --title="Ürün Sil" \
           --text="Bu ürünü silmek istediğinize emin misiniz?\n\n$silAd"
    if [ $? -ne 0 ]; then
        return
    fi

    (
      echo "0"
      sleep 1
      echo "50"
      sleep 1
      echo "100"
    ) | zenity --progress \
          --title="Ürün Siliniyor" \
          --text="Lütfen bekleyin..." \
          --auto-close --no-cancel

    # Silme işlemi
    local no ad
    no=$(echo "$satir" | cut -d',' -f1)
    ad=$(echo "$satir" | cut -d',' -f2)

    grep -v "^$no,$ad," "$DEPO_FILE" > "$DEPO_FILE.tmp"
    mv "$DEPO_FILE.tmp" "$DEPO_FILE"

    zenity --info --text="Ürün silindi: $ad"
}


