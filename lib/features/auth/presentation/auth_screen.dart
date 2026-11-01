import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_text_styles.dart';
import 'package:raih/core/widgets/header_gradient_universal1.dart';
import 'package:raih/core/widgets/universal_button.dart';

export 'login_screen.dart';
export 'register_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthOptionView();
  }
}

class AuthOptionView extends StatelessWidget {
  const AuthOptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Container Header Gradient (Reusable Widget)
            BrandGradientHeader(
              child: Container(
                width: 200, // opsional: ukuran kotak
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white, // background putih
                  borderRadius: BorderRadius.circular(45), // opsional: rounded
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                    30.0,
                  ), // beri jarak biar logo tidak mepet
                  child: Image.asset(
                    'assets/icons/logo_raih_original.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // 2. Layout Konten Utama
            Container(
              color: Colors.transparent,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 34),

                  // 3. Judul
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Tunggu apa lagi?',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bold24.copyWith(color: Colors.black),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 4. Subtitle / Deskripsi
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Mulai Eksplorasimu sekarang dan rasakan pengalaman terbaik besama Raih!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular14.copyWith(
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                  ),

                  // Jarak 110px dari subtitle ke tombol pertama
                  const SizedBox(height: 110),

                  // 5. Tombol Utama (Masuk - Gradient Blue)
                  UniversalButton(
                    width: 334,
                    height: 60,
                    variant: ButtonVariant.gradient,
                    onPressed: () => context.go('/login'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Masuk',
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

                  const SizedBox(height: 16),

                  // 6. Tombol Sekunder (Daftar Akun Baru - Outlined / Border Blue)
                  UniversalButton(
                    width: 334,
                    height: 60,
                    variant: ButtonVariant.outlined,
                    onPressed: () => context.go('/register'),
                    child: Text(
                      'Daftar Akun Baru',
                      style: AppTextStyles.bold16.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 7. Tombol Masuk dengan Google
                  SizedBox(
                    width: 334,
                    height: 60,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // TODO: Implementasi Google Sign-In
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Masuk dengan Google',
                            style: AppTextStyles.regular16.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Image.asset(
                            'assets/icons/google.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
