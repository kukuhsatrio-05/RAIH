# [FEATURE] User Management and Authentication

## Description
Bagian ini menyajikan gambaran pengalaman pengguna. Selanjutnya, fitur login dan register berfungsi sebagai gerbang utama untuk verifikasi keamanan data, pengaturan hak akses, serta menjaga kontinuitas aktivitas pengguna secara terorganisir.

## Goal
Memastikan pengguna memiliki pemahaman awal tentang aplikasi dan memfasilitasi pembuatan akun dengan data yang relevan agar proses matchmaking tim dan mentor berjalan tepat sasaran dan terorganisir.

## Constraint

### Email Domain Restriction
Pendaftaran akun wajib menggunakan email institusi Universitas Brawijaya (contoh format domain: `@student.ub.ac.id` atau domain resmi UB lainnya). Sistem harus menolak domain email umum seperti:
- `@gmail.com`
- `@yahoo.com`
- `@outlook.com`

### Authentication Persistence
Jika pengguna sudah login sebelumnya dan tidak melakukan logout, sistem harus melewati (skip) halaman Splash, Onboarding, dan Login, lalu langsung mengarahkan pengguna ke halaman Home saat aplikasi dibuka kembali.

## Flow
Buka aplikasi → Informasi seputar tujuan aplikasi (Onboarding/Landing Page) → Halaman opsi Login/Register

## Data

### Login
- Email
- Password

### Register
- Nama Lengkap
- Email
- Fakultas
- No Aktif
- Password
- Confirm Password

## UI Flow

### Splash Screen (Loading Awal)

**Skenario:** Pengguna pertama kali membuka aplikasi.

#### Kriteria Penerimaan
- Sistem menampilkan logo dan nama aplikasi di posisi tengah (center alignment) dengan latar belakang warna utama (primary color).
- Sistem menampilkan indikator pemuatan (loading spinner) di bagian bawah.
- Durasi tampilan Splash Screen dibatasi maksimal 2–3 detik sebelum otomatis berpindah ke halaman Onboarding (atau ke Home jika session user masih aktif).

---

### Onboarding Page

**Skenario:** Pengguna baru membuka aplikasi untuk pertama kali.

#### Kriteria Penerimaan
- Menampilkan 3 slide horizontal yang dapat digeser (swipeable) secara halus oleh pengguna.
- Menampilkan tombol **"Skip"** di kanan atas halaman. Jika diklik, sistem langsung melompat ke halaman opsi Login/Register.
- Menampilkan indikator halaman (pagination dots) di bagian bawah untuk menunjukkan slide aktif.
- Menampilkan tombol utama (primary button) di bagian bawah teks deskripsi.

##### Slide 1 & 2
- Tombol bertuliskan **"Selanjutnya"**.
- Berfungsi untuk pindah ke slide berikutnya.

##### Slide 3
- Tombol bertuliskan **"Mulai Sekarang"**.
- Berfungsi untuk pindah ke halaman opsi Login/Register.

---

### Login Page

**Skenario:** Pengguna ingin masuk ke akun yang sudah terdaftar.

#### Kriteria Penerimaan
- Menampilkan input field untuk Email Kampus dan Password.
- Pada field Password, wajib ada ikon mata (Show/Hide Toggle) untuk menyembunyikan atau menampilkan karakter password.
- Menampilkan teks klik-aktif **"Lupa Password?"** di bawah field password sebelah kanan (memicu alur reset password via email).
- Menampilkan tombol utama **"Masuk"**.
- Tombol berstatus disabled (tidak bisa diklik) jika salah satu atau kedua field masih kosong.
- Menampilkan tombol alternatif **"Masuk dengan Google"** (menggunakan Google Sign-In SDK) untuk mempermudah otentikasi cepat selama email Google yang digunakan adalah email institusi UB.
- Menampilkan teks navigasi di bagian paling bawah:

  > Belum punya akun? Daftar

