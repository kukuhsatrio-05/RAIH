# RAIH — RENCANA KERJA & TODO

> Status per 2 Nov 2026. Ditulis setelah audit kode (`flutter analyze` bersih, hanya 1 warning asset).
> Legenda prioritas: **P0** = blocker, **P1** = wajib sebelum demo/rilis, **P2** = peningkatan.

---

## Kondisi Saat Ini (Baseline)

**Sudah ada:**
- Struktur feature-based: `lib/features/<fitur>/{data,presentation}` + `lib/core`.
- Repositori Supabase untuk `profiles`, `events`, `madings`, `documents`, `materials`, `onboardings`.
- Auth: email/password + Google Sign-In, `authStateProvider`.
- UI: onboarding, auth, home, mading, bank materi, materi, upload, profile, navbar custom.
- Tema: `AppTheme` (M3), `AppColors`, `AppTextStyles`, Poppins.
- Aset: logo, ilustrasi, ikon; konfigurasi splash & launcher icon.

**Belum jalan / belum selesai:**
- Router **dinonaktifkan total** (`lib/app/config/router.dart` semuanya dikomentari).
- `main.dart` membuka `MadingDetailView(postId: 'lomba-1')` hardcoded → aplikasi tidak bisa dinavigasi.
- Belum ada test yang aktif (`test/widget_test.dart` dikomentari semua).
- Belum ada skema SQL / migration / RLS untuk Supabase.
- Banyak `catch (_) {}` dan `return []` yang menyembunyikan error.
- Banyak data dummy (`_dummyEvents`, `MockDocumentData`) sebagai fallback.

---

## FASE 0 — Blocker (kerjakan hari ini)

- [ ] **P0.1 Aktifkan kembali router**
  - File: `lib/app/config/router.dart` (uncomment seluruh isi).
  - Pastikan import yang dipakai masih valid: `OnboardingView`, `AuthOptionView`, `LoginView`, `RegisterView`, `HomeViews`, `MadingView`, `UploadView`, `MateriView`, `ProfileView`, `EventDetailView`, `BankMateriView`, `DocumentDetailView`, `MainLayout`.
  - Cek `initialLocation` (sekarang `/mading`) — sesuai keinginan produk atau ganti ke `/onboarding`.
  - Hapus/rapikan logika redirect yang masih "development only" (komentar "Selama development...").
  - **DoD:** `context.go('/home')`, `/mading`, `/bank-materi`, `/profile` bisa dibuka; bottom navbar menyorot menu aktif.

- [ ] **P0.2 Perbaiki entry point**
  - File: `lib/main.dart`.
  - Ganti `home: MadingDetailView(postId: 'lomba-1')` → `routerConfig: AppRouter.router`.
  - Alasan: `CustomBottomNavbar` memakai `GoRouterState.of(context)` sehingga **crash** bila dipakai tanpa `GoRouter`.
  - **DoD:** cold start masuk ke halaman awal yang benar, tanpa exception.

- [ ] **P0.3 Hilangkan warning asset**
  - `pubspec.yaml` mendaftarkan `.env` padahal file tidak ada → warning `asset_does_not_exist`.
  - Pilihan: buat `.env` (dan masukkan ke `.gitignore`) **atau** hapus baris `- .env` dari `assets`.
  - **DoD:** `flutter analyze` → `No issues found!`.

- [ ] **P0.4 Verifikasi bug bottom sheet filter Mading**
  - File: `lib/features/mading/presentation/mading_screen.dart` (`_showFilterBottomSheet`, sekitar baris 250–283).
  - `Expanded` dipakai di dalam `Column(mainAxisSize: MainAxisSize.min)` → berpotensi `RenderFlex ... unbounded height`.
  - Perbaiki dengan `SizedBox(height: ...)` + `ListView` (atau `ConstrainedBox`), lalu tes di device.
  - **DoD:** tombol filter membuka bottom sheet tanpa error layout.

---

## FASE 1 — Fondasi Arsitektur

