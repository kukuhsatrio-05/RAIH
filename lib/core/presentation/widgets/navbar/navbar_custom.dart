import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:raih/core/constants/app_navbar.dart';
import 'package:raih/core/models/navbar_item_models.dart';

import 'navbar_item.dart';
import 'navbar_background.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).matchedLocation;

    final int selectedIndex = AppNavbar.menus.indexWhere(
      (item) => item.route == currentRoute,
    );

    final int activeIndex = selectedIndex == -1 ? 0 : selectedIndex;

    return SafeArea(
      top: false,

      child: SizedBox(
        height: 88,

        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final itemWidth = width / AppNavbar.menus.length;

            return TweenAnimationBuilder<double>(
              tween: Tween<double>(end: activeIndex.toDouble()),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              builder: (context, animValue, child) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Shadow layer (top)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //------------------------------------------------
                    // Background
                    //------------------------------------------------
                    NavbarBackground(
                      activeIndex: animValue,
                      itemCount: AppNavbar.menus.length,
                    ),

                    //------------------------------------------------
                    // Menu
                    //------------------------------------------------
                    for (int i = 0; i < AppNavbar.menus.length; i++)
                      Positioned(
                        left: itemWidth * i,

                        width: itemWidth,

                        top: 0,

                        child: Builder(
                          builder: (_) {
                            final NavItemModel menu = AppNavbar.menus[i];

                            return AnimatedNavbarItem(
                              selected: i == selectedIndex,

                              icon: menu.icon,

                              activeIcon: menu.activeIcon,

                              title: menu.title,

                              onTap: () {
                                if (currentRoute != menu.route) {
                                  context.go(menu.route);
                                }
                              },
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
