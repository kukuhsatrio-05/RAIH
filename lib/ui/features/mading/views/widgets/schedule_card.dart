import 'package:flutter/material.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';

class ScheduleSection extends StatelessWidget {
  final String openDate;
  final String endDate;

  const ScheduleSection({
    super.key,
    required this.openDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Card Pendaftaran Buka
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.whiteNormal,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.blackLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.blueNormal,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Pendaftaran buka",
                      style: AppTextStyles.regular14.copyWith(
                        color: AppColors.whiteDarker,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  openDate,
                  style: AppTextStyles.bold14.copyWith(
                    color: AppColors.blackNormal,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Card Batas Akhir
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.redLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.redNormal, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.redNormal,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Batas Akhir",
                      style: AppTextStyles.bold14.copyWith(
                        color: AppColors.redNormal,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  endDate,
                  style: AppTextStyles.bold14.copyWith(
                    color: AppColors.redDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
