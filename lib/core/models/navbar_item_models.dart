import 'package:flutter/material.dart';

class NavItemModel {
  final String title;

  /// icon ketika belum dipilih
  final IconData icon;

  /// icon ketika dipilih
  final IconData activeIcon;

  final String route;

  const NavItemModel({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}
