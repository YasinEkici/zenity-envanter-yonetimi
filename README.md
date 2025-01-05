Zenity ile Gelişmiş Envanter Yönetim Sistemi

Bu proje, Zenity kullanılarak oluşturulmuş kapsamlı bir envanter yönetim sistemi sunar. Kullanıcı dostu bir grafik arayüz ile ürünlerin, stok hareketlerinin ve kullanıcıların etkili bir şekilde yönetimini sağlar. Proje, Bash betikleri ile modüler şeklinde tasarlanmıştır ve çoklu dosya yapısıyla esnek bir kod tabanı sunar.

Genel Bakış

Anahtar Özellikler

Kapsamlı Ürün Yönetimi:

Yeni ürün ekleme, var olan ürünleri güncelleme ve silme.

Ürünlerin detaylı listelemesi.

Gelişmiş Kullanıcı Yönetimi:

Yeni kullanıcı ekleme, bilgilerini düzenleme ve silme.

Kullanıcı yetkilendirme (Yönetici ve Kullanıcı rolleri).

Detaylı Raporlama:

Stok durumu, fiyat aralığı ve stok hareketleriyle ilgili raporlar.

Stok Hareketleri Yönetimi:

Stok girişi, çıkışı ve hareket takibi.

Program Yönetimi:

Disk alanını kontrol etme, dosyaları yedekleme ve hata kayıtlarını inceleme.

Proje Detayları

Kullanılan Teknolojiler

Linux Shell: Bash betikleri ile sistem tasarımı.

Zenity: Grafiksel arayüz oluşturmak için GNOME tabanlı bir aracı.

CSV Dosyaları: Veri saklama ve çekme için düzenli tablo yapısı.

Komut Satırı Araçları: awk, grep, cut, sed gibi Linux komutları.

Veri Yapısı

depo.csv: Ürün bilgilerinin saklandığı dosya.

kullanici.csv: Kullanıcı verilerini tutan dosya.

log.csv: Sistem hatalarını kayıt altına alır.

hareket.csv: Stok hareket bilgilerini saklar.

Ana Betik Dosyaları

main.sh

Sistemin ana giriş ve menü yönetim dosyası.

urun_yonetimi.sh

Ürün ekleme, silme ve güncelleme işlemleri.

rapor_al.sh

Çeşitli raporlar oluşturma.

program_yonetimi.sh

Disk kullanımı, yedekleme ve hata kayıtları işlemleri.

kullanici_yonetimi.sh

Kullanıcı işlemleri.

hareket_yonetimi.sh

Stok hareketlerinin giriş ve çıkış yönetimi.

Fonksiyonların Detaylı Açıklaması

1. Ürün Yönetimi

1.1 Ürün Ekleme

Zenity Form: Kullanıcıdan ürün adı, stok ve fiyat bilgileri istenir.

CSV Yazımı: Girilen bilgiler depo.csv dosyasına eklenir.

1.2 Ürün Listeleme

Zenity Text-Info: Tüm ürün bilgileri gösterilir.

1.3 Ürün Güncelleme

ID Bazlı Arama: Güncellenecek ürün ID'siyle aranır.

Zenity Form: Yeni stok ve fiyat bilgileri alınır.

CSV Güncellemesi: Mevcut satır yeni bilgilerle değiştirilir.

1.4 Ürün Silme

Onay Mekanizması: Silme işlemi onaylanır.

CSV Filtreleme: Ürün ilgili dosyadan kaldırılır.

2. Kullanıcı Yönetimi

2.1 Kullanıcı Ekleme

Kullanıcı bilgileri alınır ve MD5 hash ile parola şifrelenir.

Yeni kullanıcı CSV'ye kaydedilir.

2.2 Kullanıcı Listeleme

Tüm kullanıcılar tablo formatında gösterilir.

2.3 Kullanıcı Güncelleme

Kullanıcı bilgileri ve yetkileri değiştirilebilir.

2.4 Kullanıcı Silme

Kullanıcı ID bazında silinir.

3. Stok Hareketleri

3.1 Stok Girişi ve Çıkışı

Hareket tipi, tarih ve kullanıcı bilgileri hareket.csv dosyasına eklenir.

Mevcut stok miktarı otomatik güncellenir.

3.2 Hareket Listeleme

Tüm hareketler tarih ve tip bazında detaylandırılır.

4. Program Yönetimi

4.1 Disk Alanı Gösterimi

Tüm veri dosyalarının toplam boyutu hesaplanır ve gösterilir.

4.2 Dosya Yedekleme

depo.csv, kullanici.csv ve hareket.csv dosyaları bir yedek klasörüne kopyalanır.

4.3 Hata Kayıtları

log.csv dosyasındaki hatalar detaylı olarak incelenebilir.

Kurulum

Gereksinimler

Linux ortamı

Zenity'nin kurulu olması

Bash desteği

Adımlar

Proje dosyalarını klonlayın:

git clone <repo-link>

Script dosyalarına çalıştırma izni verin:

chmod +x *.sh

Programı başlatın:

./main.sh
