Basit Envanter Yönetim Sistemi (Zenity + Bash)

Bu proje, Bash betikleri ve Zenity kütüphanesi kullanılarak oluşturulmuş basit bir Envanter Yönetim Sistemi örneğidir. Projede aşağıdaki fonksiyonları gerçekleştirebilen bir grafik arayüz (GUI) sunulur:

    Ürün Yönetimi (Ekle / Listele / Güncelle / Sil)
    Stok Hareketleri (Giriş / Çıkış / Listeleme)
    Raporlar (Stokta azalan ürünler, en yüksek stoklu ürünler, kategori bazlı, fiyat aralığı)
    Kullanıcı Yönetimi (Yeni kullanıcı ekle, listele, güncelle, sil)
    Program Yönetimi (Dosya yedekleme, disk alanı görüntüleme, log kayıtlarını gösterme)

Ayrıca sistemde Yönetici ve Kullanıcı adlı iki farklı rol bulunur.

    Yönetici: Tüm işlemleri yapabilir.
    Kullanıcı: Yalnızca görüntüleme ve raporlama gibi sınırlı işlemleri yapabilir.

İçindekiler

    Genel Özellikler
    Proje Dosya Yapısı
    Kurulum ve Çalıştırma
    Kullanım Adımları
    CSV Dosyaları
    Ekran Görüntüleri (örnek placeholder)
    Sık Karşılaşılan Sorunlar
    Katkıda Bulunma

Genel Özellikler

    Zenity aracılığıyla masaüstü diyalog pencereleri kullanır.
    Basit bir login ekranı ve kullanıcı yönetimi sunar.
    CSV dosyalarını temel veri deposu olarak kullanır (veritabanı yok).
    Stok giriş/çıkış işlemleri için ayrı bir menü vardır.
    Raporlama modülünde çeşitli filtrelemeler yapılabilir (örnek: stok eşiği, kategori, fiyat aralığı).
    Program Yönetimi bölümünde disk alanı gösterme, dosyaları yedekleme ve log görüntüleme işlemleri vardır.
    Ani kapatma durumlarında (Ctrl + C vb.) trap mekanizmasıyla temizKapat fonksiyonu çağrılır, geçici dosyalar silinir ve log kayıtları güncellenir.

Proje Dosya Yapısı

proje-klasoru/
├── main.sh                       # Ana betik, uygulama burada başlatılıyor
├── moduller/
│   ├── program_yonetimi.sh       # Program yönetimi (yedek alma, disk alanı, log gösterme)
│   ├── urun_yonetimi.sh          # Ürün ekle, listele, güncelle, sil
│   ├── rapor_al.sh              # Rapor modülü (stok eşiği, fiyat aralığı vb.)
│   ├── hareket_yonetimi.sh       # Stok giriş/çıkış yönetimi (hareket kayıtları)
│   └── kullanici_yonetimi.sh     # Kullanıcı ekleme, listeleme, güncelle, sil
├── depo.csv                      # Ürün kayıtları
├── kullanici.csv                 # Kullanıcı bilgileri
├── log.csv                       # Hata ve kritik işlemlerin kaydı
└── hareket.csv                   # Stok hareket kayıtları

    main.sh: Projenin başlangıç dosyası. Giriş (login) ve ana menü burada yer alır.
    moduller/ dizini: Her bir alt fonksiyonun (program yönetimi, ürün yönetimi vs.) kendi betiği bulunur.
    .csv dosyaları: Uygulamanın veri depolama dosyaları.

Kurulum ve Çalıştırma

    Zenity’nin kurulu olduğundan emin olun
        Çoğu Linux dağıtımında ön yüklü gelir. Eğer eksikse, Ubuntu/Debian türevi sistemlerde:

    sudo apt-get install zenity

Proje klasörünü klonlayın veya indirin

git clone https://github.com/kullanici-adi/envanter.git
cd envanter

Dosyaya çalıştırma izni verin

chmod +x main.sh

main.sh betiğini çalıştırın

    ./main.sh

    Not: Projeyi ilk kez çalıştırdığınızda, kullanici.csv, depo.csv, log.csv ve hareket.csv yoksa otomatik oluşturulur. Ayrıca varsayılan bir yönetici kullanıcı (admin / 12345) tanımlanır.

