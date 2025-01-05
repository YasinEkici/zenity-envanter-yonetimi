YouTube Videosu: https://www.youtube.com/watch?v=cLIV2NU-BiA

Envanter Yönetim Sistemi 

Bu proje, **Bash betikleri** ve **Zenity** kütüphanesini kullanarak oluşturulmuş basit bir **Envanter Yönetim Sistemi** örneğidir. Proje kapsamında:

- Ürün Yönetimi (Ekle/Listele/Güncelle/Sil)  
- Stok Hareketi (Giriş/Çıkış/Listeleme)  
- Raporlama (Stok Eşiği, Kategori, Fiyat Aralığı vb.)  
- Kullanıcı Yönetimi (Ekle/Listele/Güncelle/Sil)  
- Program Yönetimi (Disk Alanı, Yedekleme, Log Kayıtları)  

gibi işlemler **Zenity** pencereleri ile bir **grafik arayüz** üzerinden yapılabilir. Sistemde **Yönetici** ve **Kullanıcı** rol ayrımı vardır. Yönetici tüm işlemleri yapabilir, kullanıcı sadece bazı görüntüleme/raporlama işlemleri yapabilir.

---

## İçindekiler

- [Özellikler](#özellikler)
- [Proje Dosya Yapısı](#proje-dosya-yapısı)
- [Kurulum ve Çalıştırma](#kurulum-ve-çalıştırma)
- [Kullanım Adımları](#kullanım-adımları)
- [CSV Dosyaları](#csv-dosyaları)
- [Ekran Görüntüleri](#ekran-görüntüleri)
- [Sık Karşılaşılan Sorunlar](#sık-karşılaşılan-sorunlar)
- [Katkıda Bulunma](#katkıda-bulunma)

---

## Özellikler

1. **Kullanıcı Girişi (Login)**  
   - Varsayılan Yönetici: `admin / 12345` (MD5: `827ccb0eea8a706c4c34a16891f84e7b`)  
   - 3 kez yanlış parola girildiğinde kullanıcı hesabı kilitlenir.  
   - Yönetici kilidi kullanıcı güncelleme ekranından açabilir.

2. **Ürün Yönetimi**  
   - **Yönetici** rolünde: Ürün ekleme, stok/fiyat güncelleme, silme ve listeleme.  
   - **Kullanıcı** rolünde: Sadece ürünleri listeleyebilir.

3. **Stok Hareketi**  
   - Stok girişi (ürün sayısını artırma) ve çıkışı (ürün sayısını azaltma)  
   - İşlemler `hareket.csv` dosyasında kaydedilir.

4. **Raporlar**  
   - Stokta azalan ürünler (eşik değer altında)  
   - En yüksek stoklu ürünler (eşik değer üzerinde)  
   - Kategori bazlı rapor  
   - Fiyat aralığı raporu

5. **Kullanıcı Yönetimi**  
   - Yeni kullanıcı ekleme, kullanıcı listeleme, kullanıcı güncelleme, silme.  
   - Kullanıcı rolü (Yönetici/Kullanıcı), kilit durumu ve hata sayısı da takip edilir.

6. **Program Yönetimi**  
   - Disk alanı göster (depo.csv, kullanici.csv, log.csv, hareket.csv boyutu)  
   - Dosyaları yedekleme  
   - Hata kayıtlarını (log.csv) görüntüleme

7. **Ani Kapatma Durumunda Temiz Çıkış**  
   - `trap` ile `SIGINT` ve `SIGTERM` yakalanır.  
   - `temizKapat` fonksiyonu devreye girer, `.tmp` dosyaları siler ve log kaydı alır.

---

## Proje Dosya Yapısı

```bash
proje-klasoru/
├── main.sh                       # Ana betik, uygulamanın başlangıç dosyası
├── moduller/
│   ├── program_yonetimi.sh       # Program yönetimi (disk alanı, yedekleme, log gösterme)
│   ├── urun_yonetimi.sh          # Ürün ekleme, listeleme, güncelleme, silme
│   ├── rapor_al.sh               # Rapor alma modülü
│   ├── hareket_yonetimi.sh       # Stok girişi/çıkışı, hareket kaydı
│   └── kullanici_yonetimi.sh     # Kullanıcı ekleme, listeleme, güncelleme, silme
├── depo.csv                      # Ürün kayıtları (no, ad, stok, fiyat, kategori)
├── kullanici.csv                 # Kullanıcı bilgileri (no, username, ad, soyad, rol, md5_parola, kilit, deneme)
├── log.csv                       # Hata ve kritik işlem log kayıtları
└── hareket.csv                   # Stok hareketleri (giriş/çıkış)

##Kurulum ve Çalıştırma

    Zenity’nin kurulu olduğundan emin olun
        Çoğu Linux dağıtımında ön yüklü gelir. Eğer eksikse, Ubuntu/Debian türevi sistemlerde:

    sudo apt-get install zenity

Proje klasörünü klonlayın veya indirin

git clone https://github.com/YasinEkici/zenity-envanter-yonetimi
cd envanter

Dosyaya çalıştırma izni verin

chmod +x main.sh

main.sh betiğini çalıştırın

    ./main.sh

    Not: Projeyi ilk kez çalıştırdığınızda, kullanici.csv, depo.csv, log.csv ve hareket.csv yoksa otomatik oluşturulur. Ayrıca varsayılan bir yönetici kullanıcı (admin / 12345) tanımlanır.

##Kullanım Adımları

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

##CSV Dosyaları

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

##Ekran Görüntüleri

    Giriş Ekranı
![Screenshot from 2025-01-05 20-40-47](https://github.com/user-attachments/assets/befa6f5f-c0e8-4510-be67-10e7215286b1)

    Ana Menü
![Screenshot from 2025-01-05 20-42-12](https://github.com/user-attachments/assets/f44d64ee-3711-40f5-9e55-678bfc57053f)

    Ürün Listeleme (Örnek tablo görünümü)
![Screenshot from 2025-01-05 20-42-57](https://github.com/user-attachments/assets/a98deaa4-bd58-4fa2-8707-2aab37e83ec6)

    Stok Hareketi
![Screenshot from 2025-01-05 20-43-36](https://github.com/user-attachments/assets/a21ce75f-fb3b-4df5-97f1-386702cc97b8)

    Rapor Alma
![Screenshot from 2025-01-05 20-44-07](https://github.com/user-attachments/assets/3587cb63-354a-4119-8bb0-ed092cee21b6)

    Kullanıcı Yönetimi
![Screenshot from 2025-01-05 20-44-36](https://github.com/user-attachments/assets/20ce2d87-d0e7-4400-b30b-0a1c5a81e99f)

    Hata Kayıtları Örneği
  ![Screenshot from 2025-01-05 20-45-19](https://github.com/user-attachments/assets/6a3cbd01-93a7-46ac-aa8e-6e6083704d58)
  

    

##Sık Karşılaşılan Sorunlar

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
