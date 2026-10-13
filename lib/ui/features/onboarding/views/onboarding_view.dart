import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
import 'package:raih/ui/features/onboarding/viewmodels/onboarding_vm.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final PageController _pageController = PageController();

  static const double _buttonHeight = 50;
  static const double _buttonGap = 12;
  static const Duration _anim = Duration(milliseconds: 450);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. Slide dengan efek fade
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: state.items.length,
              onPageChanged: notifier.setCurrentIndex,
              itemBuilder: (context, index) {
                final item = state.items[index];
                final isLastSlide = index == state.items.length - 1;

                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    // posisi halaman saat ini (bisa desimal saat digeser)
                    double page = state.currentIndex.toDouble();
                    if (_pageController.hasClients &&
                        _pageController.position.haveDimensions) {
                      page = _pageController.page ?? page;
                    }

                    final delta = index - page;
                    final opacity = (1 - delta.abs()).clamp(0.0, 1.0);
                    final width = MediaQuery.of(context).size.width;

                    // Transform.translate menahan slide tetap di tempat,
                    // sehingga yang terlihat hanya efek fade (bukan geser).
                    return Opacity(
                      opacity: opacity,
                      child: Transform.translate(
                        offset: Offset(-delta * width, 0),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      // Header gradient + gambar
                      Expanded(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.blueGradientStart,
                                AppColors.blueGradientEnd,
                              ],
                            ),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(36),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -60,
                                right: -60,
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.12),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -40,
                                left: -40,
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.12),
                                  ),
                                ),
                              ),

                              // Kotak glass (slide terakhir: putih solid)
                              SafeArea(
                                bottom: false,
                                child: Center(
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: isLastSlide
                                          ? Colors.white
                                          : Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(36),
                                      border: Border.all(
                                        color: isLastSlide
                                            ? Colors.white
                                            : Colors.white.withValues(
                                                alpha: 0.4,
                                              ),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.12,
                                          ),
                                          blurRadius: 24,
                                          offset: const Offset(0, 12),
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(
                                      item.imagePath,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Indicator dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          state.items.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: state.currentIndex == i ? 20 : 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: state.currentIndex == i
                                  ? AppColors.blueGradientEnd
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Judul & deskripsi
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            children: [
                              Text(
                                item.title,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bold20.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item.description,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.regular14.copyWith(
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 2. Tombol bawah dengan animasi "memisah"
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                // tinggi tetap agar layout di atas tidak bergeser
                height: _buttonHeight * 2 + _buttonGap,
                width: double.infinity,
                child: Stack(
                  children: [
                    // Tombol "Buat Akun": muncul (fade + turun) di slide terakhir
                    AnimatedPositioned(
                      duration: _anim,
                      curve: Curves.easeInOutCubic,
                      left: 0,
                      right: 0,
                      top: state.isLastPage
                          ? _buttonHeight + _buttonGap
                          : _buttonHeight - 10,
                      height: _buttonHeight,
                      child: AnimatedOpacity(
                        duration: _anim,
                        curve: Curves.easeInOut,
                        opacity: state.isLastPage ? 1 : 0,
                        child: IgnorePointer(
                          ignoring: !state.isLastPage,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.blueGradientEnd,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              // context.go('/register');
                            },
                            child: const Text(
                              'Buat Akun >',
                              style: TextStyle(
                                color: AppColors.blueGradientEnd,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Tombol utama: "Selanjutnya" -> naik & berubah jadi "Masuk"
                    AnimatedPositioned(
                      duration: _anim,
                      curve: Curves.easeInOutCubic,
                      left: 0,
                      right: 0,
                      top: state.isLastPage ? 0 : _buttonHeight + _buttonGap,
                      height: _buttonHeight,
                      child: TweenAnimationBuilder<Color?>(
                        duration: _anim,
                        tween: ColorTween(
                          end: state.isLastPage
                              ? AppColors.blueGradientStart
                              : AppColors.blueGradientStart,
                        ),
                        builder: (context, color, _) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              if (state.isLastPage) {
                                // context.go('/login');
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                state.isLastPage ? 'Masuk >' : 'Selanjutnya >',
                                key: ValueKey(state.isLastPage),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