- [ ] **P1.1 Standarkan penanganan error**
  - Hapus pola `catch (_) {}` dan `return []` di repository tanpa jejak:
    `auth_repository.dart`, `home_repository.dart`, `mading_repository.dart`, `bank_materi_repository.dart`, `materi_repository.dart`, `profile_repository.dart`, `onboarding_repository.dart`.
  - Gunakan `lib/core/errors/app_exception.dart` (sudah ada) sebagai tipe error tunggal.
  - Di presentation, pakai `AsyncValue`/`errorMessage` di state agar UI bisa menampilkan pesan + tombol "Coba lagi".
  - Mock fallback hanya aktif saat `kDebugMode` atau lewat flag eksplisit.

- [ ] **P1.2 Seragamkan naming state management**
  - Saat ini campur: `*ViewModel` (auth, home), `*Notifier` (upload, event), `*Controller` (nama file), provider bernama `*Provider`, `*ViewModelProvider`, `*ControllerProvider`.
  - Tetapkan satu konvensi (rekomendasi: `XController` + `xControllerProvider`), catat di `coder.md`, lalu rename bertahap.

- [ ] **P1.3 Pindahkan konfigurasi hardcoded ke env**
  - `auth_repository.dart`: `serverClientId` Google masih hardcoded.
  - Tambah ke `api.env` + `EnvConstants` (mis. `GOOGLE_SERVER_CLIENT_ID`).
  - Cek juga URL/ID lain yang masih literal.

- [ ] **P1.4 Konsistenkan navigasi**
  - `mading_screen.dart` masih `Navigator.push`; fitur lain pakai `context.go`/`context.push`.
  - Pilih GoRouter untuk semua navigasi layar; `Navigator.pop` hanya untuk dialog/bottom sheet.
  - Tambahkan route `mading/:id` agar deep link & back button benar.

- [ ] **P1.5 Bersihkan sisa kode template**
  - Hapus komentar `// TODO: Query Supabase table atau panggil Supabase Auth/Storage` yang hanya template (setelah pekerjaan nyata dilakukan).
  - Rapikan `lib/ui/widgets/navbar/navbar_views.dart` (masih komentar semua) — hapus bila tidak dipakai.
  - Hapus `_dummyEvents` di `home_controller.dart` setelah data Supabase stabil.

- [ ] **P1.6 Konstanta tabel**
  - `onboarding_repository.dart` masih memakai string literal `'onboardings'`.
  - Tambahkan `SupabaseTables.onboardings` dan pakai di semua tempat.

---

## FASE 2 — Backend & Data (Supabase)

- [ ] **P1.7 Skema database + migration**
  - Buat folder `supabase/migrations/` (atau `docs/sql/`) berisi DDL untuk:
    - `profiles` (id → auth.users, full_name, phone_number, faculty, avatar_url, is_profile_completed)
    - `events` (id, title, category, sub_category, organizer, location, deadline, start_date, image_url, description, benefit, team_size, registration_url, ...)
    - `madings` (id, title, organizer, location, category, sub_category, image_url, deadline, reward, start_date, description, team_size, ...)
    - `documents` (id, title, file_path, file_type, author_name, category, download_count, file_size_mb, ...)
    - `materials` (sesuaikan `materi_model.dart`)
    - `onboardings` (image_path, title, description, sort_order)
  - Samakan **nama kolom** dengan `fromMap()`/`toMap()` di model.

- [ ] **P1.8 RLS & policy**
  - Aktifkan RLS semua tabel.
  - `select` publik untuk konten (events, madings, documents, materials, onboardings).
  - `profiles`: user hanya bisa read/update barisnya sendiri.
  - Insert/update konten: hanya role tertentu (mis. `admin`) — dokumentasikan.

- [ ] **P1.9 Storage bucket**
  - Buat bucket `documents`, `avatars`, `images` (sudah ada di `SupabaseBuckets`).
  - Atur policy upload/read; batasi ukuran & mime type.

- [ ] **P1.10 Seed data**
  - Pindahkan data dari `_dummyEvents` dan `MockDocumentData` ke seed SQL agar dev & prod konsisten.
  - **DoD:** aplikasi menampilkan data Supabase nyata tanpa fallback.

- [ ] **P1.11 Manajemen secret**
  - `api.env` **sudah ter-commit** di git dan berisi `SUPABASE_KEY` (publishable key).
  - Publishable key relatif aman, tetapi tetap: ganti ke `--dart-define` / CI secret, tambahkan `api.env` ke `.gitignore`, dan buat `api.env.example`.
  - Jangan pernah commit `service_role` key.
  - Bila perlu, rotasi key lama di dashboard Supabase.

