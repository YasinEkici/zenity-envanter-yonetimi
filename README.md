YouTube Videosu: https://www.youtube.com/watch?v=cLIV2NU-BiA
# 📦 **Zenity Kullanarak Envanter Yönetimi Projesi**

**Zenity ve Bash ile geliştirilmiş bir envanter yönetim sistemi.**  
Bu proje, kullanıcı dostu arayüzü ve güçlü özellikleriyle ürünlerinizi ve stoklarınızı kolayca yönetmenizi sağlar.

---

## 🔖 **İçindekiler**
1. [Proje Özeti](#proje-özeti)
2. [Özellikler](#özellikler)
3. [Kurulum](#kurulum)
4. [Kullanım](#kullanım)
5. [Dosya Yapısı](#dosya-yapısı)
6. [Ekran Görüntüleri](#ekran-görüntüleri)
7. [Geliştirici Bilgisi](#geliştirici-bilgisi)
8. [Lisans](#lisans)

---

## 📃 **Proje Özeti**
Zenity ile görsel bir arayüz kullanarak envanter işlemlerini kolaylaştıran bu proje, işletmeler için güçlü bir çözüm sunar. Ürünlerin eklenmesi, stok hareketlerinin kaydedilmesi ve rapor alınması gibi birçok işlem yapılabilir.

---

## ✨ **Özellikler**

### 🔑 **Giriş ve Kullanıcı Yönetimi**
- 🧑‍💻 **Kullanıcı Girişi:** Kullanıcı adı ve parola doğrulama.
- 🔐 **Güvenlik:** Hatalı parola denemelerinde hesap kilitleme.
- 🛠️ **Kullanıcı İşlemleri:**
  - Yeni kullanıcı ekleme.
  - Kullanıcı bilgilerini güncelleme.
  - Kullanıcı listeleme ve silme.

### 📦 **Ürün ve Stok Yönetimi**
- 🛒 **Ürün İşlemleri:**
  - Yeni ürün ekleme.
  - Ürün bilgilerini güncelleme.
  - Ürün listeleme ve silme.
- 📈 **Stok Hareketleri:**
  - Stok giriş ve çıkış işlemleri.
  - Stok hareket geçmişi görüntüleme.

### 📊 **Raporlama**
- Dinamik rapor türleri:
  - Azalan stok raporu.
  - Yüksek stok raporu.
  - Kategori bazlı rapor.
  - Fiyat aralığı raporu.

### 🛠️ **Program Yönetimi**
- 📂 **Disk Alanı Kullanımı:** Veri dosyalarının boyutlarını görüntüleme.
- 💾 **Yedekleme:** Veri dosyalarını güvenli bir şekilde yedekleme.
- 📋 **Hata Kayıtları:** Sistem hatalarını detaylı görüntüleme.

---

## ⚙️ **Kurulum**

### Gerekli Bileşenler
- **Linux Dağıtımı** (Ubuntu, Debian, vb.)
- **Zenity**  
  Yüklemek için:
  ```bash
  sudo apt-get install zenity


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

# Envanter Yönetim Sistemi

## 🚀 Adım Adım Kurulum

### Adım 1: Projeyi Klonlayın
```bash
# Projeyi klonlayın ve dizine girin
git clone https://github.com/kullaniciadi/envanter-yonetim.git
cd envanter-yonetim
```

### Adım 2: Çalıştırılabilirlik Verin
```bash
# main.sh dosyasına çalıştırma yetkisi verin
chmod +x main.sh
```

### Adım 3: Uygulamayı Başlatın
```bash
# Uygulamayı başlatmak için main.sh dosyasını çalıştırın
./main.sh
```

---

## 🛠️ Kullanım

### Uygulamanın Çalıştırılması
- **main.sh** dosyasını çalıştırarak uygulamayı başlatın.
- İlk kez çalıştırıldığında varsayılan yönetici hesabı otomatik olarak oluşturulur:
  - **Kullanıcı Adı:** `admin`
  - **Parola:** `12345`

### Önemli Notlar
- Tüm işlemler CSV dosyalarında tutulur.
- Kullanıcı yetkisine göre işlem kısıtlamaları bulunmaktadır.
- Kullanıcı adı veya parola üç kez yanlış girilirse hesap kilitlenir.

---

## 📂 Dosya Yapısı

### 📜 Ana Scriptler
- `main.sh`: Uygulamanın giriş noktası.
- `moduller/`:
  - `urun_yonetimi.sh`: Ürün işlemleri.
  - `hareket_yonetimi.sh`: Stok hareketleri.
  - `rapor_al.sh`: Raporlama modülü.
  - `kullanici_yonetimi.sh`: Kullanıcı işlemleri.
  - `program_yonetimi.sh`: Sistem yönetimi.

### 📁 Veri Dosyaları
| Dosya          | Açıklama                                      |
|-----------------|----------------------------------------------|
| `depo.csv`     | Ürün bilgileri ve stok miktarları.           |
| `kullanici.csv`| Kullanıcı bilgileri.                         |
| `hareket.csv`  | Stok hareket kayıtları.                      |
| `log.csv`      | Sistem hataları ve önemli olaylar.           |

---

## 🖼️ Ekran Görüntüleri

### Giriş Ekranı
![Giriş Ekranı](images/giris_ekrani.png)

### Ana Menü
![Ana Menü](images/ana_menu.png)

### Raporlama
![Raporlama](images/raporlama.png)

---

## 👨‍💻 Geliştirici Bilgisi

Bu proje, işletmelerin stoklarını daha verimli yönetmesine yardımcı olmak amacıyla geliştirilmiştir. 🛠️

- **İsim:** [Adınız]
- **GitHub:** [github.com/kullaniciadi](https://github.com/kullaniciadi)
- **E-posta:** email@domain.com

---

## 📜 Lisans

Bu proje **MIT Lisansı** ile lisanslanmıştır. İstediğiniz gibi kullanabilir, değiştirebilir ve dağıtabilirsiniz. 🌟

---

## 🚀 Hadi, başlayalım!

- Projeyi klonlayın, çalıştırın ve kolayca envanterinizi yönetin!
