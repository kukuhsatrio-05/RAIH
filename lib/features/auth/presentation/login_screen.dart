import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
import 'package:raih/features/auth/presentation/auth_controller.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  @override
  void initState() {
    super.initState();
    // Listen untuk error & success state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen(loginProvider, (prev, next) {
        // Show error SnackBar
        if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      next.errorMessage!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
            ),
          );
        }
        
        // Redirect ke home jika sukses (tidak loading, tidak ada error)
        if (!next.isLoading && next.errorMessage == null && 
            (prev?.isLoading ?? false)) {
          print('✅ Login Success - Redirect to /home');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login berhasil!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              context.go('/home');
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);
    final screenHeight = MediaQuery.of(context).size.height;

    // Tinggi keyboard dikurangi safe area bawah agar tidak dihitung dua kali
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final bottomSpace = math.max(0.0, keyboardInset - safeBottom);

    return Scaffold(
      backgroundColor: Colors.white,
      // Resize ditangani manual lewat AnimatedPadding di bawah
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          child: AnimatedPadding(
            // Ruang untuk keyboard berubah secara halus, bukan melompat
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.only(bottom: bottomSpace),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              // Keyboard tertutup saat form di-scroll ke bawah
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                // 1. Header Gradient + Ilustrasi Menggantung + Container Lengkung
                SizedBox(
                  height: screenHeight * 0.36,
                  child: Stack(
                    children: [
                      // Latar Belakang Gradient Biru (Bagian Atas)
                      Container(
                        height: screenHeight * 0.30,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.blueGradientStart,
                              AppColors.blueGradientEnd,
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Bulatan Dekorasi Kanan Atas
                            Positioned(
                              top: -40,
                              right: -40,
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.12),
                                ),
                              ),
                            ),
                            // Bulatan Dekorasi Kiri Bawah
                            Positioned(
                              bottom: -30,
                              left: -30,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.12),
                                ),
                              ),
                            ),
                            // Logo Raih
                            SafeArea(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/raih.svg',
                                    height: 28,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Card Putih dengan Lengkungan Atas
                      Positioned(
                        top: screenHeight * 0.26,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                          ),
                        ),
                      ),

                      // Gambar Ilustrasi Tengah (Menggantung di perbatasan)
                      Positioned(
                        top: screenHeight * 0.26 - 65,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/login_illustration.svg',
                            height: 130,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Area Form Login
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Selamat Datang!',
                        style: AppTextStyles.bold24.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tidak punya akun? ',
                            style: AppTextStyles.regular14.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.go('/register');
                            },
                            child: Text(
                              'Daftar',
                              style: AppTextStyles.semibold14.copyWith(
                                color: AppColors.blueGradientEnd,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Input Email
                      TextFormField(
                        onChanged: notifier.setEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        // Ruang ekstra agar field tidak mepet keyboard saat auto-scroll
                        scrollPadding: const EdgeInsets.only(bottom: 120),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: state.isEmailNotEmpty
                                ? AppColors.blueGradientEnd
                                : Colors.grey.shade500,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: state.isEmailNotEmpty
                                  ? AppColors.blueGradientEnd
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.blueGradientEnd,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Input Kata Sandi
                      TextFormField(
                        onChanged: notifier.setPassword,
                        obscureText: !state.isPasswordVisible,
                        textInputAction: TextInputAction.done,
                        scrollPadding: const EdgeInsets.only(bottom: 120),
                        decoration: InputDecoration(
                          labelText: 'Kata Sandi',
                          labelStyle: TextStyle(
                            color: state.isPasswordNotEmpty
                                ? AppColors.blueGradientEnd
                                : Colors.grey.shade500,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: notifier.togglePasswordVisibility,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: state.isPasswordNotEmpty
                                  ? AppColors.blueGradientEnd
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.blueGradientEnd,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      // Lupa Kata Sandi
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            // Navigasi ke Lupa Kata Sandi
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text(
                            'Lupa Kata Sandi?',
                            style: AppTextStyles.regular14.copyWith(
                              color: AppColors.blueGradientEnd,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tombol 'Masuk'
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.isFormValid
                                ? AppColors.blueGradientEnd
                                : const Color(0xFFC4C4C4),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          onPressed: state.isFormValid && !state.isLoading
                              ? notifier.submitLogin
                              : null,
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Tombol Masuk dengan Google
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          onPressed: () {
                            // Aksi Login Google
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Masuk dengan akun Google',
                                style: AppTextStyles.regular14.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              SvgPicture.asset(
                                'assets/icons/google.svg',
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
