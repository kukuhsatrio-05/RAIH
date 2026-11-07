import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:raih/core/constants/env_constants.dart';
import 'package:raih/core/theme/app_theme.dart';
import 'package:raih/app/config/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "api.env");
  await Supabase.initialize(
    url: EnvConstants.supabaseUrl,
    publishableKey: EnvConstants.supabasePublishableKey,
  );
  // Initialize locale data for date formatting
  await initializeDateFormatting('id_ID', null);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RAIH',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: AppTheme.lightTheme,
    );
  }
}
