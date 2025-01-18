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
