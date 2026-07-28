import 'package:flutter/material.dart';

class MadingView extends StatelessWidget {
  const MadingView({super.key});

  static const List<Map<String, String>> _articles = [
    {
      'title': 'Tips Lolos Beasiswa LPDP 2026',
      'author': 'Admin RAIH',
      'date': '20 Jul 2026',
      'views': '1.2k',
      'tag': 'Beasiswa',
      'color': '0xFF4A5CFC',
    },
    {
      'title': 'Cara Membuat Proposal KTI yang Menarik',
      'author': 'Tim Redaksi',
      'date': '18 Jul 2026',
      'views': '850',
      'tag': 'Karya Tulis',
      'color': '0xFF2ECC71',
    },
    {
      'title': 'Panduan Ikut Hackathon untuk Pemula',
      'author': 'Kontributor',
      'date': '15 Jul 2026',
      'views': '3.4k',
      'tag': 'Hackathon',
      'color': '0xFF9B59B6',
    },
    {
      'title': 'Strategi Menang Business Plan Competition',
      'author': 'Admin RAIH',
      'date': '10 Jul 2026',
      'views': '2.1k',
      'tag': 'Business',
      'color': '0xFFF39C12',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Mading Digital',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E))),
                  SizedBox(height: 4),
                  Text('Artikel & info seputar kompetisi',
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF9094A6))),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                itemCount: _articles.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final a = _articles[i];
                  final color =
                      Color(int.parse(a['color']!));
                  return Container(
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
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.article_outlined,
                            color: color, size: 24),
                      ),
                      title: Text(
                        a['title']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(a['tag']!,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: color)),
                            ),
                            const SizedBox(width: 8),
                            Text('${a['date']} · ${a['views']} views',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF9094A6))),
                          ],
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right,
                          color: Color(0xFF9094A6)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
