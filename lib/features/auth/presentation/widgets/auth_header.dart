import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String normalSubtitle;
  final String clickableSubtitle;
  final VoidCallback onSubtitleTap;

  const AuthHeader({
    super.key,
    required this.title,
    required this.normalSubtitle,
    required this.clickableSubtitle,
    required this.onSubtitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 28),
        // 1. Logo Raih
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
              style: AppTextStyles.medium24.copyWith(
                color: AppColors.blackNormal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 2. Gambar Auth Top
        Image.asset(
          'assets/images/auth_top.png',
          height: 110,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.lock_person_rounded,
            size: 70,
            color: AppColors.blueNormal,
          ),
        ),
        const SizedBox(height: 12),

        // 3. Judul Utama
        Text(
          title,
          style: AppTextStyles.bold24.copyWith(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),

        // 4. Subtitle dengan Link Tekan
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: normalSubtitle,
            style: AppTextStyles.regular14.copyWith(
              color: AppColors.blackNormal,
            ),
            children: [
              TextSpan(
                text: clickableSubtitle,
                style: AppTextStyles.bold14.copyWith(
                  color: AppColors.blueNormal,
                ),
                recognizer: TapGestureRecognizer()..onTap = onSubtitleTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
