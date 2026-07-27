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
import 'package:raih/ui/features/auth/providers/register_provider.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  late final TextEditingController namaLengkapController;
  late final TextEditingController emailController;
  late final TextEditingController noAktifController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    namaLengkapController = TextEditingController();
    emailController = TextEditingController();
    noAktifController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    namaLengkapController.addListener(_onTextChanged);
    emailController.addListener(_onTextChanged);
    noAktifController.addListener(_onTextChanged);
    passwordController.addListener(_onTextChanged);
    confirmPasswordController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    namaLengkapController.dispose();
    emailController.dispose();
    noAktifController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    ref
        .read(registerViewModelProvider.notifier)
        .validate(
          namaLengkapController.text,
          emailController.text,
          noAktifController.text,
          passwordController.text,
          confirmPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerViewModelProvider);
    final notifier = ref.read(registerViewModelProvider.notifier);

    ref.listen<RegisterState>(registerViewModelProvider, (previous, next) {
      if (next.user != null) {
        context.go('/home');
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
                Positioned(
                  top: MediaQuery.of(context).padding.top - 20,
                  left: 16,
                  child: IconButton(
                    onPressed: () => context.go('/auth-option'),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
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
          // LAYER 2: CONTAINER PUTIH STATIS
          // ===================================================================
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenWidth > 430 ? 430 : double.infinity,
              height: 776,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
              ),
            ),
          ),

          // ===================================================================
          // LAYER 3: HEADER STATIS (LOGO RAIH DI ATAS GAMBAR REGIS_TOP)
          // ===================================================================
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: const Offset(0, -705), // Geser seluruh grup header ini
              child: SizedBox(
                width: screenWidth > 430 ? 430 : double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ---------------------------------------------------------
                    // 1. LOGO & TEKS RAIH (Berada di Atas Gambar)
                    // ---------------------------------------------------------
                    // Bebas kamu geser dengan Offset(X, Y) jika ingin kustomisasi posisinya
                    Transform.translate(
                      offset: const Offset(
                        0,
                        40,
                      ), // <-- ATUR POSISI LOGO DI SINI (Contoh: Offset(0, -10))
                      child: Row(
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
                    ),

                    // Jarak antara Logo Raih dan Gambar Regis Top (bisa disesuaikan)
                    const SizedBox(height: 12),

                    // ---------------------------------------------------------
                    // 2. GAMBAR REGIS_TOP.PNG (Berada di Bawah Logo)
                    // ---------------------------------------------------------
                    Transform.translate(
                      offset: const Offset(
                        0,
                        0,
                      ), // <-- ATUR POSISI GAMBAR DI SINI jika perlu
                      child: Image.asset(
                        'assets/images/regis_top.png',
                        height: 150,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.person_add_rounded,
                              size: 70,
                              color: AppColors.blueNormal,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ===================================================================
          // LAYER 4: WRAPPER FORM & JUDUL (DAPAT DI-SCROLL)
          // ===================================================================
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: screenWidth > 430 ? 430 : double.infinity,
                height: 760, // Tinggi area scroll di bawah header statis
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),

                        // 1. Judul "Daftar"
                        Text(
                          'Daftar',
                          style: AppTextStyles.bold37.copyWith(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        // 2. Subtitle "Sudah punya akun? Masuk"
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: 'Anda telah memiliki akun?',
                            style: AppTextStyles.regular14.copyWith(
                              color: AppColors.blackNormal,
                            ),
                            children: [
                              TextSpan(
                                text: 'Masuk',
                                style: AppTextStyles.bold14.copyWith(
                                  color: AppColors.blueNormal,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.push('/login'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 3. Custom Form TextFields
                        CustomTextField(
                          label: 'Nama Lengkap',
                          controller: namaLengkapController,
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          label: 'Email',
                          controller: emailController,
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          label: 'Nomor Aktif',
                          controller: noAktifController,
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          label: 'Fakultas',
                          isDropdown: true,
                          selectedValue: state.selectedFakultas,
                          dropdownItems: notifier.fakultasList,
                          onDropdownChanged: (value) {
                            notifier.setFakultas(
                              value,
                              namaLengkapController.text,
                              emailController.text,
                              noAktifController.text,
                              passwordController.text,
                              confirmPasswordController.text,
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          label: 'Kata Sandi',
                          controller: passwordController,
                          isPassword: true,
                          isObscure: !state.isPasswordVisible,
                          onTogglePassword: notifier.togglePasswordVisibility,
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          label: 'Konfirmasi Kata Sandi',
                          controller: confirmPasswordController,
                          isPassword: true,
                          isObscure: !state.isConfirmPasswordVisible,
                          onTogglePassword:
                              notifier.toggleConfirmPasswordVisibility,
                        ),

                        // Pesan Error jika ada
                        if (state.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            state.errorMessage!,
                            style: AppTextStyles.regular12.copyWith(
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],

                        const SizedBox(height: 32),

                        // 4. Tombol Daftar
                        state.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : UniversalButton(
                                text: 'Daftar',
                                variant: state.isButtonEnabled
                                    ? ButtonVariant.primary
                                    : ButtonVariant.disabled,
                                onPressed: state.isButtonEnabled
                                    ? () => notifier.register(
                                        name: namaLengkapController.text,
                                        email: emailController.text,
                                        phone: noAktifController.text,
                                        password: passwordController.text,
                                      )
                                    : null,
                              ),

                        const SizedBox(height: 20),

                        // 5. Tombol Google Auth
                        GoogleAuthButton(
                          onPressed: () => notifier.registerWithGoogle(),
                        ),
                        const SizedBox(height: 24),
                      ],
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
