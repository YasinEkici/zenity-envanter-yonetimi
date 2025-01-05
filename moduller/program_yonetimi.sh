function programYonetimi() {
    # Program yönetimi menüsü
    while true
    do
        # Kullanıcıdan bir işlem seçmesi istenir
        SECIM=$(
            zenity --list \
                   --title="Program Yönetimi" \
                   --text="<span font='10' foreground='#2D3436'>Yapmak istediğiniz işlemi seçiniz.</span>" \
                   --column="No" --column="İşlem" \
                   1 "Diskteki Toplam Alanı Göster" \
                   2 "Diske Yedekle" \
                   3 "Hata Kayıtlarını Göster" \
                   4 "Geri Dön" \
                   --width=420 --height=380 \
                   --icon="gtk-execute"
        )

        # Seçim yapılmazsa döngüden çıkılır
        if [ -z "$SECIM" ]; then
            break
        fi

        # Seçime göre işlem çağırılır
        case "$SECIM" in
            "1") diskAlaniGoster ;;          # Diskteki toplam alanı göster
            "2") diskeYedekle ;;             # Dosyaları diske yedekle
            "3") hataKayitlariniGoster ;;    # Hata kayıtlarını göster
            "4") break ;;                    # Menüyü kapat
            *) continue ;;                   # Geçersiz seçim için devam et
        esac
    done
}

function diskAlaniGoster() {
    # Dosyaların toplam disk boyutunu hesaplar
    local output
    output=$(du -ch "$DEPO_FILE" "$KULLANICI_FILE" "$LOG_FILE" "$HAREKET_FILE" 2>/dev/null | grep total)

    # Dosyalar bulunamazsa hata mesajı göster
    if [ -z "$output" ]; then
        zenity --error --text="Dosyalar bulunamadı."
        return
    fi

    # Hesaplanan toplam boyut bilgisi alınır
    local size=$(echo "$output" | awk '{print $1}')
    # Kullanıcıya toplam boyut bilgisi gösterilir
    zenity --info --title="Disk Alanı" \
           --text="depo.csv + kullanici.csv + log.csv + hareket.csv dosyalarının toplam boyutu: $size"
}

function diskeYedekle() {
    # Kullanıcıdan yedekleme klasörü adı istenir
    local yedekKlasoru
    yedekKlasoru=$(zenity --entry --title="Yedek Klasörü" \
        --text="Yedeklerin kaydedileceği klasör adını giriniz (örnek: backup):")

    # Kullanıcı bir değer girmezse işlem iptal edilir
    if [ -z "$yedekKlasoru" ]; then
        zenity --info --text="Yedekleme iptal edildi."
        return
    fi

    # Yedekleme klasörü oluşturulur
    mkdir -p "$yedekKlasoru"

    # Yedekleme işlemi için ilerleme çubuğu gösterilir
    (
        echo "0"
        sleep 1
        echo "50"
        sleep 1
        echo "100"
    ) | zenity --progress \
          --title="Dosyalar Yedekleniyor" \
          --text="depo.csv, kullanici.csv ve hareket.csv kopyalanıyor..." \
          --auto-close --no-cancel

    # Dosyalar belirtilen klasöre yedeklenir
    cp "$DEPO_FILE" "$yedekKlasoru/depo.csv.bak" 2>/dev/null
    cp "$KULLANICI_FILE" "$yedekKlasoru/kullanici.csv.bak" 2>/dev/null
    cp "$HAREKET_FILE" "$yedekKlasoru/hareket.csv.bak" 2>/dev/null 

    # Yedekleme işlemi tamamlandığında bilgi mesajı gösterilir
    zenity --info --text="Yedekleme tamamlandı.\n\nKlasör: $yedekKlasoru"
}

function hataKayitlariniGoster() {
    # Hata kayıtlarının mevcut olup olmadığı kontrol edilir
    if [ ! -s "$LOG_FILE" ]; then
        zenity --info --text="Hata kaydı (log.csv) henüz boş."
        return
    fi

    # Hata kayıtlarının başlık satırı oluşturulur
    local output="Hata_No,Tarih_Saat,Kullanici,Islem,Mesaj\n"

    # Hata kayıtları dosyadan satır satır okunur
    while IFS=',' read -r hataNo zaman kullanici islem mesaj
    do
        output+="$hataNo,$zaman,$kullanici,$islem,$mesaj\n"
    done < "$LOG_FILE"

    # Hata kayıtları formatlanır ve kullanıcıya gösterilir
    echo -e "$output" | column -t -s ',' | zenity --text-info \
        --title="Hata Kayıtları (log.csv)" \
        --width=800 --height=400 \
        --font="Monospace 10"
}

