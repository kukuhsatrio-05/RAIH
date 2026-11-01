import 'package:flutter/material.dart';

class DetailRatingSection extends StatelessWidget {
  final double averageRating;
  final int userRating;
  final Function(int) onRatingChanged;

  const DetailRatingSection({
    super.key,
    required this.averageRating,
    required this.userRating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Judul Section Rating
          const Row(
            children: [
              Icon(Icons.star, color: Color(0xFFF59E0B), size: 20),
              SizedBox(width: 8),
              Text(
                'Rating',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Kotak Abu-abu Statistik Rating
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA), // Warna abu-abu terang
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Bagian Kiri (Angka 4.9 & Bintang)
                Column(
                  children: [
                    Text(
                      averageRating.toString(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6), // Warna Biru
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return const Icon(
                          Icons.star,
                          color: Color(0xFFF59E0B),
                          size: 14,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(width: 24),

                // Bagian Kanan (Progress Bar 5 sampai 1)
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(5, 0.9), // Asumsi 90% vote 5 bintang
                      _buildRatingBar(4, 0.1), // Asumsi 10% vote 4 bintang
                      _buildRatingBar(3, 0.0),
                      _buildRatingBar(2, 0.0),
                      _buildRatingBar(1, 0.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. Kotak Outline Beri Penilaianmu
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Beri penilaianmu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    int starValue = index + 1;
                    bool isSelected = starValue <= userRating;
                    return GestureDetector(
                      onTap: () => onRatingChanged(starValue),
                      child: Icon(
                        isSelected ? Icons.star : Icons.star_border,
                        color: const Color(0xFFF59E0B), // Kuning Orange
                        size: 36,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk membuat baris progress rating
  Widget _buildRatingBar(int star, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Text(
            star.toString(),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 6,
                backgroundColor:
                    Colors.grey.shade300, // Warna abu background bar
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFF59E0B),
                ), // Warna isi bar
              ),
            ),
          ),
        ],
      ),
    );
  }
}
