import 'package:flutter/material.dart';


class AnimatedNavbarItem extends StatelessWidget {
  final bool selected;

  final IconData icon;

  final IconData activeIcon;

  final String title;

  final VoidCallback onTap;

  const AnimatedNavbarItem({
    super.key,
    required this.selected,
    required this.icon,
    required this.activeIcon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,

      child: SizedBox(
        width: 72,
        height: 80,

        child: Stack(
          clipBehavior: Clip.none,

          alignment: Alignment.center,

          children: [
            //--------------------------------------------
            // Bubble
            //--------------------------------------------
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,

              top: selected ? -8 : 8,

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),

                curve: Curves.easeInOut,

                width: selected ? 56 : 42,

                height: selected ? 56 : 42,

                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(
                          colors: [
                            Color(0xFF7283FF), // Lighter periwinkle blue
                            Color(0xFF4A5CFC), // Deeper periwinkle blue
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: selected ? null : Colors.transparent,

                  shape: BoxShape.circle,

                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF4A5CFC).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [],
                ),

                child: Icon(
                  selected ? activeIcon : icon,

                  color: selected ? Colors.white : Colors.grey,

                  size: selected ? 28 : 24,
                ),
              ),
            ),

            //--------------------------------------------
            // Text
            //--------------------------------------------
            Positioned(
              bottom: 4,

              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),

                style: TextStyle(
                  fontSize: 11,

                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,

                  color: selected ? const Color(0xFF4A5CFC) : Colors.grey,
                ),

                child: Text(title),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
