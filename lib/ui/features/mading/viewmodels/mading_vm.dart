import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/ui/features/mading/viewmodels/mading_state.dart';
import 'package:raih/ui/features/mading/models/mading_models.dart';

class MadingViewModel extends Notifier<MadingState> {
  @override
  MadingState build() {
    return MadingState(allItems: _dummyData);
  }

  // Daftar Sub-Kategori Lomba (Sesuai gambar referensi)
  final List<String> lombaSubCategories = [
    'Semua',
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

  // Daftar Sub-Kategori Beasiswa
  final List<String> beasiswaSubCategories = [
    'Semua',
    'Full Scholarship',
    'Partial Scholarship',
    'Beasiswa Pemerintah',
    'Beasiswa Swasta',
    'Beasiswa Riset',
    'Lainnya',
  ];

  // Mengambil opsi sub-kategori aktif berdasarkan kategori utama yang dipilih
  List<String> get currentSubCategoryOptions {
    if (state.selectedMainCategory == 'Lomba') {
      return lombaSubCategories;
    } else if (state.selectedMainCategory == 'Beasiswa') {
      return beasiswaSubCategories;
    }
    // Jika 'Semua', gabungkan kedua kategori
    return [
      'Semua',
      ...lombaSubCategories.where((e) => e != 'Semua'),
      ...beasiswaSubCategories.where((e) => e != 'Semua'),
    ];
  }

  void selectMainCategory(String category) {
    state = state.copyWith(
      selectedMainCategory: category,
      clearSubCategory: true,
    );
  }

  void selectSubCategory(String? subCategory) {
    state = state.copyWith(selectedSubCategory: subCategory);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  // Data Dummy Awal
  static final List<MadingModel> _dummyData = [
    const MadingModel(
      id: '1',
      title: 'Hackathon Nasional Inovasi Digital 2026',
      organizer: 'Kemendikbud RI',
      location: 'DKI Jakarta',
      category: 'Lomba',
      subCategory: 'Hackathon',
      imageUrl: 'assets/images/hackathon.png',
      deadline: '31 Juli 2026',
      reward: 'Rp. 50.000.000',
      startDate: '15 Januari 2026',
      description:
          'Kompetisi hackathon tingkat nasional yang terbuka untuk mahasiswa aktif S1/D4 seluruh Indonesia. Peserta ditantang untuk menciptakan solusi digital inovatif.',
      teamSize: '3-5 Orang',
    ),
    const MadingModel(
      id: '2',
      title: 'Beasiswa Unggulan Kemendikbud',
      organizer: 'Kemendikbud RI',
      location: 'Seluruh Indonesia',
      category: 'Beasiswa',
      subCategory: 'Full Scholarship',
      imageUrl: 'assets/images/beasiswa_poster.png',
      deadline: '12 Oktober 2026',
    ),
    const MadingModel(
      id: '3',
      title: 'Business Plan Competition FEB UI',
      organizer: 'Universitas Indonesia',
      location: 'Depok, Jawa Barat',
      category: 'Lomba',
      subCategory: 'Business Plan Competition',
      imageUrl: 'assets/images/bpc.png',
      deadline: '15 Juli 2026',
    ),
    const MadingModel(
      id: '4',
      title: 'Gemastik XVII - Kategori UX Design',
      organizer: 'Pusat Prestasi Nasional',
      location: 'Surabaya, Jawa Timur',
      category: 'Lomba',
      subCategory: 'UI/UX Design',
      imageUrl: 'assets/images/ui_ux.png',
      deadline: '5 Agustus 2026',
    ),
  ];
}

final madingProvider = NotifierProvider<MadingViewModel, MadingState>(
  MadingViewModel.new,
);
