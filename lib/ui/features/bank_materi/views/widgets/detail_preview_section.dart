import 'package:flutter/material.dart';
import 'detail_section_card.dart';

class DetailPreviewSection extends StatelessWidget {
  final String fileType;
  final double fileSizeMB;
  final int totalPages;

  const DetailPreviewSection({
    super.key,
    required this.fileType,
    required this.fileSizeMB,
    required this.totalPages,
  });

  Color _getFileColor() {
    switch (fileType) {
      case 'PDF':
        return const Color(0xFFEF4444);
      case 'DOC':
        return const Color(0xFF3B82F6);
      case 'PPT':
        return const Color(0xFFF97316);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileColor = _getFileColor();

    return DetailSectionCard(
      child: Column(
        children: [
          const Center(
            child: Text(
              'Pratinjau Dokumen',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: fileColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.description_outlined, color: fileColor),
                ),
                const SizedBox(height: 16),
                Text(
                  '$fileType • $fileSizeMB MB • $totalPages halaman',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pratinjau tersedia setelah akses',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
