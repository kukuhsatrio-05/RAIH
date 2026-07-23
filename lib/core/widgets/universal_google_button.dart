import 'package:flutter/material.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleAuthButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleAuthButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 376,
      height: 51,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color.fromARGB(148, 158, 158, 158),
          ), // outline abu muda
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/logo_google.png', height: 24),
            const SizedBox(width: 12),
            Text(
              'Atau Masuk Dengan Google',
              style: AppTextStyles.regular16.copyWith(
                color: AppColors.blackNormal,
              ), // teks hitam
            ),
          ],
        ),
      ),
    );
  }
}

