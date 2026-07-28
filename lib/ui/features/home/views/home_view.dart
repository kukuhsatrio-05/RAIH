import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
import 'package:raih/core/widgets/universal_button.dart';
import 'package:raih/ui/features/home/viewmodels/home_provider.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(homeViewModelProvider.notifier).loadUser());
  }

  @override
  Widget build(BuildContext context) {
    // Listen perubahan state khusus untuk navigasi logout
    ref.listen<HomeState>(homeViewModelProvider, (previous, next) {
      // Pindah ke login HANYA jika sebelumnya ada user, lalu sekarang user-nya jadi null
      if (previous?.user != null && next.user == null && !next.isLoading) {
        context.go('/login');
      }
    });

    final state = ref.watch(homeViewModelProvider);

    // Tampilkan loading saat awal loadUser() berjalan
    if (state.isLoading && state.user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: AppTextStyles.bold24.copyWith(color: AppColors.blueNormal),
        ),
      ),
      body: Center(
        child: state.isLoading
            ? const CircularProgressIndicator()
            : state.user == null
            ? Text(
                "Tidak ada user login",
                style: AppTextStyles.medium16.copyWith(
                  color: AppColors.blueNormal,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hallo, ${state.user!.fullName.isNotEmpty ? state.user!.fullName : 'User'}",
                    style: AppTextStyles.medium16.copyWith(
                      color: AppColors.blueNormal,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: UniversalButton(
                      text: 'Keluar',
                      variant: ButtonVariant.primary,
                      onPressed: () =>
                          ref.read(homeViewModelProvider.notifier).logout(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
