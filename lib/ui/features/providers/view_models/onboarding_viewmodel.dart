import 'package:flutter/material.dart';
import 'package:raih/model/onboarding_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Buat class State untuk menampung data yang bisa berubah (indeks halaman)
class OnboardingState {
  final int currentPage;
  OnboardingState({required this.currentPage});
}

// 2. Ubah ViewModel menjadi extend Notifier
class OnboardingNotifier extends Notifier<OnboardingState> {
  final PageController pageController = PageController();

  final List<OnboardingModel> pages = [
    OnboardingModel(
      imagePath: 'assets/images/onboarding_slide1.webp',
      title: 'Temukan Tim & Mentor Terbaikmu',
      description:
          'Bangun kolaborasi yang tepat dengan tim dan mentor yang sesuai minat, skill, dan tujuanmu.',
    ),
    OnboardingModel(
      imagePath: 'assets/images/onboarding_slide2.webp',
      title: 'Kembangkan Skill Bersama',
      description:
          'Asah kemampuanmu lewat proyek nyata dan bimbingan intensif dari para ahli di bidangnya.',
    ),
    OnboardingModel(
      imagePath: 'assets/images/onboarding_slide3.webp',
      title: 'Gapai Karir Impian',
      description:
          'Buka peluang kerja lebih luas dengan portofolio kolaborasi yang solid dan terpercaya.',
    ),
  ];

  // Wajib mengembalikan nilai awal State di fungsi build
  @override
  OnboardingState build() {
    // Otomatis membersihkan controller saat tidak dipakai (mirip dispose)
    ref.onDispose(() => pageController.dispose());
    return OnboardingState(currentPage: 0);
  }

  void setCurrentPage(int index) {
    // Di Riverpod, cara mengubah data adalah dengan mengganti object statenya
    state = OnboardingState(currentPage: index);
  }

  void nextPage(BuildContext context) {
    if (state.currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pindah ke Halaman Utama/Login')),
      );
    }
  }
}

// 3. Deklarasi Providernya di ujung file ViewModel (biar rapi)
final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(() {
      return OnboardingNotifier();
    });
