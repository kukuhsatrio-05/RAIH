import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Wajib import package riverpod
import 'package:raih/ui/features/onboarding/views/onboarding_views.dart'; // Sesuaikan dengan path import kamu

void main() {
  runApp(
    // 2. Wajib bungkus MyApp dengan ProviderScope
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding MVVM Riverpod',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Mengaktifkan Material 3
        primarySwatch: Colors.blue,
      ),
      home:
          const OnboardingView(), // Langsung mengarah ke halaman onboarding kamu
    );
  }
}
