import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';

// --- IMPORT REUSABLE WIDGETS ---
import 'package:raih/core/widgets/universal_button.dart';
import 'package:raih/core/widgets/universal_google_button.dart';
import 'package:raih/core/widgets/universal_text_input.dart';
import 'package:raih/ui/features/auth/viewmodels/login_viewmodel.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    emailController.addListener(_onTextChanged);
    passwordController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    ref
        .read(loginViewModelProvider.notifier)
        .validate(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final notifier = ref.read(loginViewModelProvider.notifier);

    // Listener Navigasi
    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (next.user != null) {
        context.go('/bank-materi');
      }
    });

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // ===================================================================
          // LAYER 1: BACKGROUND GRADIENT (Full Screen)
          // ===================================================================
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(gradient: AppColors.blueGradient),
            child: Stack(
              children: [
                // Lingkaran Dekoratif Kiri Atas
                Positioned(
                  top: -40,
                  left: -40,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Lingkaran Dekoratif Kanan Atas
                Positioned(
                  top: -20,
                  right: -50,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Tombol Back di Pojok Kiri Atas
                // Tombol Back di Pojok Kiri Atas
                Positioned(
                  top: MediaQuery.of(context).padding.top - 20,
                  left: 16,
                  child: IconButton(
                    onPressed: () {
                      // kalau ingin selalu ke AuthOptionView
                      context.go('/auth-option');

                      // kalau ingin dinamis (balik ke halaman sebelumnya di stack)
                      // context.pop();
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.3,
                        ), // lebih konsisten daripada withAlpha
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===================================================================
          // LAYER 2: CONTAINER PUTIH STATIS (Ukuran & Shape Fixed)
          // ===================================================================
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenWidth > 430
                  ? 430
                  : double
                        .infinity, // Fixed W: 430 (atau selebar layar jika HP kecil)
              height: 720, // Fixed H: 720
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), // Sudut atas 50
                  topRight: Radius.circular(50), // Sudut atas 50
                  bottomLeft: Radius.zero, // Sudut bawah 0
                  bottomRight: Radius.zero, // Sudut bawah 0
                ),
              ),
            ),
          ),

          // ===================================================================
          // LAYER 3: WRAPPER KONTEN TRANSPARAN (Di Atas Container Putih)
          // ===================================================================
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: const Offset(0, -115),
                child: SizedBox(
                  width: screenWidth > 430 ? 430 : double.infinity,
                  height: 730,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 28),

                          // 1. Logo Raih (Kombinasi Icon & Teks)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/logo_raih_dark.png',
                                height: 20,
                                errorBuilder: (ctx, err, stack) => const Icon(
                                  Icons.auto_awesome,
                                  color: AppColors.blueNormal,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Raih',
                                style: AppTextStyles.medium16.copyWith(
                                  color: AppColors.blackNormal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 2. Gambar auth_top.png
                          Image.asset(
                            'assets/images/auth_top.png',
                            height: 110,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.lock_person_rounded,
                                  size: 70,
                                  color: AppColors.blueNormal,
                                ),
                          ),
                          const SizedBox(height: 12),

                          // 3. Judul "Selamat Datang!"
                          Text(
                            'Selamat Datang!',
                            style: AppTextStyles.bold24.copyWith(
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),

                          // 4. Subtitle "Tidak punya akun? Daftar"
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Tidak punya akun? ',
                              style: AppTextStyles.regular14.copyWith(
                                color: AppColors.blackNormal,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Daftar',
                                  style: AppTextStyles.bold14.copyWith(
                                    color: AppColors.blueNormal,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => context.push('/register'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // 5. Custom Form TextFields
                          CustomTextField(
                            label: 'Email',
                            controller: emailController,
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            label: 'Kata Sandi',
                            isPassword: true,
                            isObscure: !state.isPasswordVisible,
                            controller: passwordController,
                            onTogglePassword: notifier.togglePasswordVisibility,
                          ),
                          const SizedBox(height: 10),

                          // 6. Link "Lupa Kata Sandi?"
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () => context.push('/forgot-password'),
                              child: Text(
                                'Lupa Kata Sandi?',
                                style: AppTextStyles.regular14.copyWith(
                                  color: AppColors.blueNormal,
                                ),
                              ),
                            ),
                          ),

                          // Pesan Error
                          if (state.errorMessage != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              state.errorMessage!,
                              style: AppTextStyles.regular12.copyWith(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],

                          const SizedBox(
                            height: 40,
                          ), // Diubah dari 60 menjadi 40 agar lebih efisien space
                          // 7. Tombol Masuk
                          state.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : UniversalButton(
                                  text: 'Masuk',
                                  variant: state.isButtonEnabled
                                      ? ButtonVariant.primary
                                      : ButtonVariant.disabled,
                                  onPressed: state.isButtonEnabled
                                      ? () => notifier.login(
                                          emailController.text,
                                          passwordController.text,
                                        )
                                      : null,
                                ),

                          const SizedBox(
                            height: 40,
                          ), // Diubah dari 100 menjadi 40 agar tidak memicu overflow di layar HP sedang
                          // 8. Tombol Google Auth
                          GoogleAuthButton(
                            onPressed: () => notifier.loginWithGoogle(),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
