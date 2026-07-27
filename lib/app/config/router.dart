import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/ui/features/counter_riverpod/views/riverpod_counter_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/ui/features/onboarding/views/onboarding_view.dart';
import 'package:raih/ui/features/auth/views/auth_option_view.dart';
import 'package:raih/ui/features/auth/views/login_view.dart';
import 'package:raih/ui/features/auth/views/register_view.dart';
import 'package:raih/ui/features/home/views/home_view.dart';

class AppRouter {
  // HAPUS '/onboarding' DARI SINI agar tidak ter-redirect otomatis saat session Supabase aktif
  static const _authRoutes = ['/auth-option', '/login', '/register'];

  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final currentPath = state.matchedLocation;
      final isOnAuthRoute = _authRoutes.contains(currentPath);

      // Sudah login tapi coba buka login/register -> redirect ke home
      if (isLoggedIn && isOnAuthRoute) {
        return '/home';
      }

      // Belum login tapi mau ke home -> redirect ke auth option
      if (!isLoggedIn && currentPath == '/home') {
        return '/auth-option';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: '/auth-option',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const AuthOptionView(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Menggunakan FadeTransition agar header gradient terasa "tetap di tempat"
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(
              milliseconds: 300,
            ), // Durasi transisi
          );
        },
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeView()),
      GoRoute(
        path: '/counter-riverpod',
        builder: (context, state) => const RiverpodCounterView(),
      ),
    ],
  );
}
