import 'package:flutter/material.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';

class MainInfoCard extends StatelessWidget {
  final String title;
  final String organizer;
  final String location;

  const MainInfoCard({
    super.key,
    required this.title,
    required this.organizer,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteNormal,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackNormal.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bold16.copyWith(
              color: AppColors.blackNormal,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.account_balance_outlined,
                size: 16,
                color: AppColors.whiteDarker,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  organizer,
                  style: AppTextStyles.regular14.copyWith(
                    color: AppColors.whiteDarker,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.whiteDarker,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location,
                  style: AppTextStyles.regular14.copyWith(
                    color: AppColors.whiteDarker,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
