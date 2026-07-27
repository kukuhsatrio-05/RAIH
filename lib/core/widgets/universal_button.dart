import 'package:flutter/material.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart'; // pastikan path sesuai

enum ButtonVariant { primary, secondary, disabled, outlined }

class UniversalButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;

  const UniversalButton({
    super.key,
    required this.text,
    required this.variant,
    this.onPressed,
  });

  Color _backgroundColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return AppColors.blueNormal;
      case ButtonVariant.secondary:
        return AppColors.blueNormalActive;
      case ButtonVariant.disabled:
        return AppColors.blackLightActive;
      case ButtonVariant.outlined:
        return Colors.transparent; // outlined → transparan
    }
  }

  BorderSide _borderSide() {
    switch (variant) {
      case ButtonVariant.outlined:
        return BorderSide(color: AppColors.blueNormal, width: 2);
      default:
        return BorderSide.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 376,
      height: 51,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: _borderSide(),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 32,
          ), // ✅
          elevation: 0,
        ),
        onPressed: variant == ButtonVariant.disabled ? null : onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.bold16.copyWith(
            color: variant == ButtonVariant.outlined
                ? AppColors.blueNormal
                : Colors.white,
          ),
        ),
      ),
    );
  }
}

