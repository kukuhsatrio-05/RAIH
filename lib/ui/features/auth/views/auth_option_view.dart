import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
import 'package:raih/core/widgets/universal_button.dart';

class AuthOptionView extends StatelessWidget {
  const AuthOptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Text Center
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_person_outlined,
                      size: 80,
                      color: AppColors.blueNormal,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Tunggu apa lagi?',
                      style: AppTextStyles.medium30, textAlign: TextAlign.center
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mulai bisnismu sekarang dan rasakan pengalaman terbaik besama Rintis!',
                      style: AppTextStyles.regular16, textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UniversalButton(
                    text: 'Buat Akun',
                    variant: ButtonVariant.primary,
                    onPressed: () {
                      context.go('/register');
                    },
                  ),
                  const SizedBox(height: 16),
                  UniversalButton(
                    text: 'Masuk',
                    variant: ButtonVariant.outlined,
                    onPressed: () {
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
