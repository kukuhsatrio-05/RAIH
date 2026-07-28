import 'package:go_router/go_router.dart';
import 'package:raih/ui/features/onboarding/views/onboarding_view.dart';
import 'package:raih/ui/features/auth/views/auth_option_view.dart';
import 'package:raih/ui/features/auth/views/login_view.dart';
import 'package:raih/ui/features/auth/views/register_view.dart';
// import 'package:raih/ui/features/home/views/home_view.dart';
import 'package:raih/ui/features/home/views/home_views.dart';
import 'package:raih/ui/features/counter_riverpod/views/riverpod_counter_view.dart';
import 'package:raih/ui/features/mading/mading_views.dart';
import 'package:raih/ui/features/materi/materi_views.dart';
import 'package:raih/ui/features/profile/profile_views.dart';
import 'package:raih/ui/features/upload/upload_views.dart';
import 'package:raih/ui/features/home/views/event_detail_view.dart';
import 'package:raih/ui/layouts/navbar_layout.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      //------------------------
      // Onboarding
      //------------------------
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),

      //------------------------
      // Auth
      //------------------------
      // Auth Options
      GoRoute(
        path: '/auth-option',
        builder: (context, state) => const AuthOptionView(),
      ),

      // Login
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),

      // Register
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),

      // Counters
      GoRoute(
        path: '/counter-riverpod',
        builder: (context, state) => const RiverpodCounterView(),
      ),

      //------------------------
      // Main Layout
      //------------------------
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },

        routes: [
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

          GoRoute(
            path: '/mading',
            builder: (context, state) => const MadingView(),
          ),

          GoRoute(
            path: '/upload',
            builder: (context, state) => const UploadView(),
          ),

          GoRoute(
            path: '/materi',
            builder: (context, state) => const MateriView(),
          ),

          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileView(),
          ),
        ],
      ),
    ],
  );
}
