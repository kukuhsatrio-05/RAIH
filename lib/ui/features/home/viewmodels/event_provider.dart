import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/model/event_model.dart';

// ---------------------------------------------------------------------------
// Sub-categories list (used for dropdown menu)
// ---------------------------------------------------------------------------
const List<String> eventSubCategories = [
  'Semua Kategori',
  'Karya Tulis Ilmiah',
  'Essai',
  'Business Plan Competition',
  'Business Case Competition',
  'Business Model Canvas',
  'Poster Digital',
  'Video Kreatif',
  'UI/UX Design',
  'Debat',
  'Hackathon',
  'Lainnya',
];

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------
class EventState {
  final List<EventModel> allEvents;
  final String filterType;        // 'Semua', 'Lomba', 'Beasiswa'
  final String filterSubCategory; // from eventSubCategories
  final String searchQuery;

  const EventState({
    required this.allEvents,
    this.filterType = 'Semua',
    this.filterSubCategory = 'Semua Kategori',
    this.searchQuery = '',
  });

  List<EventModel> get filteredEvents {
    return allEvents.where((e) {
      final matchType = filterType == 'Semua' ||
          (filterType == 'Lomba' && e.category == EventCategory.lomba) ||
          (filterType == 'Beasiswa' && e.category == EventCategory.beasiswa);

      final matchSub = filterSubCategory == 'Semua Kategori' ||
          e.subCategory == filterSubCategory;

      final q = searchQuery.toLowerCase();
      final matchSearch = q.isEmpty ||
          e.title.toLowerCase().contains(q) ||
          e.organizer.toLowerCase().contains(q) ||
          e.subCategory.toLowerCase().contains(q);

      return matchType && matchSub && matchSearch;
    }).toList();
  }

  EventState copyWith({
    List<EventModel>? allEvents,
    String? filterType,
    String? filterSubCategory,
    String? searchQuery,
  }) =>
      EventState(
        allEvents: allEvents ?? this.allEvents,
        filterType: filterType ?? this.filterType,
        filterSubCategory: filterSubCategory ?? this.filterSubCategory,
        searchQuery: searchQuery ?? this.searchQuery,
      );
}

// ---------------------------------------------------------------------------
// ViewModel / Notifier
// ---------------------------------------------------------------------------
class EventNotifier extends Notifier<EventState> {
  @override
  EventState build() => EventState(allEvents: _dummyEvents);

  void setFilterType(String type) =>
      state = state.copyWith(filterType: type);

  void setSubCategory(String sub) =>
      state = state.copyWith(filterSubCategory: sub);

  void setSearch(String query) =>
      state = state.copyWith(searchQuery: query);

  void addEvent(EventModel event) =>
      state = state.copyWith(allEvents: [...state.allEvents, event]);
}

final eventProvider = NotifierProvider<EventNotifier, EventState>(EventNotifier.new);

