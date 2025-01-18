YouTube Videosu: https://www.youtube.com/watch?v=cLIV2NU-BiA

# 📦 Envanter Yönetim Sistemi 🚀
Zenity tabanlı, **Bash Script** kullanılarak geliştirilmiş, kullanıcı dostu bir **Envanter Yönetim Sistemi** ile tanışın! Bu sistem, küçük veya orta ölçekli işletmelerin ürün, kullanıcı, stok hareketleri ve raporlarını kolayca yönetmesini sağlamak için tasarlanmıştır.

---

## 🚀 Özellikler

### ✅ **Kapsamlı Kullanıcı Yönetimi**
- Yeni kullanıcı ekleyin, mevcut kullanıcıları listeleyin, güncelleyin veya silin.
- Kullanıcı rolleri: **Yönetici** ve **Kullanıcı**.
- Hatalı parola girişlerinde **hesap kilitleme** mekanizması (3 deneme hakkı).

### 🛒 **Ürün Yönetimi**
- Ürün ekleme, listeleme, güncelleme ve silme işlemleri.
- Kategori bazlı ürün yönetimi.
- **Gerçek zamanlı stok bilgisi güncelleme**.

### 📊 **Raporlama ve Analiz**
- Stok miktarına göre **azalan ürün raporu**.
- **Kategori bazlı rapor** ve **fiyat aralığı raporları**.
- Stok hareketlerini ve detaylı log kayıtlarını görüntüleme.

### 🔄 **Stok Hareketi Yönetimi**
- **Stok giriş-çıkış** işlemleri.
- Detaylı hareket geçmişi: Tarih, işlem tipi, kullanıcı ve miktar bilgileri.

### 🧰 **Program Yönetimi**
- Toplam veri boyutunu öğrenin.
- Veritabanı dosyalarını yedekleyin.
- Hata loglarını inceleyin.

---

## 📂 Kullanılan Dosyalar ve Amaçları
Proje, 4 temel veri dosyası kullanır:

| **Dosya Adı**    | **Açıklama**                                                                 |
|-------------------|------------------------------------------------------------------------------|
| `depo.csv`       | Ürün bilgilerini ve stok miktarlarını tutar.                                 |
| `kullanici.csv`  | Kullanıcı bilgilerini ve rollerini içerir.                                   |
| `hareket.csv`    | Stok giriş-çıkış hareketlerini kaydeder.                                     |
| `log.csv`        | Hatalar, uyarılar ve kullanıcı hareketlerini kayıt altına alır (log dosyası).|

---

## 💻 Kurulum ve Çalıştırma

### 🛠️ **Gereksinimler**
- **Linux / Unix** tabanlı bir işletim sistemi.
- `bash` (Bash Script çalıştırabilmek için).
- `zenity` (GUI dialog pencereleri için).

#### Zenity Kurulumu
Eğer sisteminizde `zenity` yüklü değilse, aşağıdaki komutlarla yükleyebilirsiniz:
```bash
# Debian/Ubuntu
sudo apt install zenity

# RedHat/CentOS
sudo yum install zenity

🚀 Kurulum Adımları
Projeyi klonlayın:

bash
Kopyala
git clone https://github.com/kullanici_adi/envanter-yonetim-sistemi.git
cd envanter-yonetim-sistemi
Script dosyalarına çalıştırılabilir izinler verin:

bash
Kopyala
chmod +x main.sh moduller/*.sh
Gerekli dosyaların oluşturulduğundan emin olun:

İlk çalıştırmada main.sh, gerekli olan depo.csv, kullanici.csv, hareket.csv ve log.csv dosyalarını otomatik olarak oluşturur.
Ana script'i başlatın:

bash
Kopyala
./main.sh
📋 Kullanım Rehberi
🔐 Giriş Yapma
İlk başta sistemde yalnızca admin kullanıcısı bulunur.
Kullanıcı Adı: admin
Parola: 12345
Yönetici, yeni kullanıcılar ekleyerek sistemi özelleştirebilir.
🏗️ Ana Menü
Sistemde oturum açtıktan sonra karşınıza aşağıdaki menü gelecektir:

Yönetici Menüsü
Ürün İşlemleri
Ürün ekleme, listeleme, güncelleme ve silme işlemleri.
Stok Hareketi
Stok giriş-çıkış işlemleri ve hareketleri görüntüleme.
Rapor Al
Azalan ürün, kategori bazlı veya fiyat aralığı raporları.
Kullanıcı Yönetimi
Kullanıcı ekleme, düzenleme veya silme işlemleri.
Program Yönetimi
Veri boyutu kontrolü, yedekleme ve log görüntüleme.
Çıkış
Oturumu sonlandırın.
Kullanıcı Menüsü
Kullanıcı yetkisine sahip kullanıcılar yalnızca ürün listeleme ve raporlama işlemlerine erişebilir.
📌 Önemli Notlar
CSV Formatı: Sistem tüm verileri CSV formatında saklar. Bu, verilerin Excel veya diğer programlarla kolayca düzenlenmesini sağlar.
Güvenlik: Parolalar MD5 hash ile saklanır. (Not: MD5 günümüzde güçlü bir hashleme yöntemi olarak kabul edilmemektedir, ancak bu bir örnek projedir.)
Hata Yönetimi: Her işlem sırasında oluşabilecek hatalar, log.csv dosyasına detaylı şekilde kaydedilir.
🤝 Katkıda Bulunma
Projeye katkıda bulunmak için aşağıdaki adımları takip edebilirsiniz:

Bu projeyi fork edin.
Yeni bir dal (branch) oluşturun:
bash
Kopyala
git checkout -b ozellik/yenilik
Değişikliklerinizi yapıp commit edin:
bash
Kopyala
git commit -m "Yeni özellik eklendi: X"
Dalınızı bu repoya push edin:
bash
Kopyala
git push origin ozellik/yenilik
Bir Pull Request (PR) açın ve katkıda bulunun!
📷 Ekran Görüntüleri
Giriş Ekranı	Ana Menü (Yönetici)	Ürün İşlemleri
📜 Lisans
Bu proje, MIT Lisansı ile lisanslanmıştır. Daha fazla bilgi için LICENSE dosyasını inceleyebilirsiniz.

👨‍💻 Geliştirici
Adınız veya Kullanıcı Adınız
GitHub: GitHub Profiliniz
LinkedIn: LinkedIn Profiliniz

🎉 Teşekkürler
Bu projeyi incelediğiniz için teşekkür ederim! Her türlü öneri ve geri bildirime açığım. 🙌