- Jika kata **"Daftar"** diklik, sistem pindah ke halaman Register.

---

### Register Page

**Skenario:** Pengguna baru ingin membuat akun.

#### Kriteria Penerimaan
- Menampilkan input field wajib:
  - Nama Lengkap
  - Email
  - Fakultas
  - Nomor Aktif (WhatsApp)
  - Password
  - Konfirmasi Password

- Field Fakultas & Jurusan harus bertipe Dropdown atau Searchable Picker untuk menghindari salah ketik oleh pengguna.
- Daftar pilihan fakultas harus disesuaikan dengan daftar resmi UB (FILKOM, FT, FEB, FH, dan lainnya).
- Tombol utama **"Daftar"** baru berstatus active jika semua kolom formulir telah diisi.

---

# [FEATURE] Matchmaking Board (Eksplorasi Peluang)

## Description
Fitur ini berfungsi sebagai "Mading Digital" interaktif. Alih-alih membuat dua sistem terpisah, fitur ini menggabungkan pencarian tim lomba dan pencarian/penawaran mentor beasiswa ke dalam satu Unified Feed (beranda utama).

## Goal
Memvalidasi kebutuhan mahasiswa untuk saling berkolaborasi lintas prodi/kampus dengan memfasilitasi pertemuan mereka secara cepat. Fitur ini dirancang untuk memberikan value tertinggi ("Menemukan Partner") dengan effort development sekecil mungkin.

## Constraint
- Setiap postingan harus memiliki opsi **"Tutup/Selesai"** agar feed tidak dipenuhi oleh informasi usang yang tim/kuota mentornya sudah penuh.
- Panjang teks deskripsi dibatasi (misal maksimal 300 karakter) agar UI feed tetap rapi dan scannable.

## Flow

### Flow Membaca/Mencari
Buka Aplikasi → Halaman Home → Gunakan Filter (Lomba/Beasiswa) → Temukan postingan yang relevan → Klik tombol Message/Chat pada kartu postingan → Otomatis masuk ke ruang obrolan (Chat Room) dengan pembuat postingan.

### Flow Membuat Postingan
Buka Aplikasi → Klik ikon "+" (Buat Postingan) → Pilih Kategori & Tipe → Isi form detail → Submit → Postingan tayang di Home.

## Data
- Kategori Utama (Enum: Lomba / Beasiswa)
- Tipe Aksi (Enum: Mencari Tim / Mencari Mentor / Menawarkan Mentoring)
- Judul Postingan (String, maks 50 karakter)
- Deskripsi Kebutuhan (Text, maks 300 karakter)
- Kriteria Fakultas / Jurusan Sasaran (Pilihan Dropdown atau Bebas)
- Deadline / Tenggat Waktu Postingan (Tanggal)
- Status Postingan (Boolean: Aktif / Ditutup)

## UI Flow

### Halaman Utama (Unified Feed)

#### Header
Filter Chips:
- Semua
- Lomba
- Beasiswa

#### Body
Daftar postingan berbentuk Card UI.

#### Desain Kartu
Menampilkan:
- Badge Kategori
- Judul
- Nama Pembuat
- Deskripsi
- Tombol aksi utama:
  - Chat
  - Ikon Message

#### FAB (Floating Action Button)
Tombol "+" melayang di pojok untuk membuat postingan baru.

---

### Halaman Buat Postingan Baru (Create Post)

#### Form
- Dropdown Kategori
- Dropdown Tipe
- Input Judul
- Input Deskripsi

#### Aksi
- Tombol Submit

---

# [FEATURE] Bank Materi (Resource Center)

## Description
Bagian ini menyajikan pusat pengetahuan tempat pengguna dapat mencari dan mengunduh referensi dokumen penting, seperti template proposal hingga esai beasiswa. Fitur edukatif ini berfungsi sebagai nilai tambah (added value) yang efektif untuk membuat pengguna rutin kembali membuka aplikasi.

