import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/core/constants/env_constants.dart';
import 'package:raih/core/theme/app_theme.dart';
import 'package:raih/features/mading/presentation/mading_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "api.env");
  await Supabase.initialize(
    url: EnvConstants.supabaseUrl,
    publishableKey: EnvConstants.supabasePublishableKey,
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
