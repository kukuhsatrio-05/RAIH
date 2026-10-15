import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
import 'package:raih/ui/features/mading/viewmodels/mading_vm.dart';
import 'package:raih/ui/features/mading/models/mading_models.dart';
import 'package:raih/ui/features/mading/views/mading_card.dart';

class MadingView extends ConsumerWidget {
  const MadingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(madingProvider);
    final notifier = ref.read(madingProvider.notifier);
    final filteredItems = state.filteredItems;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Header & Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Temukan peluangmu',
                      style: AppTextStyles.regular14.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.bold24.copyWith(
                          color: Colors.black,
                        ),
                        children: const [
                          TextSpan(text: 'Info Lomba & '),
                          TextSpan(
                            text: 'Beasiswa',
                            style: TextStyle(color: AppColors.blueGradientEnd),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input Search + Filter Icon Button
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: notifier.setSearchQuery,
                            decoration: InputDecoration(
                              hintText: 'Cari lomba & beasiswa',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey.shade400,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: const BorderSide(
                                  color: AppColors.blueGradientEnd,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Tombol Filter Pop-up / BottomSheet Sub-Kategori
                        InkWell(
                          onTap: () => _showFilterBottomSheet(context, ref),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: AppColors.blueGradientEnd,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 2. Kategori Utama (Badge Horizontal: Semua, Lomba, Beasiswa)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.mainCategories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = state.mainCategories[index];
                    final isSelected = state.selectedMainCategory == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => notifier.selectMainCategory(cat),
                      selectedColor: AppColors.blueGradientEnd,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.blueGradientEnd,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.blueGradientEnd
                              : Colors.grey.shade300,
                        ),
                      ),
                      showCheckmark: false,
                    );
                  },
                ),
              ),
            ),

            // Sub-Kategori aktif indicator (jika ada)
            if (state.selectedSubCategory != null &&
                state.selectedSubCategory != 'Semua')
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
                  child: Row(
                    children: [
                      Text(
                        'Filter: ',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      Chip(
                        label: Text(
                          state.selectedSubCategory!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: AppColors.blueGradientEnd,
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                        onDeleted: () => notifier.selectSubCategory(null),
                      ),
                    ],
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 3. Grid Items (Lazy Render via SliverGrid)
            filteredItems.isEmpty
                ? const SliverFillRemaining(
                    child: Center(child: Text('Tidak ada data ditemukan')),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = filteredItems[index];
                        return MadingCard(item: item);
                      }, childCount: filteredItems.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                0.58, // Mengatur rasio tinggi-lebar card
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 16,
                          ),
                    ),
                  ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  // BottomSheet untuk memilih Kategori / Sub-Kategori yang disesuaikan
  void _showFilterBottomSheet(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(madingProvider.notifier);
    final options = notifier.currentSubCategoryOptions;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Kategori Spesifik',
                style: AppTextStyles.semibold16.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      title: Text(option, style: AppTextStyles.regular14),
                      onTap: () {
                        notifier.selectSubCategory(option);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
