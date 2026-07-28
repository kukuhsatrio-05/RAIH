import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';

// --- IMPORT REUSABLE WIDGETS ---
import 'package:raih/core/widgets/header_gradient_universal1.dart';
import 'package:raih/core/widgets/universal_button.dart';

// Model data internal untuk halaman onboarding
class OnboardingData {
  final String title;
  final String description;
  final String iconPath; // simpan path gambar

  const OnboardingData({
    required this.title,
    required this.description,
    required this.iconPath,
  });
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Data 3 Halaman Onboarding beserta Icon-nya
  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Temukan Tim & Mentor Terbaikmu',
      description:
          'Bangun kolaborasi yang tepat dengan tim dan mentor yang sesuai minat, skill, dan tujuanmu.',
      iconPath: 'assets/icons/ob_1.png',
    ),
    OnboardingData(
      title: 'Kembangkan Skill Baru',
      description:
          'Akses berbagai materi eksklusif dan sesi mentoring langsung dari para profesional di bidangnya.',
      iconPath: 'assets/icons/ob_2.png',
    ),
    OnboardingData(
      title: 'Capai Karir Impianmu',
      description:
          'Tingkatkan portofolio dan buka peluang karir yang lebih luas bersama komunitas kami.',
      iconPath: 'assets/icons/ob_3.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      context.go('/auth-option');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final item = _pages[index];

          return SingleChildScrollView(
            child: Column(
              children: [
                // 1. Refactored Header Gradient
                BrandGradientHeader(
                  child: Image.asset(
                    item.iconPath,
                    width: 80,
                    height: 80,
                  ), // opsional: tint putih transparan
                ),
                // 2. Layout Konten Utama
                Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(height: 32),

                      // 3. Slider Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (indicatorIndex) => AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.fastOutSlowIn,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            height: 8.0,
                            width: _currentIndex == indicatorIndex ? 24.0 : 8.0,
                            decoration: BoxDecoration(
                              gradient: _currentIndex == indicatorIndex
                                  ? AppColors.blueGradient
                                  : const LinearGradient(
                                      colors: [
                                        Color(0xFFE0E0E0),
                                        Color(0xFFE0E0E0),
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 34),

                      // 4. Judul
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bold24.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // 5. Deskripsi
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.regular14.copyWith(
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 160),

                      // 6. Refactored Button Gradient
                      UniversalButton(
                        width: 334,
                        height: 60,
                        variant: ButtonVariant.gradient,
                        onPressed: _onNextPressed,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Selanjutnya',
                              style: AppTextStyles.bold16.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
