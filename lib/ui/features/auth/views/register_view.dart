import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
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
    ref.read(registerViewModelProvider.notifier).validate(
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

    // Listen to changes in user or state
    ref.listen<RegisterState>(registerViewModelProvider, (previous, next) {
      if (next.user != null) {
        // Go back to login screen on success
        context.pop();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/regis_top.png',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    Center(
                      child: Text(
                        'Disini Logo | Raih',
                        style: AppTextStyles.medium16.copyWith(
                          color: AppColors.blackNormal,
                        ),
                      ),
                    ),

                    // Jarak dari header image
                    const SizedBox(height: 90),

                    Text('Daftar', style: AppTextStyles.bold30),

                    const SizedBox(height: 8),

                    RichText(
                      text: TextSpan(
                        text: 'Sudah punya akun? ',
                        style: AppTextStyles.regular16.copyWith(
                          color: AppColors.blackNormal,
                        ),
                        children: [
                          TextSpan(
                            text: 'Masuk',
                            style: AppTextStyles.medium16.copyWith(
                              color: Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.push('/login'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 42),

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
                      label: 'Password',
                      controller: passwordController,
                      isPassword: true,
                      isObscure: !state.isPasswordVisible,
                      onTogglePassword: notifier.togglePasswordVisibility,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label: 'Konfirmasi Password',
                      controller: confirmPasswordController,
                      isPassword: true,
                      isObscure: !state.isConfirmPasswordVisible,
                      onTogglePassword: notifier.toggleConfirmPasswordVisibility,
                    ),

                    // Error message
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

                    const SizedBox(height: 40),

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

                    const SizedBox(height: 24),

                    GoogleAuthButton(
                      onPressed: () => notifier.registerWithGoogle(),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
