import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:raih/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Delay minimal untuk menampilkan splash 1-2 detik
    await Future.delayed(const Duration(milliseconds: 1500));

    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;

    if (!mounted) return;

    // Jika sudah login → langsung ke home
    if (isLoggedIn) {
      context.go('/home');
      return;
    }

    // Belum login → ke onboarding
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            SvgPicture.asset(
              'assets/icons/logo_raih_ori.svg',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 24),
            // App name
            const Text(
              'RAIH',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.blueGradientEnd,
              ),
            ),
            const SizedBox(height: 48),
            // Loading spinner
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.blueGradientEnd,
                ),
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