## Goal
Menyediakan wadah repositori edukasi terpusat untuk membantu mahasiswa mempersiapkan lomba atau beasiswa, sekaligus meningkatkan Daily Active Users (DAU) aplikasi secara signifikan.

## Constraint
- File tidak diunggah langsung ke database aplikasi.
- Aplikasi hanya menyimpan tautan/link eksternal (misal Google Drive).
- Untuk versi awal, penambahan materi baru hanya bisa dilakukan oleh Admin melalui dashboard internal atau oleh Verified Mentor agar materi yang beredar terjamin kualitasnya dan tidak ada spam.

## Flow
Pengguna mencari referensi dokumen:

Buka aplikasi → Klik menu Bank Materi di Navbar → Pilih Filter Kategori → Memilih salah satu dokumen → Membaca deskripsi → Klik tombol Akses Dokumen → Diarahkan ke browser untuk melihat/mengunduh file via Google Drive.

## Data
- Judul Dokumen
- Nama Kontributor / Penulis Asli
- Deskripsi Dokumen
- URL Eksternal
- Tanggal Diunggah (Timestamp)

## UI Flow

### Menu Bottom Navigation Bar
Pilih ikon berbentuk Buku atau Folder bertuliskan **Materi**.

### Halaman Utama Bank Materi (Katalog)

#### Header
Search Bar berdasarkan judul.

#### Filter Menu
- Semua
- Proposal Lomba
- Esai Beasiswa
- Template CV

#### Body
Daftar materi dalam bentuk List atau Grid.

#### Desain Item Materi
- Ikon jenis file (PDF/Docs)
- Judul materi
- Nama Kontributor
- Kategori

---

### Halaman Detail Materi

Menampilkan:
- Judul Dokumen
- Nama Kontributor
- Deskripsi

Contoh:

> Proposal ini adalah contoh yang lolos pendanaan Dikti tahun lalu. Silakan jadikan referensi format.

#### Tombol CTA
- Akses Dokumen
- Unduh Referensi

#### Proses Eksekusi
Saat tombol ditekan, aplikasi menggunakan Web View atau membuka browser bawaan menuju link Google Drive yang sudah disematkan.

---

# [FEATURE] Info Lomba & Beasiswa (Mading Informasi)

## Description
Fitur "Mading Digital" berbasis poster ini menampilkan daftar lomba dan beasiswa yang sedang buka, sehingga pengguna dapat dengan mudah memantau timeline pendaftaran sebelum mencari rekan tim atau mentor.

## Goal
Memastikan user memiliki pemahaman awal tentang ketersediaan kompetisi dan beasiswa yang relevan dengan minat serta jenjang pendidikan mereka, sehingga mempermudah perencanaan partisipasi mereka jauh sebelum tenggat waktu (deadline) berakhir.

## Constraint
- Semua gambar poster yang diunggah harus memiliki rasio ukuran standar (misal 4:5 atau 1:1) agar poster tidak terpotong.
- Fitur bookmark hanya menyimpan data ke profil pengguna dan tidak mengubah status kuota lomba atau beasiswa.

## Flow
Buka aplikasi → Masuk ke menu Info Lomba → Melihat daftar poster berdasarkan bulan aktif → Menggunakan Search atau Filter → Menyimpan poster dengan Bookmark atau membuka detail untuk mencari tim/mentor.

## Data

### Informasi Poster/Peluang
- ID Info
- Tipe Kategori Utama (Lomba / Beasiswa)
- Gambar Poster (URL Image)
- Judul
- Penyelenggara & Tingkat
- Lokasi / Metode Pelaksanaan

### Atribut Filter
- Tags Jenjang Pendidikan (D3, D4, S1, S2, dll.)
- Tipe Pendanaan (Fully Funded, Partial Funded, Self Funded)

### Waktu Pelaksanaan
- Tanggal Mulai
- Tanggal Tenggat

