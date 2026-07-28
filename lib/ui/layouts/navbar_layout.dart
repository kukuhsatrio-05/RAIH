import 'package:flutter/material.dart';
import 'package:raih/ui/widgets/navbar/navbar_custom.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: child,

      bottomNavigationBar: const CustomBottomNavbar(),
    );
  }
}