// ---------------------------------------------------------------------------
// Dummy data (replace imageUrl with real assets later)
// ---------------------------------------------------------------------------
final List<EventModel> _dummyEvents = [
  EventModel(
    id: '1',
    title: 'Hackathon Nasional Inovasi Digital 2026',
    category: EventCategory.lomba,
    subCategory: 'Hackathon',
    organizer: 'Kemendikbud RI',
    location: 'Jakarta, DKI Jakarta',
    deadline: DateTime(2026, 7, 31),
    emoji: '💡',
    baseColor: const Color(0xFF6C72FF),
    description: 'Kompetisi hackathon tingkat nasional yang terbuka untuk mahasiswa aktif S1/D4 seluruh Indonesia. Peserta ditantang untuk menciptakan solusi teknologi inovatif guna memecahkan permasalahan nyata di masyarakat. Daftarkan tim Anda segera dan menangkan total hadiah senilai puluhan juta rupiah!',
    registrationUrl: 'https://example.com',
    registrationOpen: DateTime(2026, 1, 15),
    benefit: 'Rp. 50.000.000',
    teamSize: '3-5 Orang',
  ),
  EventModel(
    id: '2',
    title: 'Beasiswa Unggulan 2026',
    category: EventCategory.beasiswa,
    subCategory: 'Lainnya',
    organizer: 'Kemendikbud RI',
    location: 'Jakarta, DKI Jakarta',
    deadline: DateTime(2026, 8, 31),
    emoji: '🎓',
    baseColor: const Color(0xFF2ECC71),
    description: 'Beasiswa Unggulan adalah program beasiswa pemerintah yang diberikan kepada putra-putri terbaik bangsa yang berprestasi untuk menempuh pendidikan pada jenjang S1, S2, dan S3. Program ini mencakup biaya kuliah penuh, biaya hidup, serta biaya buku dan penelitian.',
    registrationUrl: 'https://example.com',
    registrationOpen: DateTime(2026, 2, 15),
    benefit: 'FULL tuition + Living allowance',
    requirements: [
      'Mahasiswa aktif S1/D4 min. semester 2',
      'IPK minimal 3.00 (skala 4.00)',
      'Tidak sedang menerima beasiswa lain',
      'Aktif berorganisasi / berkegiatan sosial',
      'Melampirkan surat rekomendasi dosen',
    ],
    benefitDetails: [
      {'label': 'Dana Hidup', 'value': 'Rp 1,4 Jt/bln'},
      {'label': 'Kuota', 'value': '200 Penerima'},
      {'label': 'Durasi', 'value': '1-2 Tahun'},
    ],
    selectionStages: [
      {'stage': 'Pendaftaran Online', 'date': '1 Feb 2026 - 15 Feb 2026'},
      {'stage': 'Seleksi Administrasi', 'date': '1-2 minggu setelah batas akhir'},
      {'stage': 'Tes & Wawancara', 'date': 'Diumumkan via email'},
      {'stage': 'Pengumuman Penerima', 'date': '2-4 minggu setelah tes'},
      {'stage': 'Pencairan Dana', 'date': 'Awal semester berikutnya'},
    ],
  ),
  EventModel(
    id: '3',
    title: 'Business Plan Competition FEB UI',
    category: EventCategory.lomba,
    subCategory: 'Business Plan Competition',
    organizer: 'Universitas Indonesia',
    location: 'Depok, Jawa Barat',
    deadline: DateTime(2026, 7, 15),
    emoji: '📊',
    baseColor: const Color(0xFFF39C12),
    description: 'Kompetisi rancangan bisnis tingkat mahasiswa nasional yang diselenggarakan oleh Fakultas Ekonomi dan Bisnis Universitas Indonesia.',
    registrationUrl: 'https://example.com',
    registrationOpen: DateTime(2026, 3, 1),
    benefit: 'Rp. 25.000.000',
    teamSize: '2-3 Orang',
  ),
  EventModel(
    id: '4',
    title: 'Gemastik XVII – Kategori UX Design',
    category: EventCategory.lomba,
    subCategory: 'UI/UX Design',
    organizer: 'Pusat Prestasi Nasional',
    location: 'Surabaya, Jawa Timur',
    deadline: DateTime(2026, 8, 5),
    emoji: '🎨',
    baseColor: const Color(0xFF1ABC9C),
    description: 'Pagelaran Mahasiswa Nasional Bidang Teknologi Informasi dan Komunikasi (GEMASTIK) ke-XVII untuk kategori Desain Pengalaman Pengguna (UX Design).',
    registrationUrl: 'https://example.com',
    registrationOpen: DateTime(2026, 4, 1),
    benefit: 'Medali & Sertifikat',
    teamSize: '3 Orang',
  ),
  EventModel(
    id: '5',
    title: 'LKTI Nasional Mahasiswa 2026',
    category: EventCategory.lomba,
    subCategory: 'Karya Tulis Ilmiah',
    organizer: 'DIKTI',
    location: 'Bandung, Jawa Barat',
    deadline: DateTime(2026, 9, 1),
    emoji: '📝',
    baseColor: const Color(0xFF9B59B6),
    description: 'Lomba Karya Tulis Ilmiah tingkat nasional untuk melatih daya kritis dan kepenulisan mahasiswa Indonesia.',
    registrationUrl: 'https://example.com',
    registrationOpen: DateTime(2026, 5, 10),
    benefit: 'Rp. 15.000.000',
    teamSize: '1-3 Orang',
  ),
  EventModel(
    id: '6',
    title: 'Debat Ekonomi Nasional 2026',
    category: EventCategory.lomba,
    subCategory: 'Debat',
    organizer: 'Universitas UGM',
    location: 'Yogyakarta',
    deadline: DateTime(2026, 8, 20),
    emoji: '🗣️',
    baseColor: const Color(0xFFE74C3C),
    description: 'Kompetisi debat ilmiah seputar isu ekonomi nasional dan global tingkat mahasiswa nasional.',
    registrationUrl: 'https://example.com',
    registrationOpen: DateTime(2026, 4, 15),
    benefit: 'Rp. 10.000.000',
    teamSize: '3 Orang',
  ),
];