### Aksi Pengguna
- Status Tersimpan / Bookmark (Boolean)

## UI Flow

### Header
#### Search Bar
"Ketik nama beasiswa/lomba yang ingin kamu cari"

#### Timeline Navigation
- Pilihan Tahun
- Chips Bulan (JAN, FEB, MAR, dst.)

### Filter
#### Jenjang
- S1
- D4
- D3
- dan lainnya

#### Tipe Pendanaan
- Fully Funded
- Partial Funded
- Self Funded

### Body

#### Grid Card Poster

##### Header Kartu
Tags jenjang:
- D3
- D4
- S1

##### Isi Kartu
- Gambar Poster
- Judul
- Subjudul Penyelenggara & Tingkat
- Ikon Lokasi + teks lokasi
- Tanggal Mulai
- Deadline
- Ikon Bookmark

---

# [FEATURE] User Profile and Portofolio

## Description
Profil pengguna berfungsi sebagai "Digital CV" yang dilengkapi indikator ketersediaan visual dan tag keahlian untuk memvalidasi kemampuan serta mempercepat pencarian rekan tim yang kredibel.

## Goal
Membangun kepercayaan (trust) antar pengguna dengan menampilkan rekam jejak prestasi, keahlian, dan testimoni, sehingga mempermudah proses evaluasi kualifikasi calon rekan tim atau mentor.

## Constraint

### Skill Tags
Maksimal 5 pilihan agar profil tetap fokus dan tidak terlihat asal.

### Connection System
Sistem Connection bersifat dua arah (harus saling accept/approve) seperti LinkedIn, bukan satu arah seperti Followers Instagram.

## Flow

### Melihat Profil & Koneksi
Pengguna mencari rekan → Membuka profil orang lain → Melihat jumlah koneksi, tags, dan frame foto → Klik Connect.

### Menambah Pengalaman
Pengguna membuka profil sendiri → Scroll ke seksi Pengalaman → Klik tombol "+" → Mengisi detail pengalaman → Simpan → Pengalaman muncul di profil.

### Update Status Ketersediaan
Pengguna membuka profil sendiri → Masuk mode Edit → Aktifkan toggle "Open to Join" → Sistem memasang frame khusus pada foto profil.

## Data

### Data Diri & Status
- Foto Profil Dasar
- Status Frame Foto (None / Open to Join)
- Jumlah Koneksi
- Nama Lengkap
- Asal Kampus / Jurusan

### Keahlian & Pengalaman
- Skill Tags (maksimal 5)
- List Detail Pengalaman
- List Team Recommendation

## UI Flow

### Menu Bottom Navigation Bar
Pilih ikon **Profil**.

### Halaman Utama Profil (View Mode - Profil Sendiri)
Menampilkan:
- Foto Profil
- Frame Open to Join (jika aktif)
- Jumlah Koneksi
- Expertise Tags
- Daftar Pengalaman
- Daftar Testimoni

---

### Halaman Edit Profil Dasar

#### Form
- Toggle Aktifkan Frame "Open to Join"
- Input Headline/Bio
- Pilihan maksimal 5 Expertise Tags

#### Aksi
- Save

---

### Halaman Tambah/Edit Pengalaman (Add Experience)

#### Form
- Judul Peran
- Penyelenggara / Organisasi
- Bulan & Tahun Mulai
- Bulan & Tahun Selesai
- Checkbox "Saya masih aktif di peran ini"
- Text Area Deskripsi
- Input Tautan/Media (Opsional)

#### Tombol
- Save

#### Hasil
Data langsung ter-update pada daftar pengalaman dan diurutkan dari yang terbaru.

---

### Halaman Profil Orang Lain (View Mode)

Tampilan visual sama dengan profil sendiri.

#### Aksi yang tersedia
- Connect
- Hubungi via WhatsApp
- Tulis Testimoni

#### Testimoni
Tombol "Tulis Testimoni" memunculkan pop-up input teks ulasan.