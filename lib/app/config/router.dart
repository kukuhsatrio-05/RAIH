import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/features/splash/presentation/splash_screen.dart';
import 'package:raih/features/onboarding/presentation/onboarding_screen.dart';
import 'package:raih/features/auth/presentation/login_screen.dart';
import 'package:raih/features/auth/presentation/register_screen.dart';
import 'package:raih/features/home/presentation/home_screen.dart';
import 'package:raih/features/mading/presentation/mading_screen.dart';
import 'package:raih/features/mading/presentation/mading_details_screen.dart';
import 'package:raih/features/materi/presentation/materi_screen.dart';
import 'package:raih/features/profile/presentation/profile_screen.dart';
import 'package:raih/features/profile/presentation/edit_profile_screen.dart';
import 'package:raih/features/upload/presentation/upload_screen.dart';
import 'package:raih/features/home/presentation/event_detail_screen.dart';
import 'package:raih/ui/layouts/navbar_layout.dart';
import 'package:raih/features/bank_materi/presentation/bank_materi_screen.dart';
import 'package:raih/features/bank_materi/presentation/document_detail_screen.dart';

class AppRouter {
  // Route auth (tidak perlu login)
  static const _publicRoutes = [
    '/splash',
    '/onboarding',
    '/login',
    '/register',
  ];

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final currentPath = state.matchedLocation;
      final isOnPublicRoute = _publicRoutes.contains(currentPath);

      // ✅ Sudah login tapi masih di public route → redirect ke home
      if (isLoggedIn && isOnPublicRoute) {
        return '/home';
      }

      // ✅ Belum login tapi mau ke protected route → redirect ke onboarding
      if (!isLoggedIn && !isOnPublicRoute) {
        return '/onboarding';
      }

      return null;
    },
    routes: [
      // ======================== PUBLIC ROUTES (no navbar) ========================
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),

      GoRoute(path: '/login', builder: (context, state) => const LoginView()),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),

      // Edit / lengkapi profil (full screen, tanpa navbar)
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),

      // ======================== PROTECTED ROUTES (with navbar) ========================
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          // Home & Event Detail
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeViews(),
          ),

          GoRoute(
            path: '/detail/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return EventDetailView(eventId: id);
            },
          ),

          // Mading & Mading Detail
          GoRoute(
            path: '/mading',
            builder: (context, state) => const MadingView(),
          ),

          GoRoute(
            path: '/mading/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return MadingDetailView(postId: id);
            },
          ),

          // Bank Materi & Document Detail
          GoRoute(
            path: '/bank-materi',
            builder: (context, state) => const BankMateriView(),
          ),

          GoRoute(
            path: '/bank-materi/detail/:id',
            builder: (context, state) {
              final documentId = state.pathParameters['id'] ?? '';
              return DocumentDetailView(documentId: documentId);
            },
          ),

          // Materi
          GoRoute(
            path: '/materi',
            builder: (context, state) => const MateriView(),
          ),

          // Upload
          GoRoute(
            path: '/upload',
            builder: (context, state) => const UploadView(),
          ),

          // Profile
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileView(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.matchedLocation}')),
    ),
  );
}
