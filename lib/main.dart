// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/ui/features/mading/views/mading_details_views.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/app/config/router.dart';
import 'package:raih/core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "api.env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    publishableKey: dotenv.env['SUPABASE_KEY'] ?? '',
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAIH',
      debugShowCheckedModeBanner: false,
      // routerConfig: AppRouter.router,
      theme: AppTheme.lightTheme,
      home: MadingDetailView(postId: 'lomba-1'),
    );
  }
}
