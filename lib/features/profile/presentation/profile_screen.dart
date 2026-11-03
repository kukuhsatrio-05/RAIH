import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';

typedef ProfileScreen = ProfileView;

// Mock Data Models
class ProfileData {
  final String name;
  final String faculty;
  final String program;
  final String year;
  final String status;
  final int connections;
  final String location;
  final String linkedin;
  final String whatsapp;
  final String instagram;
  final String about;
  final List<String> skills;
  final List<Experience> experiences;
  final List<Recommendation> recommendations;

  ProfileData({
    required this.name,
    required this.faculty,
    required this.program,
    required this.year,
    required this.status,
    required this.connections,
    required this.location,
    required this.linkedin,
    required this.whatsapp,
    required this.instagram,
    required this.about,
    required this.skills,
    required this.experiences,
    required this.recommendations,
  });
}

class Experience {
  final String title;
  final String? status; // 'Aktif' or null
  final String organization;
  final String period;
  final String description;
  final Color iconColor;

  Experience({
    required this.title,
    this.status,
    required this.organization,
    required this.period,
    required this.description,
    required this.iconColor,
  });
}

class Recommendation {
  final String name;
  final String initials;
  final String position;
  final String relation;
  final String testimonial;

  Recommendation({
    required this.name,
    required this.initials,
    required this.position,
    required this.relation,
    required this.testimonial,
  });
}