Kullanım Adımları

    Giriş Ekranı
        Kullanıcı adı (örn. admin) ve parola (12345) girişi yapılır.
        3 kez hatalı parola girilirse hesap kilitlenir.
        Yönetici kilidini kullanıcı güncelleme ekranından açabilir.

    Ana Menü
        Ürün İşlemleri (Ürün ekleme, listeleme, güncelleme, silme)
        Stok Hareketi (Stok girişi, çıkışı, hareketleri listeleme)
        Rapor Al (Azalan stok, yüksek stok, kategori/fiyat bazlı raporlar)
        Kullanıcı Yönetimi (yeni ekle, listele, güncelle, sil)
        Program Yönetimi (disk alanı göster, yedekleme, log görüntüleme)
        Çıkış (programdan güvenli çıkış)

    Ürün Ekle / Listele / Güncelle / Sil
        Ürün Ekle: Ürün adı, stok, fiyat, kategori girilir. “No” alanı otomatik üretilir.
        Ürün Listele: Tüm ürünler tablolu biçimde görünür.
        Ürün Güncelle: Ürün adını girerek stok/fiyat değerlerini değiştirebilirsiniz.
        Ürün Sil: Ürün adını girerek ilgili ürünü CSV’den silersiniz.
        Sadece Yönetici rolü bu işlemleri yapabilir, normal kullanıcı listeleme haricinde işlem yapamaz.

    Stok Hareketi
        Stok Girişi: Bir ürün no ve miktar girerek stok arttırabilirsiniz.
        Stok Çıkışı: Var olan stoktan çıkarma (satış vb.) işlemi.
        Hareketleri Listele: Tüm giriş/çıkış hareketlerini tablo şeklinde görüntüler.

    Rapor Al
        Stokta Azalan Ürünler: Kullanıcıdan bir eşik değer istenir ve o eşiğin altındaki stoklar listelenir.
        En Yüksek Stoklu Ürünler: Bir üst eşik girerek o değerin üstündeki stokları listeler.
        Kategori Bazlı Rapor: İstenen kategorideki tüm ürünleri sunar.
        Fiyat Aralığı Raporu: Minimum / maksimum fiyat aralığında ürünleri listeler.

    Kullanıcı Yönetimi
        Yeni Kullanıcı Ekle: Kullanıcı adı, ad, soyad, rol, parola (md5) girilir.
        Kullanıcıları Listele: Hepsi tablolu biçimde gözükür.
        Kullanıcı Güncelle: Mevcut bir kullanıcıyı (no ile) arayarak ad, soyad, rol, kilitli mi vb. bilgilerini değiştirebilirsiniz.
        Kullanıcı Sil: No ile bulup silebilirsiniz.

    Program Yönetimi
        Diskteki Toplam Alanı Göster: depo.csv, kullanici.csv, log.csv ve hareket.csv dosyalarının toplam boyutunu ekrana getirir.
        Diske Yedekle: Bu üç (veya dört) CSV dosyasını belirttiğiniz klasöre .bak uzantısıyla kopyalar.
        Hata Kayıtlarını Göster: log.csv içeriğini tablolu biçimde gösterir.

CSV Dosyaları

Projedeki veriler CSV dosyalarında saklanır:

    depo.csv
        Format: no,urun_adi,stok,birim_fiyat,kategori
        Ürün numarası (no) otomatik artar. Ürün adı + kategori kombinasyonu tekil kabul edilir.

    kullanici.csv
        Format: kullanici_no,username,ad,soyad,rol,md5_parola,kilitli_mi,deneme_sayisi
        Yeni kullanıcı eklendiğinde max kullanici_no + 1 olacak şekilde kaydedilir.
        kilitli_mi: evet veya hayir. 3 kez hatalı giriş yaparsa evet olur.
        deneme_sayisi: Hatalı parola deneme adedi tutulur.

    log.csv
        Format: hata_numarası,tarih_saat,kullanıcı_adı,işlem,mesaj
        Hata ve kritik durumlarda (ürün silme, aynı adlı ürün ekleme vb.) buraya ek satır yazar.

    hareket.csv
        Format: hareket_no,urun_no,islem_tarihi,tip,adet,kullanici
        Stok hareketleri (giriş / çıkış) bu dosyada tutulur.
        tip: giris veya cikis.
        hareket_no otomatik artar.

Ekran Görüntüleri

    Giriş Ekranı
![Screenshot from 2025-01-05 20-40-47](https://github.com/user-attachments/assets/befa6f5f-c0e8-4510-be67-10e7215286b1)

    Ana Menü

    Ürün Listeleme (Örnek tablo görünümü)

    Stok Hareketi

    Rapor Alma

    Kullanıcı Yönetimi

Sık Karşılaşılan Sorunlar

    “Admin” olarak giriş yapamıyorum
        kullanici.csv içinde 2. sütundaki username değeri “admin” mi kontrol edin. Parola 12345 (MD5: 827ccb0eea8a706c4c34a16891f84e7b) olmalı.
    Boş CSV dosyası sorunları
        depo.csv ve kullanici.csv ilk kez oluşturulurken başlık satırı yoktur, ancak script çalışmayı sürdürür.
    Stok çıkışı yapılırken “stok yetersiz” hatası
        eskiStok değerini kontrol edin; çıkış miktarından küçükse bu hatayı alırsınız.
    Zaman zaman tablo hizaları kayık görünüyor
        column -t -s "," komutu ile veriler “virgüle göre hizalanır”. Her satırda aynı sütun sayısı olmasına dikkat edin.

Katkıda Bulunma

    Projeyi klonlayarak ya da forkladıktan sonra pull request gönderebilirsiniz.
    Yeni rapor türleri, ek validasyon kuralları veya arayüz iyileştirmeleri memnuniyetle karşılanır.
    Hata veya önerileriniz için issue açabilirsiniz.

Teşekkürler! Bu basit envanter yönetim sistemi örneğini geliştirirken keyif alacağınızı umuyoruz. Bash ve Zenity ile daha büyük projeler yapabilmek için bu örneği başlangıç noktası olarak kullanabilirsiniz.

İyi çalışmalar!
