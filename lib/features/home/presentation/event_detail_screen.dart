import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:raih/features/home/data/home_model.dart';
import 'package:raih/features/home/presentation/home_controller.dart';

class EventDetailView extends ConsumerWidget {
  final String eventId;

  const EventDetailView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventProvider);
    final event = state.allEvents.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found'),
    );

    final isLomba = event.category == EventCategory.lomba;
    final categoryLabel = isLomba ? 'Lomba' : 'Beasiswa';
    final registrationOpenStr = event.registrationOpen != null
        ? DateFormat('d MMMM yyyy', 'id').format(event.registrationOpen!)
        : 'TBA';
    final deadlineStr = DateFormat('d MMMM yyyy', 'id').format(event.deadline);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Panel with Overlapping Info Card ──────────────────────
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Top colored background panel
                  Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: event.baseColor,
                      gradient: LinearGradient(
                        colors: [
                          event.baseColor,
                          Color.lerp(event.baseColor, Colors.black, 0.15)!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),

                  // Decorative circles
                  Positioned(
                    right: -30,
                    bottom: 10,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    top: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),

                  // Back button
                  Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // Category badge (bottom-left of image panel)
                  Positioned(
                    bottom: 50,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        categoryLabel,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Emoji / Image in the center
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: event.imageUrl != null
                          ? Image.asset(
                              event.imageUrl!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Text(
                                event.emoji ?? '🏆',
                                style: const TextStyle(fontSize: 60),
                              ),
                            )
                          : Text(
                              event.emoji ?? '🏆',
                              style: const TextStyle(fontSize: 60),
                            ),
                    ),
                  ),

                  // Main overlapping info card
                  Positioned(
                    bottom: -40,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E),
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.business_outlined,
                                  size: 14, color: Color(0xFF9094A6)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  event.organizer,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9094A6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 14, color: Color(0xFF9094A6)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  event.location,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9094A6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 56),

              // ── Main Content Column ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hadiah / Benefit Banner
                    if (event.benefit != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F4EA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: const Color(0xFF2ECC71), width: 1.2),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF2ECC71),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.emoji_events_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Hadiah / Benefit',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2ECC71),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    event.benefit!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF27AE60),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Registration open and Batas akhir row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: const Color(0xFFE8E9F0), width: 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF0FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today_outlined,
                                    color: Color(0xFF4A5CFC),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Pendaftaran buka',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF9094A6),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        registrationOpenStr,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF1A1A2E),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF0F0),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: const Color(0xFFF5B5B5), width: 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFCE8E6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.access_time_outlined,
                                    color: Color(0xFFD32F2F),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Batas Akhir',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFFD32F2F),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        deadlineStr,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFFD32F2F),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description card
                    if (event.description != null) ...[
                      _CollapsibleCard(
                        title: 'Deskripsi',
                        content: event.description!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Info Tim (Lomba only)
                    if (isLomba && event.teamSize != null) ...[
                      _TeamInfoSection(teamSize: event.teamSize!),
                      const SizedBox(height: 16),
                    ],

                    // Beasiswa specific sections
                    if (!isLomba) ...[
                      // Requirements
                      if (event.requirements != null) ...[
                        _RequirementsCard(requirements: event.requirements!),
                        const SizedBox(height: 16),
                      ],

                      // Benefit details
                      if (event.benefitDetails != null) ...[
                        _BenefitDetailsSection(details: event.benefitDetails!),
                        const SizedBox(height: 16),
                      ],

                      // Selection stages timeline
                      if (event.selectionStages != null) ...[
                        _TimelineCard(stages: event.selectionStages!),
                        const SizedBox(height: 16),
                      ],
                    ],

                    // Action Button: Daftar Sekarang
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A5CFC),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Collapsible description card
// ─────────────────────────────────────────────────────────────────────────────
class _CollapsibleCard extends StatefulWidget {
  final String title;
  final String content;

  const _CollapsibleCard({required this.title, required this.content});

  @override
  State<_CollapsibleCard> createState() => _CollapsibleCardState();
}

class _CollapsibleCardState extends State<_CollapsibleCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.content,
            maxLines: _isExpanded ? null : 3,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B6F82),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isExpanded ? 'Sembunyikan' : 'Selengkapnya',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A5CFC),
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16,
                  color: const Color(0xFF4A5CFC),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Team Info Section (Lomba specific)
