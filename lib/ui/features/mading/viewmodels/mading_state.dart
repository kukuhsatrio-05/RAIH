import 'package:raih/ui/features/mading/models/mading_models.dart';

class MadingState {
  final String selectedMainCategory; // 'Semua', 'Lomba', 'Beasiswa'
  final String? selectedSubCategory;
  final String searchQuery;
  final List<MadingModel> allItems;
  final List<String> mainCategories;

  const MadingState({
    this.selectedMainCategory = 'Semua',
    this.selectedSubCategory,
    this.searchQuery = '',
    this.allItems = const [],
    this.mainCategories = const ['Semua', 'Lomba', 'Beasiswa'],
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
  }) {
    return MadingState(
      selectedMainCategory: selectedMainCategory ?? this.selectedMainCategory,
      selectedSubCategory: clearSubCategory
          ? null
          : (selectedSubCategory ?? this.selectedSubCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      allItems: allItems ?? this.allItems,
      mainCategories: mainCategories ?? this.mainCategories,
    );
  }
}
