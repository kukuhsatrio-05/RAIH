import 'package:flutter/material.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';

class BenefitCard extends StatelessWidget {
  final String benefitText;

  const BenefitCard({super.key, required this.benefitText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greenLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greenBorder, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.greenNormal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              color: AppColors.whiteNormal,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hadiah / Benefit",
                  style: AppTextStyles.semibold14.copyWith(
                    color: AppColors.greenNormal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  benefitText,
                  style: AppTextStyles.bold16.copyWith(
                    color: AppColors.greenDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