---

## FASE 3 — Fitur

### Auth
- [ ] **P1.12** Tampilkan error login/register ke UI (`submitLogin`/`submitRegister` saat ini menelan error).
- [ ] **P1.13** Navigasi setelah sukses (login → `/home`, register → onboarding/profile) dan setelah logout → `/auth-option`.
- [ ] **P1.14** Validasi form: format email, panjang password, konfirmasi password, nomor HP.
- [ ] **P1.15** Inisialisasi `GoogleSignIn.instance.initialize()` cukup sekali (saat startup), jangan tiap klik.
- [ ] **P1.16** Samakan makna `faculty` vs `selectedInstitution` (register mengirim institution ke kolom faculty).
- [ ] **P1.17** Guard route memakai `authStateProvider`, bukan `Supabase.instance` langsung, agar UI ikut reaktif.

### Onboarding
- [ ] **P1.18** Simpan status "sudah lihat onboarding" di `shared_preferences`; tampilkan sekali saja.
- [ ] **P1.19** Aktifkan tombol "Daftar"/"Masuk" yang masih dikomentari (`onboarding_screen.dart`).

### Home / Events
- [ ] **P1.20** Loading state, empty state, error state + pull-to-refresh.
- [ ] **P1.21** Filter & search saat ini hanya di memori klien; pindahkan ke query Supabase (`.ilike`, `.eq`) atau tambahkan paginasi.
- [ ] **P1.22** Detail event: ambil dari `getEventById` (saat ini hanya dummy), tangani 404.
- [ ] **P1.23** Format tanggal pakai `intl` (`DateFormat('dd MMM yyyy', 'id_ID')`) — inisialisasi locale di `main`.

### Mading
- [ ] **P1.24** Hapus `postId: 'lomba-1'` hardcoded; detail ambil via `getMadingDetail`.
- [ ] **P1.25** Sinkronkan `MadingModel` vs `MadingDetailModel` (dua model dengan field mirip) agar tidak dobel mapping.
- [ ] **P1.26** Ganti `Image.network` polos dengan cache (`cached_network_image`) + placeholder.

### Bank Materi
- [ ] **P1.27** `getDownloadUrl` mengembalikan public URL; untuk bucket privat pakai `createSignedUrl`.
- [ ] **P1.28** Increment `download_count` saat unduh; tampilkan progress/error.
- [ ] **P1.29** Search & filter kategori di level query.

### Upload
- [ ] **P1.30** Ketergantungan `dart:io File` mematahkan build web — pakai `image_picker`/`file_picker` + `XFile`/`Uint8List`.
- [ ] **P1.31** Validasi ukuran & tipe file sebelum upload; progress indicator.
- [ ] **P1.32** Pastikan path storage unik dan aman (`uploads/<timestamp>_<nama>`), sanitasi nama file.
- [ ] **P1.33** Reset state setelah sukses + navigasi/tombol "Upload lagi".

### Profile
- [ ] **P1.34** Edit profil (nama, HP, fakultas), upload avatar ke bucket `avatars`.
- [ ] **P1.35** Logout dengan konfirmasi dan bersihkan state.
- [ ] **P1.36** Tampilkan status loading/error saat simpan.

### Materi
- [ ] **P1.37** Cek `materi_screen` masih dummy atau sudah ambil dari repo; samakan pola dengan fitur lain.
- [ ] **P1.38** Empty state bila `materials` kosong.

---

## FASE 4 — Kualitas

- [ ] **P1.39 Test**
  - Hapus isi `test/widget_test.dart` yang dikomentari; buat test nyata.
  - Unit test: `fromMap`/`toMap` semua model, `copyWith` state, `filteredEvents`, validasi form.
  - Widget test: render halaman utama dengan provider di-override.
  - Target awal: 1 smoke test + 1 test per model.
- [ ] **P2.40** Tambah lint rule di `analysis_options.yaml` (mis. `prefer_single_quotes`, `avoid_print`, `require_trailing_commas`) → lalu `dart fix --apply`.
- [ ] **P2.41** Terapkan loading/empty/error state seragam di semua layar (buat widget `AppStateView`).
- [ ] **P2.42** Aksesibilitas: `Semantics` untuk ikon navbar, kontras warna, ukuran tap ≥ 48dp.
- [ ] **P2.43** Responsif: uji lebar 320–1024px; grid `crossAxisCount` adaptif.
- [ ] **P2.44** Performa: hindari rebuild besar (`ref.watch` selektif), `const` constructor, `ListView.builder`/sliver.
- [ ] **P2.45** Lokalisasi: kumpulkan string Indonesia ke satu file (mis. `lib/core/constants/strings_id.dart`) atau siapkan `intl`/ARB.

