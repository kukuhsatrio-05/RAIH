import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/features/onboarding/data/onboarding_model.dart';
import 'package:raih/features/onboarding/data/onboarding_repository.dart';

class OnboardingViewModel {
  final List<OnboardingItem> items;
  final int currentIndex;

  const OnboardingViewModel({required this.items, this.currentIndex = 0});

  bool get isLastPage => currentIndex == items.length - 1;

  OnboardingViewModel copyWith({
    int? currentIndex,
    List<OnboardingItem>? items,
  }) => OnboardingViewModel(
    items: items ?? this.items,
    currentIndex: currentIndex ?? this.currentIndex,
  );
}

class OnboardingNotifier extends Notifier<OnboardingViewModel> {
  @override
  OnboardingViewModel build() {
    Future.microtask(() => loadItems());
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

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<void> loadItems() async {
    final repo = ref.read(onboardingRepositoryProvider);
    final items = await repo.getOnboardingItems();
    if (items.isNotEmpty) {
      state = state.copyWith(items: items);
    }
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
