import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
import 'package:raih/core/widgets/universal_button.dart';
import 'package:raih/core/widgets/universal_google_button.dart';
import 'package:raih/core/widgets/universal_text_input.dart';
import 'package:raih/ui/features/auth/providers/login_provider.dart';

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
    ref.read(loginViewModelProvider.notifier).validate(
          emailController.text,
          passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final notifier = ref.read(loginViewModelProvider.notifier);

    // Listen to changes in user
    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (next.user != null) {
        context.go('/home');
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Disini Logo | Raih',
                style: AppTextStyles.medium16.copyWith(
                  color: AppColors.blackNormal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Image.asset(
                'assets/images/auth_top.png',
                height: 100,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 100,
                  child: Icon(Icons.image, size: 50, color: AppColors.blueNormal),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selamat Datang',
                style: AppTextStyles.bold30,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Belum punya akun? ',
                  style: AppTextStyles.regular16.copyWith(
                    color: AppColors.blackNormal,
                  ),
                  children: [
                    TextSpan(
                      text: 'Daftar',
                      style: AppTextStyles.medium16.copyWith(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push('/register'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 42),

              CustomTextField(
                label: 'Email',
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                isPassword: true,
                isObscure: !state.isPasswordVisible,
                controller: passwordController,
                onTogglePassword: notifier.togglePasswordVisibility,
              ),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => context.push('/forgot-password'),
                  child: Text(
                    'Lupa Password?',
                    style: AppTextStyles.regular16.copyWith(
                      color: Colors.blue,
                    ),
                  ),
                ),
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

              const SizedBox(height: 60),

              state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : UniversalButton(
                      text: 'Masuk',
                      variant: state.isButtonEnabled
                          ? ButtonVariant.primary
                          : ButtonVariant.disabled,
                      onPressed: state.isButtonEnabled
                          ? () => notifier.login(emailController.text, passwordController.text)
                          : null,
                    ),
              const SizedBox(height: 100),
              GoogleAuthButton(
                onPressed: () => notifier.loginWithGoogle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
