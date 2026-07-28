import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:raih/core/constants/const_colors.dart';
import 'package:raih/core/constants/app_navbar.dart';
import 'package:raih/model/navbar_item_models.dart';
import 'package:raih/ui/widgets/navbar/navbar_item.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    //--------------------------------------------------
    // Route aktif
    //--------------------------------------------------

    final String currentRoute = GoRouterState.of(context).matchedLocation;

    //--------------------------------------------------
    // Index aktif
    //--------------------------------------------------

    final int selectedIndex = AppNavbar.menus.indexWhere(
      (menu) => menu.route == currentRoute,
    );

    //--------------------------------------------------
    // Navbar
    //--------------------------------------------------

    return SafeArea(
      top: false,
      child: Container(
        height: 75,

        decoration: const BoxDecoration(
          color: AppColors.whiteNormal,

          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: Offset(0, -2),
              color: Color(0x14000000),
            ),
          ],
        ),

        child: Row(
          children: List.generate(AppNavbar.menus.length, (index) {
            final NavItemModel menu = AppNavbar.menus[index];

            return NavbarItem(
              title: menu.title,

              icon: menu.icon,

              activeIcon: menu.activeIcon,

              selected: index == selectedIndex,

              onTap: () {
                if (currentRoute != menu.route) {
                  context.go(menu.route);
                }
              },
            );
          }),
        ),
      ),
    );
  }
}