---

## FASE 5 — Rilis & Dokumentasi

- [ ] **P1.46** `README.md` masih template Flutter → tulis: deskripsi produk, cara setup (`flutter pub get`, isi `api.env`), cara run, cara build, struktur folder.
- [ ] **P1.47** Perbarui `coder.md` dengan konvensi final (naming provider, error handling, navigasi) setelah Fase 1 selesai.
- [ ] **P2.48** Versioning: `pubspec.yaml` (`1.0.0+1`) + `CHANGELOG.md`.
- [ ] **P2.49** Android release: keystore, `key.properties`, `signingConfig` (jangan commit keystore).
- [ ] **P2.50** iOS: bundle id, signing, `Info.plist` permission (kamera/foto untuk upload).
- [ ] **P2.51** Regenerasi splash & ikon bila aset berubah:
  `dart run flutter_native_splash:create` dan `dart run flutter_launcher_icons`.
- [ ] **P2.52** CI (GitHub Actions): `flutter analyze`, `flutter test`, build APK debug pada PR.
- [ ] **P2.53** `.gitignore` review: pastikan `api.env`, `.env`, `key.properties`, `*.jks` tidak ikut.

---

## Urutan Kerja yang Disarankan

**Sprint 1 — "Bisa dijalankan & dinavigasi" (1–2 hari)**
1. P0.1 → P0.2 → P0.3 → P0.4
2. P1.12–P1.15 (auth error + redirect)
3. P1.46 (README setup)

**Sprint 2 — "Data nyata" (3–5 hari)**
1. P1.7 → P1.8 → P1.9 → P1.10 (schema, RLS, storage, seed)
2. P1.1 (error handling) + P1.6
3. P1.20–P1.22 (home), P1.24–P1.25 (mading)

**Sprint 3 — "Fitur lengkap" (5–7 hari)**
1. Bank materi, upload, profile, materi
2. P1.39 test dasar
3. P1.47 update `coder.md`

**Sprint 4 — "Siap rilis"**
1. Fase 4 sisa + Fase 5
2. Uji di minimal 2 device fisik (Android + iOS)

---

## Definisi Selesai (Definition of Done) per Task

1. `flutter analyze` → `No issues found!`
2. `flutter test` → semua lulus
3. Tidak ada `catch (_) {}` baru tanpa alasan jelas
4. Tidak ada data dummy di jalur produksi
5. Diuji manual di Android (dan iOS bila tersedia)
6. Perubahan konvensi dicatat di `coder.md`

---

## Catatan Audit (temuan spesifik)

| Lokasi | Temuan |
|---|---|
| `lib/main.dart:27-29` | Router dikomentari, `home:` hardcoded ke `MadingDetailView(postId: 'lomba-1')` |
| `lib/app/config/router.dart` | Seluruh file dikomentari (133 baris) |
| `lib/ui/widgets/navbar/navbar_custom.dart:15` | `GoRouterState.of(context)` → crash tanpa `GoRouter` |
| `lib/features/mading/presentation/mading_screen.dart:263` | `Expanded` di dalam `Column(mainAxisSize.min)` |
| `lib/features/auth/data/auth_repository.dart:79` | Google `serverClientId` hardcoded |
| `lib/features/auth/presentation/auth_controller.dart:29,87` | Error login/register ditelan (`catch (_)`) |
| `lib/features/onboarding/data/onboarding_repository.dart:21` | String literal `'onboardings'`, bukan `SupabaseTables` |
| `pubspec.yaml:74` | Asset `.env` tidak ada (warning analyzer) |
| `test/widget_test.dart` | Seluruh test dikomentari |
| `api.env` | Ter-commit di git (publishable key) |
| `lib/features/upload/presentation/upload_controller.dart:1` | `dart:io` → tidak kompatibel web |

---

*Update dokumen ini setiap kali task selesai. Ceklis dengan `- [x]`.*
