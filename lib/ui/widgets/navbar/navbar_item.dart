import 'package:flutter/material.dart';

import 'package:raih/core/constants/const_colors.dart';

class NavbarItem extends StatelessWidget {
  final IconData icon;

  final IconData activeIcon;

  final String title;

  final bool selected;

  final VoidCallback onTap;

  const NavbarItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),

        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),

                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },

                child: Icon(
                  selected ? activeIcon : icon,

                  key: ValueKey(selected),

                  color: selected
                      ? AppColors.blueNormal
                      : AppColors.blackLightActive,
                ),
              ),

              const SizedBox(height: 4),

              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),

                style: TextStyle(
                  fontSize: 11,

                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,

                  color: selected
                      ? AppColors.blueNormal
                      : AppColors.blackLightActive,
                ),

                child: Text(title),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
