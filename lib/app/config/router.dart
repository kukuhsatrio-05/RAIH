import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/ui/features/onboarding/views/screens/onboarding_view.dart';
import 'package:raih/ui/features/auth/views/screens/auth_option_view.dart';
import 'package:raih/ui/features/auth/views/screens/login_view.dart';
import 'package:raih/ui/features/auth/views/screens/register_view.dart';
import 'package:raih/ui/features/home/views/home_view.dart';
import 'package:raih/ui/features/bank_materi/views/screens/material_screen.dart';
import 'package:raih/ui/features/bank_materi/views/screens/document_detail_view.dart';

class AppRouter {
  // Route yang hanya boleh diakses saat belum login
  static const _authRoutes = ['/auth-option', '/login', '/register'];

  // Route yang butuh autentikasi
  // static const _protectedRoutes = ['/bank-materi', '/bank-materi/detail', '/home'];

  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final currentPath = state.matchedLocation;
      final isOnAuthRoute = _authRoutes.contains(currentPath);

      // Sudah login tapi coba buka login/register -> redirect ke bank materi
      if (isLoggedIn && isOnAuthRoute) {
        return '/bank-materi';
      }

      // Selama development, kita izinkan masuk ke bank-materi tanpa paksaan redirect
      // Belum login tapi mau ke halaman protected selain bank-materi -> redirect ke auth option
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
        path: '/bank-materi',
        builder: (context, state) => const BankMateriView(),
        routes: [
          GoRoute(
            path: 'detail/:id',
            builder: (context, state) {
              final documentId = state.pathParameters['id'] ?? '';
              return DocumentDetailView(documentId: documentId);
            },
          ),
        ],
      ),
    ],
  );
}
