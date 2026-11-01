import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/features/mading/data/mading_model.dart';
import 'package:raih/features/mading/data/mading_repository.dart';

class MadingState {
  final String selectedMainCategory; // 'Semua', 'Lomba', 'Beasiswa'
  final String? selectedSubCategory;
  final String searchQuery;
  final List<MadingModel> allItems;
  final List<String> mainCategories;
  final bool isLoading;

  const MadingState({
    this.selectedMainCategory = 'Semua',
    this.selectedSubCategory,
    this.searchQuery = '',
    this.allItems = const [],
    this.mainCategories = const ['Semua', 'Lomba', 'Beasiswa'],
    this.isLoading = false,
  });

  // Filter items berdasarkan pencarian, kategori utama, dan sub-kategori
  List<MadingModel> get filteredItems {
    return allItems.where((item) {
      final matchesMain =
          selectedMainCategory == 'Semua' ||
          item.category.toLowerCase() == selectedMainCategory.toLowerCase();

      final matchesSub =
          selectedSubCategory == null ||
          selectedSubCategory == 'Semua' ||
          item.subCategory.toLowerCase() == selectedSubCategory!.toLowerCase();

      final matchesSearch =
          searchQuery.isEmpty ||
          item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.organizer.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesMain && matchesSub && matchesSearch;
    }).toList();
  }

  MadingState copyWith({
    String? selectedMainCategory,
    String? selectedSubCategory,
    bool clearSubCategory = false,
    String? searchQuery,
    List<MadingModel>? allItems,
    List<String>? mainCategories,
    bool? isLoading,
  }) {
    return MadingState(
      selectedMainCategory: selectedMainCategory ?? this.selectedMainCategory,
      selectedSubCategory: clearSubCategory
          ? null
          : (selectedSubCategory ?? this.selectedSubCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      allItems: allItems ?? this.allItems,
      mainCategories: mainCategories ?? this.mainCategories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MadingViewModel extends Notifier<MadingState> {
  @override
  MadingState build() {
    // Inisialisasi awal mading
    Future.microtask(() => loadMadings());
    return const MadingState(allItems: _dummyData);
  }

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<void> loadMadings() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(madingRepositoryProvider);
    final items = await repo.getMadings();
    if (items.isNotEmpty) {
      state = state.copyWith(allItems: items, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  // Daftar Sub-Kategori Lomba
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
  static const List<MadingModel> _dummyData = [
    MadingModel(
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
    MadingModel(
      id: '2',
      title: 'Beasiswa Unggulan Kemendikbud',
      organizer: 'Kemendikbud RI',
      location: 'Seluruh Indonesia',
      category: 'Beasiswa',
      subCategory: 'Full Scholarship',
      imageUrl: 'assets/images/beasiswa_poster.png',
      deadline: '12 Oktober 2026',
    ),
    MadingModel(
      id: '3',
      title: 'Business Plan Competition FEB UI',
      organizer: 'Universitas Indonesia',
      location: 'Depok, Jawa Barat',
      category: 'Lomba',
      subCategory: 'Business Plan Competition',
      imageUrl: 'assets/images/bpc.png',
      deadline: '15 Juli 2026',
    ),
    MadingModel(
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

class MadingDetailViewModel extends ChangeNotifier {
  MadingDetailModel? _mading;
  bool _isLoading = true;

  MadingDetailModel? get mading => _mading;
  bool get isLoading => _isLoading;

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  void fetchMadingDetail(String id) {
    _isLoading = true;
    notifyListeners();

    _mading = MadingDetailModel(
      id: id,
      categoryTag: "Lomba",
      title: "Hackathon Nasional Inovasi Digital 2026",
      organizer: "Kemendikbud RI",
      location: "Jakarta, DKI Jakarta",
      benefit: "Rp. 50.000.000",
      openDate: "15 Januari 2026",
      endDate: "31 Juli 2026",
      description:
          "Kompetisi hackathon tingkat nasional yang terbuka untuk mahasiswa aktif S1/D4 seluruh Indonesia. Peserta ditantang untuk menciptakan inovasi digital bernilai tinggi.",
      teamSize: "3–5 Orang",
      imageUrl: 'assets/images/mading_details.png',
    );

    _isLoading = false;
    notifyListeners();
  }
}
