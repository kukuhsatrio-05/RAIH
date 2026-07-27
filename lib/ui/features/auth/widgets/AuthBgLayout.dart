import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';

class AuthBackgroundLayout extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBackPressed;

  const AuthBackgroundLayout({
    super.key,
    required this.child,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // LAYER 1: BACKGROUND GRADIENT & DEKORASI
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(gradient: AppColors.blueGradient),
            child: Stack(
              children: [
                // Lingkaran Dekoratif Kiri Atas
                Positioned(
                  top: -40,
                  left: -40,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Lingkaran Dekoratif Kanan Atas
                Positioned(
                  top: -20,
                  right: -50,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Tombol Back
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 16,
                  child: IconButton(
                    onPressed:
                        onBackPressed ?? () => context.go('/auth-option'),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LAYER 2: CONTAINER PUTIH
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenWidth > 430 ? 430 : double.infinity,
              height: 720,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
            ),
          ),

          // LAYER 3: KONTEN UTAMA (KISI LAYAR UTAMA)
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: screenWidth > 430 ? 430 : double.infinity,
                height: 720,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
