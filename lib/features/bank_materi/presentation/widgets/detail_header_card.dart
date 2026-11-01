import 'package:flutter/material.dart';
import 'package:raih/features/bank_materi/data/bank_materi_model.dart';

class DetailHeaderCard extends StatelessWidget {
  final DocumentDetailModel document;

  const DetailHeaderCard({super.key, required this.document});

  // Helper untuk warna berdasarkan tipe file
  Color _getFileColor() {
    switch (document.fileType) {
      case 'PDF':
        return const Color(0xFFEF4444); // Red
      case 'DOC':
        return const Color(0xFF3B82F6); // Blue
      case 'PPT':
        return const Color(0xFFF97316); // Orange
      default:
        return const Color(0xFF6B7280); // Grey
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileColor = _getFileColor();

    return Column(
      children: [
        // Kartu Utama
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ikon File Dinamis
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: fileColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description_outlined, color: fileColor),
                    const SizedBox(height: 2),
                    Text(
                      document.fileType,
                      style: TextStyle(
                        color: fileColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Info Judul
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundColor: const Color(0xFF3B82F6),
                          child: Text(
                            document.authorInitials,
                            style: const TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          document.authorName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            document.category,
                            style: const TextStyle(
                              color: Color(0xFF3B82F6),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.download_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${document.downloadCount}   ${document.fileSizeMB} MB',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Kartu Statistik (4 Kolom)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                Icons.calendar_today_outlined,
                'Diunggah',
                document.uploadDate,
              ),
              _buildStatItem(
                Icons.download_outlined,
                'Unduhan',
                '${(document.downloadCount / 1000).toStringAsFixed(1)}k',
              ),
              _buildStatItem(
                Icons.visibility_outlined,
                'Halaman',
                '${document.totalPages} hal',
              ),
              _buildStatItem(
                Icons.star_border,
                'Rating',
                document.rating.toString(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF60A5FA), size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}
