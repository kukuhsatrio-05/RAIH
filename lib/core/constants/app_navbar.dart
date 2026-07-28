import 'package:flutter/material.dart';

import 'package:raih/model/navbar_item_models.dart';

class AppNavbar {
  AppNavbar._();

  static const List<NavItemModel> menus = [
    NavItemModel(
      title: "Beranda",
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      route: "/home",
    ),

    NavItemModel(
      title: "Mading",
      icon: Icons.article_outlined,
      activeIcon: Icons.article,
      route: "/mading",
    ),

    NavItemModel(
      title: "Unggah",
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      route: "/upload",
    ),

    NavItemModel(
      title: "Materi",
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book,
      route: "/materi",
    ),

    NavItemModel(
      title: "Profil",
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      route: "/profile",
    ),
  ];
}
