import 'package:flutter/material.dart';

class MateriView extends StatelessWidget {
  const MateriView({super.key});

  static const List<Map<String, dynamic>> _sections = [
    {
      'topic': 'Karya Tulis Ilmiah',
      'color': 0xFF6C72FF,
      'icon': Icons.description_outlined,
      'items': [
        'Struktur KTI yang Benar',
        'Cara Mencari Referensi Ilmiah',
        'Template KTI Nasional',
      ],
    },
    {
      'topic': 'Business Plan',
      'color': 0xFFF39C12,
      'icon': Icons.bar_chart_outlined,
      'items': [
        'Business Model Canvas',
        'Cara Membuat Pitch Deck',
        'Contoh BP Juara Nasional',
      ],
    },
    {
      'topic': 'Hackathon',
      'color': 0xFF9B59B6,
      'icon': Icons.code_outlined,
      'items': [
        'Tips Buat MVP dalam 24 Jam',
        'Tech Stack Populer Hackathon',
        'Strategi Presentasi Produk',
      ],
    },
    {
      'topic': 'UI/UX Design',
      'color': 0xFF1ABC9C,
      'icon': Icons.palette_outlined,
      'items': [
        'Prinsip Dasar UI/UX',
        'Figma untuk Pemula',
        'Cara Buat Prototype Interaktif',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Materi & Panduan',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E))),
                    SizedBox(height: 4),
                    Text('Pelajari strategi untuk menang kompetisi',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFF9094A6))),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, si) {
                    final section = _sections[si];
                    final color = Color(section['color'] as int);
                    final items = section['items'] as List<String>;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Section header
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            child: Row(
                              children: [
                                Icon(section['icon'] as IconData,
                                    color: color, size: 22),
                                const SizedBox(width: 10),
                                Text(section['topic'] as String,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: color)),
                              ],
                            ),
                          ),
                          // Items
                          ...items.map(
                            (item) => ListTile(
                              dense: true,
                              leading: Icon(Icons.play_circle_outline,
                                  color: color, size: 20),
                              title: Text(item,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF1A1A2E))),
                              trailing: const Icon(Icons.download_outlined,
                                  size: 18, color: Color(0xFF9094A6)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: _sections.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
