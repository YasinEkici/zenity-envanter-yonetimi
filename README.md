[Projei detaylarıyla ele alan YouTube Videosu](https://www.youtube.com/watch?v=cLIV2NU-BiA)
# 📦 **Zenity Kullanarak Envanter Yönetimi Projesi**

**Zenity ve Bash ile geliştirilmiş bir envanter yönetim sistemi.**  
Bu proje, kullanıcı dostu arayüzü ve güçlü özellikleriyle ürünlerinizi ve stoklarınızı kolayca yönetmenizi sağlar.

---

## 🔖 **İçindekiler**
1. [Proje Özeti](#-proje-özeti)
2. [Özellikler](#-özellikler)
3. [Kurulum](#-kurulum)
4. [Kullanım](#-kullanım)
5. [Dosya Yapısı](#-dosya-yapısı)
6. [Ekran Görüntüleri](#%EF&B8%8F-ekran-görüntüleri)
7. [Geliştirici Bilgisi](#-geliştirici-bilgisi)
8. [Lisans](#-lisans)

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

## 💻 Kurulum ve Çalıştırma

### 🛠️ **Gereksinimler**
- **Linux / Unix** tabanlı bir işletim sistemi.
- `bash` (Bash Script çalıştırabilmek için).
- `zenity` (GUI dialog pencereleri için).


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
- Kullanıcı Hesap Güvenliği: Sistemde kullanıcıların güvenliği ön planda tutulmuştur. Giriş sırasında hatalı parola üç kez girilirse hesap otomatik olarak kilitlenir. Bu özellik, sistemin güvenliğini artırarak yetkisiz erişimleri engeller. Kilidi yöentici açabilir, ayrıca yanlış girilme sayısı yönetici tarafından değiştirilebilir ve hesap kitlenebilir.
- Veri Tutarlılığı ve Güvenli İşlem: Tüm işlemler sırasında geçici dosyalar kullanılarak veri tutarlılığı sağlanır. Geçici dosyalar, işlemler tamamlandığında asıl dosyalarla değiştirilir ve bu yöntem veri kaybını önlemek için güvenli bir altyapı sunar.
- Zenity Kullanımı ile Kullanıcı Dostu Arayüz: Bash Script tabanlı bir uygulama olmasına rağmen, Zenity ile görsel bir arayüz sunularak kullanıcı deneyimi zenginleştirilmiştir. Zenity'nin ikonlar, formlar ve renkli mesajlar gibi özellikleri sayesinde kullanıcılar rahatlıkla işlem yapabilir.
- Kullanıcı Yetkilendirmesi: Sistemde iki farklı kullanıcı rolü bulunmaktadır: Yönetici ve Kullanıcı. Yönetici hesapları, daha geniş yetkilere sahip olup ürün ekleme, silme ve sistem yedekleme, hareket işlemlerini yönetme gibi işlemleri gerçekleştirebilir. Bu sayede rol bazlı bir erişim kontrolü sağlanmıştır.
- Hata Kayıtları ve İzlenebilirlik: Sistem, gerçekleşen tüm önemli olayları ve hataları log.csv dosyasına kaydederek izlenebilirlik sağlar. Bu özellik, kullanıcıların yaptıkları işlemleri detaylı bir şekilde takip edebilmesine olanak tanır.
- Raporlama modülü sayesinde kullanıcılar: Stok eşiğine göre ürünleri görüntüleyebilir, belirli bir kategoriye ait ürünleri listeleyebilir, fiyat aralığına göre ürün filtrelemesi yapabilir. Bu özellikler, işletmelerin stok durumunu daha iyi anlamasına ve verimli kararlar almasına yardımcı olur.
- Yedekleme ve Disk Alanı Kontrolü: Uygulama, veri dosyalarını kolayca yedekleme imkanı sunar. Ayrıca, depo.csv, kullanici.csv gibi dosyaların toplam disk alanı kullanımını görüntüleyerek sistemin performansını kontrol etmeye olanak tanır.
- Kolay Kurulum ve Kullanım: Proje, birkaç basit komutla çalıştırılabilir hale gelir ve her seviyeden kullanıcı için kolaylık sağlar. Kullanıcı dostu yapısı, projeyi herkesin rahatlıkla kullanabileceği bir çözüm haline getirir.


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

## Ekran Görüntüleri

### Giriş Ekranı
![image](https://github.com/user-attachments/assets/cb1b8274-6c1c-4100-97c0-3603f0e09881)


### Ana Menü
![image](https://github.com/user-attachments/assets/a04dff5f-a000-4791-b9ef-a5bfa7dec312)


### Ürün İşlemleri Menüsü
![image](https://github.com/user-attachments/assets/ab9ff059-ffa9-4cd2-beb2-5cd6bc84979f)


### Stok Hareketi Menüsü
![image](https://github.com/user-attachments/assets/0b35e36f-6546-4b38-a300-4e72b9cc1234)

### Rapor Al Menüsü
![image](https://github.com/user-attachments/assets/f8205dcf-0874-402d-b9db-416f88536bec)


### Kullanıcı Yönetimi Menüsü 
![image](https://github.com/user-attachments/assets/3ae95fc5-bc47-4e3c-9d60-137e608640e7)


### Program Yönetimi Menüsü
![image](https://github.com/user-attachments/assets/8b28d723-4b60-4abe-bf92-161a0cacca72)

---

## 👨‍💻 Geliştirici Bilgisi

Bu proje, işletmelerin stoklarını daha verimli yönetmesine yardımcı olmak amacıyla geliştirilmiştir. 🛠️

- **İsim:** Yasin Ekici
- **GitHub:** https://github.com/YasinEkici
- **LinkedIn** https://www.linkedin.com/in/yasin-ekici-807951255
- **E-posta:** yasinekici021@outlook.com

---

## 📜 Lisans

Bu proje **MIT Lisansı** ile lisanslanmıştır. İstediğiniz gibi kullanabilir, değiştirebilir ve dağıtabilirsiniz. 🌟

---

## 🚀 Hadi, başlayalım!

- Projeyi klonlayın, çalıştırın ve kolayca envanterinizi yönetin!
