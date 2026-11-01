import 'package:flutter/material.dart';

typedef ProfileScreen = ProfileView;

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              // Header / avatar section
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A5CFC), Color(0xFF7283FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor:
                          Colors.white.withValues(alpha: 0.3),
                      child: const Text('AS',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    ),
                    const SizedBox(height: 12),
                    const Text('Ahmad Satrio',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    const Text('Mahasiswa · Universitas Indonesia',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StatChip(label: 'Disimpan', value: '12'),
                        const SizedBox(width: 24),
                        _StatChip(label: 'Diunggah', value: '4'),
                        const SizedBox(width: 24),
                        _StatChip(label: 'Terpilih', value: '2'),
                      ],
                    ),
                  ],
                ),
              ),

              // Settings menu
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Column(
                    children: [
                      _MenuTile(
                        icon: Icons.person_outline,
                        label: 'Edit Profil',
                        color: const Color(0xFF4A5CFC),
                        onTap: () {},
                      ),
                      const Divider(height: 1, indent: 56),
                      _MenuTile(
                        icon: Icons.bookmark_outline,
                        label: 'Event Tersimpan',
                        color: const Color(0xFF2ECC71),
                        onTap: () {},
                      ),
                      const Divider(height: 1, indent: 56),
                      _MenuTile(
                        icon: Icons.notifications_outlined,
                        label: 'Notifikasi',
                        color: const Color(0xFFF39C12),
                        onTap: () {},
                      ),
                      const Divider(height: 1, indent: 56),
                      _MenuTile(
                        icon: Icons.help_outline,
                        label: 'Bantuan',
                        color: const Color(0xFF9B59B6),
                        onTap: () {},
                      ),
                      const Divider(height: 1, indent: 56),
                      _MenuTile(
                        icon: Icons.logout,
                        label: 'Keluar',
                        color: const Color(0xFFE74C3C),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.white70)),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MenuTile(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E))),
      trailing: const Icon(Icons.chevron_right,
          color: Color(0xFF9094A6), size: 20),
    );
  }
}