// ─────────────────────────────────────────────────────────────────────────────
class _TeamInfoSection extends StatelessWidget {
  final String teamSize;

  const _TeamInfoSection({required this.teamSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Info Tim',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _TeamChip(
                  teamSize: teamSize,
                  iconColor: const Color(0xFF4A5CFC),
                  bgColor: const Color(0xFFEEF0FF),
                  labelColor: const Color(0xFF4A5CFC),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TeamChip(
                  teamSize: teamSize,
                  iconColor: const Color(0xFF2ECC71),
                  bgColor: const Color(0xFFE6F4EA),
                  labelColor: const Color(0xFF2ECC71),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeamChip extends StatelessWidget {
  final String teamSize;
  final Color iconColor;
  final Color bgColor;
  final Color labelColor;

  const _TeamChip({
    required this.teamSize,
    required this.iconColor,
    required this.bgColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.people_alt_outlined, color: iconColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ukuran Tim',
                  style: TextStyle(
                    fontSize: 9,
                    color: labelColor.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  teamSize,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: labelColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Requirements Card (Beasiswa specific)
// ─────────────────────────────────────────────────────────────────────────────
class _RequirementsCard extends StatelessWidget {
  final List<String> requirements;

  const _RequirementsCard({required this.requirements});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.check_circle_outline,
                  color: Color(0xFF4A5CFC), size: 18),
              SizedBox(width: 8),
              Text(
                'Persyaratan Umum',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...requirements.map(
            (req) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF4A5CFC),
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      req,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4E586E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Benefit Details Section (Beasiswa specific)
// ─────────────────────────────────────────────────────────────────────────────
class _BenefitDetailsSection extends StatelessWidget {
  final List<Map<String, String>> details;

  const _BenefitDetailsSection({required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.school_outlined, color: Color(0xFF4A5CFC), size: 18),
              SizedBox(width: 8),
              Text(
                'Rincian Benefit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(details.length, (i) {
              final d = details[i];
              Color color = const Color(0xFF4A5CFC);
              Color bg = const Color(0xFFEEF0FF);
              if (i == 1) {
                color = const Color(0xFF2ECC71);
                bg = const Color(0xFFE6F4EA);
              } else if (i == 2) {
                color = const Color(0xFFF39C12);
                bg = const Color(0xFFFFF9E6);
              }

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < details.length - 1 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        d['label']!,
                        style: TextStyle(
                          fontSize: 9,
                          color: color.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        d['value']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Timeline / Selection Stages Card (Beasiswa specific)
// ─────────────────────────────────────────────────────────────────────────────
class _TimelineCard extends StatelessWidget {
  final List<Map<String, String>> stages;

  const _TimelineCard({required this.stages});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_month_outlined,
                  color: Color(0xFF4A5CFC), size: 18),
              SizedBox(width: 8),
              Text(
                'Tahapan Seleksi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(stages.length, (index) {
            final s = stages[index];
            final isActive = index == 0; // Highlight the first stage as active

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bullet + Line column
                Column(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? const Color(0xFF4A5CFC) : Colors.white,
                        border: Border.all(
                          color: isActive
                              ? const Color(0xFF4A5CFC)
                              : const Color(0xFFB0B3C6),
                          width: 2,
                        ),
                      ),
                      child: isActive
                          ? const Center(
                              child: Icon(Icons.circle,
                                  color: Colors.white, size: 4),
                            )
                          : null,
                    ),
                    if (index < stages.length - 1)
                      Container(
                        width: 2,
                        height: 38,
                        color: const Color(0xFFE8E9F0),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Content column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s['stage']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isActive ? FontWeight.w800 : FontWeight.w600,
                          color: isActive
                              ? const Color(0xFF1A1A2E)
                              : const Color(0xFF6B6F82),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s['date']!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9094A6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

