import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/ui/features/onboarding/models/onboarding_model.dart';

/// State onboarding (immutable)
class OnboardingViewModel {
  final List<OnboardingItem> items;
  final int currentIndex;

  const OnboardingViewModel({required this.items, this.currentIndex = 0});

  bool get isLastPage => currentIndex == items.length - 1;

  OnboardingViewModel copyWith({int? currentIndex}) => OnboardingViewModel(
    items: items,
    currentIndex: currentIndex ?? this.currentIndex,
  );
}

/// Notifier yang mengelola state
class OnboardingNotifier extends Notifier<OnboardingViewModel> {
  @override
  OnboardingViewModel build() {
    return OnboardingViewModel(
      items: [
        OnboardingItem(
          imagePath: 'assets/icons/trophy.svg',
          title: 'Temukan Tim &\nMentor Terbaikmu',
          description:
              'Bangun kolaborasi yang tepat dengan tim dan mentor yang sesuai minat, skill, dan tujuanmu.',
        ),
        OnboardingItem(
          imagePath: 'assets/icons/rocket.svg',
          title: 'Match Sesuai Potensi Kamu',
          description:
              'Kami bantu kamu terhubung dengan orang yang tepat berdasarkan data dan preferensi yang kamu isi.',
        ),
        OnboardingItem(
          imagePath: 'assets/icons/start.svg',
          title: 'Mulai Perjalananmu\nSekarang',
          description:
              'Buat akunmu dan temukan peluang terbaik untuk berkembang bersama tim dan mentor pilihan.',
        ),
        OnboardingItem(
          imagePath: 'assets/icons/logo_raih_ori.svg',
          title: 'Tunggu apa lagi?',
          description:
              'Mulai Eksplorasimu sekarang dan rasakan pengalaman terbaik bersama Raih!',
        ),
      ],
    );
  }

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}

/// Provider yang dipakai di View
final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingViewModel>(
      OnboardingNotifier.new,
    );
