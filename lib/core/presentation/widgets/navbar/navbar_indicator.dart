import 'package:flutter/material.dart';


class NavbarIndicator extends StatelessWidget {
  final int selectedIndex;
  final int itemCount;

  const NavbarIndicator({
    super.key,
    required this.selectedIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,

      alignment: Alignment(_calculateX(), -0.90),

      child: Container(
        width: 10,
        height: 10,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7283FF), // Lighter periwinkle blue
              Color(0xFF4A5CFC), // Deeper periwinkle blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  double _calculateX() {
    if (itemCount <= 1) return 0;

    return -1 + (selectedIndex * (2 / (itemCount - 1)));
  }
}
