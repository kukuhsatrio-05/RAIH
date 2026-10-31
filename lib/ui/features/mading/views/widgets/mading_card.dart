import 'package:flutter/material.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
import 'package:raih/ui/features/mading/models/mading_models.dart';

class MadingCard extends StatelessWidget {
  final MadingModel item;
  final VoidCallback? onTap;
  const MadingCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteNormal,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackNormal.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Banner + Badge Kategori Atas
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    item.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      height: 120,
                      color: AppColors.blueLight,
                      child: const Icon(Icons.image, color: AppColors.blueNormal),
                    ),
                  ),
                ),
                // Badge Kategori Utama (Lomba / Beasiswa)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.whiteNormal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blueNormal,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Area Konten Teks
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pill Sub-Kategori
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blueLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.subCategory,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.blueNormal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Judul Lomba / Beasiswa (Memenuhi space kotak)
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.semibold14.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: AppColors.blackNormal,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Penyelenggara & Lokasi
                    Text(
                      item.organizer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.whiteDarker,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 10,
                          color: AppColors.whiteDarker,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            item.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.whiteDarker,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Deskripsi: mengisi sisa ruang di antara lokasi dan tombol deadline
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          const double fontSize = 10;
                          const double lineHeight = 1.4;

                          // Hitung berapa baris yang muat di sisa ruang
                          final maxLines =
                              (constraints.maxHeight / (fontSize * lineHeight))
                                  .floor();

                          if (item.description.isEmpty || maxLines < 1) {
                            return const SizedBox.shrink();
                          }

                          return Text(
                            item.description,
                            maxLines: maxLines,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: fontSize,
                              height: lineHeight,
                              color: AppColors.whiteDarker,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Badge Deadline Responsif
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blueNormal,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Deadline: ${item.deadline}',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.whiteNormal,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
