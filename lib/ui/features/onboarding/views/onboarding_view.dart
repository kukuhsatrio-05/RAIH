import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
import 'package:raih/core/widgets/universal_button.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.rocket_launch,
                      size: 100,
                      color: AppColors.blueNormal,
                    ),
                    const SizedBox(height: 40),
                    Text('Welcome to RAIH', style: AppTextStyles.bold30),
                    const SizedBox(height: 24),
                    Text(
                      'Ini Adalah Onboarding page RAIH ANDROZONE 2026',
                      style: AppTextStyles.regular16,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UniversalButton(
                    text: 'Get Started',
                    variant: ButtonVariant.primary,
                    onPressed: () {
                      context.go('/auth-option');
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
