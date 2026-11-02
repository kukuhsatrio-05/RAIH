import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
import 'package:raih/features/mading/presentation/mading_controller.dart';
import 'package:raih/features/mading/presentation/widgets/benefit_card.dart';
import 'package:raih/features/mading/presentation/widgets/description_card.dart';
import 'package:raih/features/mading/presentation/widgets/main_info_card.dart';
import 'package:raih/features/mading/presentation/widgets/schedule_card.dart';
import 'package:raih/features/mading/presentation/widgets/team_info_card.dart';

class MadingDetailView extends StatefulWidget {
  final String postId;

  const MadingDetailView({super.key, required this.postId});

  @override
  State<MadingDetailView> createState() => _MadingDetailViewState();
}

class _MadingDetailViewState extends State<MadingDetailView> {
  late MadingDetailViewModel viewModel;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    viewModel = MadingDetailViewModel();
    viewModel.fetchMadingDetail(widget.postId);

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 230.0;
    final double topSafeArea = MediaQuery.of(context).padding.top;
    final double collapsedBarHeight = topSafeArea + kToolbarHeight;

    // Perhitungan progress animasi scroll
    final double scrollProgress = (_scrollOffset / 140.0).clamp(0.0, 1.0);
    final double bgOpacity = (1.0 - scrollProgress).clamp(0.0, 1.0);
    final double blurSigma = scrollProgress * 10.0;

    // Animasi fade in untuk Collapsed AppBar saat di-scroll
    final double topBarOpacity = ((_scrollOffset - 60.0) / 70.0).clamp(0.0, 1.0);

    // Parallax offset pada header gambar
    final double parallaxOffset = -_scrollOffset * 0.35;

    final isCollapsed = topBarOpacity > 0.5;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isCollapsed
          ? SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            )
          : SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: AnimatedBuilder(
          animation: viewModel,
          builder: (context, _) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.blueNormal),
              );
            }

            final mading = viewModel.mading!;

            return Stack(
              children: [
                // 1. Header Background (Gradient + Asset Image + Lingkaran Dekoratif + Parallax)
                Positioned(
                  top: parallaxOffset,
                  left: 0,
                  right: 0,
                  height: headerHeight,
                  child: Opacity(
                    opacity: bgOpacity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background Gradient Biru (Sesuai AppColors)
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.blueGradientStart,
                                AppColors.blueNormal,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),

                        // Lingkaran Dekoratif Atas Kanan
                        Positioned(
                          top: -40,
                          right: -30,
                          child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.whiteNormal.withValues(alpha: 0.1),
                            ),
                          ),
                        ),

                        // Lingkaran Dekoratif Bawah Kiri
                        Positioned(
                          bottom: 20,
                          left: -30,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.whiteNormal.withValues(alpha: 0.08),
                            ),
                          ),
                        ),

                        // Gambar Ilustrasi Mading (Lampu & Balon Avatar dari Asset)
                        if (mading.imageUrl != null)
                          mading.imageUrl!.startsWith('assets/')
                              ? Image.asset(
                                  mading.imageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  mading.imageUrl!,
                                  fit: BoxFit.cover,
                                ),

                        // Efek Blur saat mulai di-scroll
                        if (blurSigma > 0)
                          BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: blurSigma,
                              sigmaY: blurSigma,
                            ),
                            child: Container(color: Colors.transparent),
                          ),
                      ],
                    ),
                  ),
                ),

                // 2. Main Scrollable Content
                SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Jarak agar konten pertama mulai tepat melayang di batas header
                      const SizedBox(height: headerHeight - 40),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tag Kategori ("Lomba") mengambang di atas card
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blueNormal,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.blueNormal.withValues(
                                      alpha: 0.35,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                mading.categoryTag,
                                style: AppTextStyles.semibold14.copyWith(
                                  color: AppColors.whiteNormal,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Card Utama (Judul, Penyelenggara, Lokasi)
                            MainInfoCard(
                              title: mading.title,
                              organizer: mading.organizer,
                              location: mading.location,
                            ),
                            const SizedBox(height: 14),

                            // Card Hadiah / Benefit
                            BenefitCard(benefitText: mading.benefit),
                            const SizedBox(height: 14),

                            // Card Jadwal (Pendaftaran buka & Batas Akhir)
                            ScheduleSection(
                              openDate: mading.openDate,
                              endDate: mading.endDate,
                            ),
                            const SizedBox(height: 14),

                            // Card Deskripsi (Dengan tombol "Selengkapnya")
                            DescriptionCard(description: mading.description),
                            const SizedBox(height: 14),

                            // Card Info Tim
                            TeamInfoCard(teamSize: mading.teamSize),

                            // Spasi ekstra agar konten terbawah tidak tertutup tombol sticky
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Collapsed Sticky AppBar (Fade in saat di-scroll ke bawah)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: collapsedBarHeight,
                  child: IgnorePointer(
                    ignoring: topBarOpacity < 0.4,
                    child: Opacity(
                      opacity: topBarOpacity,
                      child: Container(
                        padding: EdgeInsets.only(top: topSafeArea),
                        decoration: BoxDecoration(
                          color: AppColors.whiteNormal,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackNormal.withValues(
                                alpha: 0.08,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Back button di collapsed AppBar
                            Opacity(
                              opacity: topBarOpacity,
                              child: IconButton(
                                onPressed: () => context.go('/mading'),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.blackNormal,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                mading.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bold16.copyWith(
                                  color: AppColors.blackNormal,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // 4. Tombol Back Melayang (Berpindah warna saat AppBar muncul)
                Positioned(
                  top: topSafeArea + 8,
                  left: 16,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.go('/mading'),
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isCollapsed
                              ? AppColors.whiteNormal
                              : AppColors.blackNormal.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          border: isCollapsed
                              ? Border.all(color: AppColors.blackLight, width: 1)
                              : null,
                          boxShadow: isCollapsed
                              ? [
                                  BoxShadow(
                                    color: AppColors.blackNormal.withValues(
                                      alpha: 0.05,
                                    ),
                                    blurRadius: 4,
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: isCollapsed
                              ? AppColors.blackNormal
                              : AppColors.whiteNormal,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                // 5. Tombol "Daftar Sekarang" Sticky di Bagian Bawah
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 12,
                      bottom: MediaQuery.of(context).padding.bottom > 0
                          ? MediaQuery.of(context).padding.bottom + 8
                          : 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.whiteNormal.withValues(alpha: 0.95),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackNormal.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blueNormal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // Aksi pendaftaran lomba
                        },
                        child: Text(
                          "Daftar Sekarang",
                          style: AppTextStyles.bold16.copyWith(
                            color: AppColors.whiteNormal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

