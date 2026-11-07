import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
import 'package:raih/features/profile/presentation/profile_controller.dart';
import 'package:raih/features/profile/data/profile_model.dart';

typedef ProfileScreen = ProfileView;

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileProvider.notifier).fetchOwnProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profileNotifier = ref.read(profileProvider.notifier);

    final isCompleted = profileState.isProfileCompleted;
    final buttonText = isCompleted ? 'Edit Profile' : 'Lengkapi Profile';
    final buttonColor = isCompleted
        ? AppColors.blueNormal
        : const Color(0xFFE74C3C);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          children: [
            // Header Blue
            SizedBox(
              height: 180,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.blueGradientStart,
                          AppColors.blueGradientEnd,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Profile Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Transform.translate(
                offset: const Offset(0, -50),
                child: profileState.isLoading
                    ? _buildLoadingSkeleton()
                    : profileState.error != null
                    ? _buildErrorState(
                        profileState.error!,
                        () => profileNotifier.fetchOwnProfile(),
                      )
                    : _buildProfileCard(profileState.profile),
              ),
            ),

            const SizedBox(height: 16),

            // CTA Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    context.push('/profile/edit');
                  },
                  child: Text(
                    buttonText,
                    style: AppTextStyles.bold14.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),

            if (profileState.hasProfile) ...[
              const SizedBox(height: 20),
              _buildMockSections(profileState.profile!.skills),
            ],

            const SizedBox(height: 20),

            // Debug Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE74C3C), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await Supabase.instance.client.auth.signOut();
                      if (context.mounted) {
                        context.go('/splash');
                      }
                    } catch (e) {
                      // Error handled by UI if needed
                    }
                  },
                  child: Text(
                    'Debug: Logout',
                    style: AppTextStyles.medium12.copyWith(
                      color: const Color(0xFFE74C3C),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Loading skeleton
  Widget _buildLoadingSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 150, height: 16, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Container(width: 200, height: 12, color: Colors.grey[300]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Error state
  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 12),
          Text(
            'Gagal memuat profil',
            style: AppTextStyles.semibold14.copyWith(
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }

  // Profile card
  Widget _buildProfileCard(ProfileModel? profile) {
    if (profile == null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text('No profile data', style: AppTextStyles.regular14),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.blueNormal, width: 2),
                ),
                child: CircleAvatar(
                  backgroundColor: AppColors.blueLight,
                  child: Text(
                    profile.fullName
                        .split(' ')
                        .map((e) => e[0])
                        .join()
                        .toUpperCase(),
                    style: AppTextStyles.bold16.copyWith(
                      color: AppColors.blueNormal,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style: AppTextStyles.bold16.copyWith(
                        color: const Color(0xFF173568),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (profile.faculty != null && profile.faculty!.isNotEmpty)
                      Text(
                        profile.faculty!,
                        style: AppTextStyles.regular12.copyWith(
                          color: const Color(0xFF788397),
                        ),
                      ),
                    if (profile.major != null && profile.major!.isNotEmpty)
                      Text(
                        profile.major!,
                        style: AppTextStyles.medium12.copyWith(
                          color: const Color(0xFF788397),
                        ),
                      ),
                    if (profile.location != null)
                      Text(
                        profile.location!,
                        style: AppTextStyles.regular12.copyWith(
                          color: const Color(0xFF788397),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (profile.isOpenToJoin || profile.isMentor) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (profile.isOpenToJoin)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8FDF2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFB7EBD0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.groups_outlined,
                          size: 16,
                          color: Color(0xFF047857),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Join My Team',
                          style: AppTextStyles.semibold12.copyWith(
                            color: const Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (profile.isOpenToJoin && profile.isMentor)
                  const SizedBox(width: 8),
                if (profile.isMentor)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEFCE8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFEF08A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.school_outlined,
                          size: 16,
                          color: Color(0xFFA16207),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Mentor',
                          style: AppTextStyles.semibold12.copyWith(
                            color: const Color(0xFFA16207),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
          if (profile.bio?.isNotEmpty ?? false) ...[
            const SizedBox(height: 12),
            Text(
              profile.bio!,
              style: AppTextStyles.regular12.copyWith(
                color: const Color(0xFF788397),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FE),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Column(
              children: [
                Text(
                  '0',
                  style: AppTextStyles.bold16.copyWith(
                    color: AppColors.blueNormal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Koneksi',
                  style: AppTextStyles.regular12.copyWith(
                    color: const Color(0xFF788397),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mock sections
  Widget _buildMockSections(List<String> skills) {
    return Column(
      children: [
        // Skills
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star_outline, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Keahlian',
                      style: AppTextStyles.semibold13.copyWith(
                        color: const Color(0xFF173568),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (skills.isEmpty)
                  Text(
                    'Belum ada keahlian',
                    style: AppTextStyles.regular12.copyWith(
                      color: const Color(0xFF788397),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: skills
                        .map(
                          (skill) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.blueLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFBBD0FF),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              skill,
                              style: AppTextStyles.regular12.copyWith(
                                color: AppColors.blueNormal,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Recommendations
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.format_quote, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Rekomendasi',
                      style: AppTextStyles.semibold13.copyWith(
                        color: const Color(0xFF173568),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Fitur rekomendasi akan segera hadir',
                  style: AppTextStyles.regular12.copyWith(
                    color: const Color(0xFF788397),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
