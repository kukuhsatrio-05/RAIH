import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:raih/core/theme/app_colors.dart';

class BrandGradientHeader extends StatelessWidget {
  final Widget child; // Kita bisa memasukkan Icon apa saja di tengah

  const BrandGradientHeader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 439,
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 431),
      decoration: BoxDecoration(
        gradient: AppColors.blueGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(48),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lingkaran dekoratif (dibuat static saja jika selalu sama)
          Positioned(top: 290, left: -50, child: _circle(190)),
          Positioned(top: -50, left: 200, child: _circle(255)),

          // Container Icon
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(45),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1,
              ),
            ),
            child: Center(child: child),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      shape: BoxShape.circle,
    ),
  );
}
