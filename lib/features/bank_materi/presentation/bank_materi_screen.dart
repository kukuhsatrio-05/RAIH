import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/core/widgets/empty_state_view.dart';
import 'package:raih/features/bank_materi/presentation/bank_materi_controller.dart';
import 'package:raih/features/bank_materi/presentation/widgets/document_card_widget.dart';

export 'document_detail_screen.dart';

typedef BankMateriScreen = BankMateriView;

class BankMateriView extends ConsumerWidget {
  const BankMateriView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(materialViewModelPod);
    final viewModel = ref.read(materialViewModelPod.notifier);
    final filteredDocuments = viewModel.filteredDocuments;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      // Floating Action Button melayang
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF3B82F6), // Biru Primary
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(
            color: Colors.white,
            width: 4,
          ), // Efek outline putih
        ),
        child: const Icon(Icons.menu_book, color: Colors.white),
      ),
      // Posisi FAB di antara index ke-3 dan 4 (Custom location)
      floatingActionButtonLocation: CustomFabLocation(),

      // Bottom Nav Bar dengan cekungan (notch) yang sudah disesuaikan posisinya
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        // Tambahkan height dan padding agar konten tidak terlalu ke bawah
        height: 84,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Mading', false),
            _buildNavItem(Icons.info_outline, 'Mading', false),
            _buildNavItem(Icons.add_circle_outline, 'Unggah', false),
            const SizedBox(width: 48), // Ruang kosong untuk FAB
            _buildNavItem(Icons.person_outline, 'Profil', false),
          ],
        ),
      ),

      // Body Content (Tanpa SafeArea agar background putih header menembus ke atas)
      body: Column(
        children: [
          _buildHeader(
            context,
          ), // Kirim context untuk mendeteksi tinggi status bar
          _buildCategoryFilter(
            ref,
            state,
            viewModel,
          ), // Kirim ref/state ke helper method
          _buildDocumentList(
            filteredDocuments,
          ), // Kirim data list yang sudah difilter
        ],
      ),
    );
  }

  // --- KOMPONEN HEADER ---
  Widget _buildHeader(BuildContext context) {
    // Mengambil tinggi status bar perangkat agar teks tidak tertutup notch/jam
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      // Padding atas dikombinasikan dengan tinggi status bar
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: statusBarHeight + 16,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Belajar lebih cerdas',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 4),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: 'Bank ',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Materi',
                  style: TextStyle(color: Color(0xFF3B82F6)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Colors.grey.shade400),
                hintText: 'Cari materi, template atau modul..',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- KOMPONEN FILTER KATEGORI (Menggunakan Riverpod state) ---
  Widget _buildCategoryFilter(
    WidgetRef ref,
    BankMateriState state,
    MaterialViewModel viewModel,
  ) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 20, bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: viewModel.categories.length,
        itemBuilder: (context, index) {
          final category = viewModel.categories[index];
          final isSelected = state.selectedCategory == category;

          return GestureDetector(
            onTap: () => viewModel.selectCategory(category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : const Color(0xFF3B82F6),
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF3B82F6),
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- KOMPONEN LIST DOKUMEN ---
  Widget _buildDocumentList(List documents) {
    return Expanded(
      child: documents.isEmpty
          ? EmptyStateView(
              title: 'Tidak ada materi ditemukan',
              subtitle: 'Coba ubah filter atau cari dengan kata kunci lain',
              icon: Icons.library_books_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return DocumentCardWidget(document: documents[index]);
              },
            ),
    );
  }

  // Helper untuk Bottom Nav Item
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF3B82F6) : Colors.grey.shade400,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF3B82F6) : Colors.grey.shade400,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// Custom FAB Location class untuk menempatkan FAB agak ke kanan (sesuai desain UI)
class CustomFabLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Menghitung posisi X agar berada di sekitar 70% lebar layar
    final double fabX = scaffoldGeometry.scaffoldSize.width * 0.65;

    // Menghitung posisi Y agar tepat setengah badannya menjorok ke notch BottomAppBar
    final double contentHeight = scaffoldGeometry.contentBottom;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;

    // Posisi Y: Tinggi konten dikurangi setengah dari tinggi FAB agar pas di atas garis nav bar
    final double fabY = contentHeight - (fabHeight / 2.5);

    return Offset(fabX, fabY);
  }
}