// Mock data
final mockProfileData = ProfileData(
  name: 'Fikri Ramadhan',
  faculty: 'Fakultas Ilmu Komputer',
  program: 'Teknik Informatika',
  year: '2023',
  status: 'Join My Team',
  connections: 248,
  location: 'Depok, Jawa Barat',
  linkedin: 'linkedin.com/in/fikriramadhan',
  whatsapp: 'wa.me/6281234567890',
  instagram: '@fikriramadhan_',
  about:
      'Mahasiswa Teknik Informatika UB yang passionate di bidang UI/UX Design dan pengembangan produk digital. Aktif mengikuti lomba dan mentoring tim yang solid untuk kompetisi nasional. Pengalaman dalam PKM, hackathon, dan business plan competition.',
  skills: [
    'UI/UX Design',
    'React.js',
    'Python',
    'Leadership',
    'Public Speaking',
  ],
  experiences: [
    Experience(
      title: 'UI/UX Designer Lead',
      status: 'Aktif',
      organization: 'Tim PKM-KC Universitas Indonesia',
      period: 'Sep 2024 – Sekarang',
      description:
          'Memimpin desain antarmuka aplikasi manajemen sampah berbasis AI untuk kompetisi',
      iconColor: AppColors.blueNormal,
    ),
    Experience(
      title: 'Juara 2 - Business Plan Competition',
      organization: 'FEB Universitas Gadjah Mada',
      period: 'Okt 2024',
      description:
          'Berhasil meraih juara 2 dalam kompetisi business plan tingkat nasional dengan ide bisnis',
      iconColor: AppColors.blueLightActive,
    ),
    Experience(
      title: 'Pemateri Workshop React.js',
      organization: 'GDSC Universitas Indonesia',
      period: 'Ags 2024',
      description:
          'Membawakan workshop React.js fundamentals untuk 80+ peserta mahasiswa lintas kampus.',
      iconColor: AppColors.blueLightActive,
    ),
  ],
  recommendations: [
    Recommendation(
      name: 'Dinda Kusuma',
      initials: 'DK',
      position: 'Ketua Tim PKM-KC 2024',
      relation: 'Rekan Tim',
      testimonial:
          'Fikri adalah desainer yang luar biasa. Dia mampu menerjemahkan ide abstrak menjadi UI yang intuitif dan estetis dalam waktu singkat. Selain itu, kepemimpinannya dalam tim sangat menginspirasi semua anggota.',
    ),
    Recommendation(
      name: 'Eka Rama',
      initials: 'ER',
      position: 'Frontend Dev',
      relation: 'Mentor',
      testimonial:
          'Saya pernah mentoring Fikri dalam persiapan hackathon nasional. Kemampuan problem-solving-nya tajam, dan dia sangat cepat menyerap feedback. Potensinya besar di dunia product design.',
    ),
  ],
);

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = mockProfileData;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                // 1. Blue header with decorative circles
                SizedBox(
                  height: 180,
                  child: Stack(
                    children: [
                      // Gradient background
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
                      // Decorative circles (transparent)
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
                // 2. Profile card (overlaps header)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Transform.translate(
                    offset: const Offset(0, -50),
                    child: _ProfileCard(profile: profile),
                  ),
                ),
                // 3. Edit Profile Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueNormal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Navigate to edit profile
                      },
                      child: Text(
                        'Edit Profile',
                        style: AppTextStyles.bold14.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 4. Skills Section
                _SkillsSection(skills: profile.skills),
                const SizedBox(height: 16),
                // 5. About Section
                _AboutSection(about: profile.about),
                const SizedBox(height: 16),
                // 6. CV Section
                _CVSection(),
                const SizedBox(height: 16),
                // 7. Experience Section
                _ExperienceSection(experiences: profile.experiences),
                const SizedBox(height: 16),
                // 8. Recommendations Section
                _RecommendationsSection(
                  recommendations: profile.recommendations,
                ),
                const SizedBox(height: 20),
                // Debug: Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFE74C3C),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _showLogoutDialog(context);
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
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // TODO: Call auth logout here
              // For now, just navigate to splash
              if (context.mounted) {
                context.go('/splash');
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Profile Card Widget
class _ProfileCard extends StatelessWidget {
  final ProfileData profile;

  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
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
          // Profile header with photo and info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile photo
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
                    profile.name.split(' ').map((e) => e[0]).join(),
                    style: AppTextStyles.bold16.copyWith(
                      color: AppColors.blueNormal,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: AppTextStyles.bold16.copyWith(
                        color: const Color(0xFF173568),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.faculty,
                      style: AppTextStyles.regular12.copyWith(
                        color: const Color(0xFF788397),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${profile.program} · ${profile.year}',
                      style: AppTextStyles.regular12.copyWith(
                        color: const Color(0xFF788397),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Status
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.greenNormal,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          profile.status,
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.greenNormal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Connections panel
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
                  '${profile.connections}',
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
          const SizedBox(height: 16),
          // Contact info
          _ContactInfo(
            icon: Icons.location_on_outlined,
            text: profile.location,
            color: const Color(0xFF788397),
          ),
          const SizedBox(height: 8),
          _ContactInfo(
            icon: Icons.link,
            text: profile.linkedin,
            color: AppColors.blueNormal,
          ),
          const SizedBox(height: 8),
          _ContactInfo(
            icon: Icons.phone_outlined,
            text: profile.whatsapp,
            color: AppColors.greenNormal,
          ),
          const SizedBox(height: 8),
          _ContactInfo(
            icon: Icons.camera_alt_outlined,
            text: profile.instagram,
            color: const Color(0xFFF04491),
          ),
        ],
      ),
    );
  }
}

// Contact Info Row
class _ContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _ContactInfo({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.regular12.copyWith(color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Skills Section
class _SkillsSection extends StatelessWidget {
  final List<String> skills;

  const _SkillsSection({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            // Header
            Row(
              children: [
                Icon(
                  Icons.star_outline,
                  size: 16,
                  color: const Color(0xFFFFA500),
                ),
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
            // Chips
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
    );
  }
}

// About Section
class _AboutSection extends StatelessWidget {
  final String about;

  const _AboutSection({required this.about});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            Text(
              'Tentang Saya',
              style: AppTextStyles.semibold13.copyWith(
                color: const Color(0xFF173568),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              about,
              style: AppTextStyles.regular12.copyWith(
                color: const Color(0xFF788397),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CV Section
class _CVSection extends StatelessWidget {
  const _CVSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          // TODO: Handle CV download
        },
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
          child: Row(
            children: [
              // PDF Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 24,
                        color: const Color(0xFFFF4E58),
                      ),
                      Text(
                        'PDF',
                        style: AppTextStyles.bold12.copyWith(
                          color: const Color(0xFFFF4E58),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // File name
              Expanded(
                child: Text(
                  'CV_Fikri ramadhan',
                  style: AppTextStyles.bold12.copyWith(
                    color: const Color(0xFF173568),
                  ),
                ),
              ),
              // Chevron
              Icon(
                Icons.chevron_right,
                size: 20,
                color: const Color(0xFFE8EBF0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Experience Section
class _ExperienceSection extends StatelessWidget {
  final List<Experience> experiences;

  const _ExperienceSection({required this.experiences});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            // Header
            Row(
              children: [
                Icon(Icons.work_outline, size: 16, color: AppColors.blueNormal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pengalaman',
                    style: AppTextStyles.semibold13.copyWith(
                      color: const Color(0xFF173568),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blueLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFBBD0FF),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '+ Tambah',
                    style: AppTextStyles.regular11.copyWith(
                      color: AppColors.blueNormal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Timeline
            ...experiences.asMap().entries.map((entry) {
              int index = entry.key;
              Experience exp = entry.value;
              bool isLast = index == experiences.length - 1;

              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon column
                      SizedBox(
                        width: 40,
                        child: Column(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: exp.iconColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.emoji_events_outlined,
                                size: 18,
                                color: exp.iconColor,
                              ),
                            ),
                            if (!isLast)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: SizedBox(
                                  height: 40,
                                  child: VerticalDivider(
                                    color: const Color(0xFFE8EBF0),
                                    thickness: 1,
                                    width: 1,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    exp.title,
                                    style: AppTextStyles.semibold11.copyWith(
                                      color: const Color(0xFF173568),
                                    ),
                                  ),
                                ),
                                if (exp.status != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8FDF2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      exp.status!,
                                      style: AppTextStyles.regular10.copyWith(
                                        color: AppColors.greenNormal,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              exp.organization,
                              style: AppTextStyles.regular11.copyWith(
                                color: AppColors.blueNormal,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              exp.period,
                              style: AppTextStyles.regular10.copyWith(
                                color: const Color(0xFFA4ADBC),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              exp.description,
                              style: AppTextStyles.regular11.copyWith(
                                color: const Color(0xFF788397),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!isLast) const SizedBox(height: 12),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// Recommendations Section
class _RecommendationsSection extends StatelessWidget {
  final List<Recommendation> recommendations;

  const _RecommendationsSection({required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            // Header
            Row(
              children: [
                Icon(Icons.format_quote, size: 16, color: AppColors.blueNormal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rekomendasi',
                    style: AppTextStyles.semibold13.copyWith(
                      color: const Color(0xFF173568),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blueLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${recommendations.length}',
                    style: AppTextStyles.semibold10.copyWith(
                      color: AppColors.blueNormal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Recommendations
            ...recommendations.asMap().entries.map((entry) {
              int index = entry.key;
              Recommendation rec = entry.value;

              return Column(
                children: [
                  // Recommender info
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.blueGradientStart,
                              AppColors.blueGradientEnd,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            rec.initials,
                            style: AppTextStyles.bold12.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rec.name,
                              style: AppTextStyles.semibold12.copyWith(
                                color: const Color(0xFF173568),
                              ),
                            ),
                            Text(
                              rec.position,
                              style: AppTextStyles.regular10.copyWith(
                                color: const Color(0xFF788397),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blueLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          rec.relation,
                          style: AppTextStyles.regular10.copyWith(
                            color: AppColors.blueNormal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Testimonial
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F8FE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE8EBF0),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            rec.testimonial,
                            style: AppTextStyles.regular11.copyWith(
                              color: const Color(0xFF788397),
                              height: 1.5,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.blueNormal,
                            ),
                            child: Icon(
                              Icons.format_quote,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index != recommendations.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: const Color(0xFFE8EBF0), height: 1),
                    ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
