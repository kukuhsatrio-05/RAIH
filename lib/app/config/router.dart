import 'package:go_router/go_router.dart';
import 'package:raih/ui/features/onboarding/views/onboarding_view.dart';
import 'package:raih/ui/features/auth/views/auth_option_view.dart';
import 'package:raih/ui/features/auth/views/login_view.dart';
import 'package:raih/ui/features/auth/views/register_view.dart';
import 'package:raih/ui/features/home/views/home_view.dart';
import 'package:raih/ui/features/counter_riverpod/views/riverpod_counter_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),

      // Auth Options
      GoRoute(
        path: '/auth-option',
        builder: (context, state) => const AuthOptionView(),
      ),

      // Login
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),

      // Register
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),

      // Home
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeView(),
      ),

      // Counters
      GoRoute(
        path: '/counter-riverpod',
        builder: (context, state) => const RiverpodCounterView(),
      ),
    ],
  );
}
