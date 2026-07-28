import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:raih/model/event_model.dart';

/// Reusable card widget that renders an [EventModel].
/// To add an image in the future, set [EventModel.imageUrl]; the card will
/// automatically prefer the image over the emoji fallback.
class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLomba = event.category == EventCategory.lomba;
    final categoryLabel = isLomba ? 'Lomba' : 'Beasiswa';
    final deadlineStr =
        'Deadline: ${DateFormat('d MMMM yyyy', 'id').format(event.deadline)}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image panel ──────────────────────────────────────────────
            _CardImagePanel(
              event: event,
              categoryLabel: categoryLabel,
            ),
            // ── Content ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Organizer
                  Text(
                    event.organizer,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9094A6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 11,
                        color: Color(0xFF9094A6),
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          event.location,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9094A6),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Deadline button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10367D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      deadlineStr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Image panel (top section of the card)
// ─────────────────────────────────────────────────────────────────────────────
class _CardImagePanel extends StatelessWidget {
  final EventModel event;
  final String categoryLabel;

  const _CardImagePanel({
    required this.event,
    required this.categoryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Solid base color background
          Container(color: event.baseColor),

          // Decorative circles (bottom-right)
          Positioned(
            right: -24,
            bottom: -24,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: -28,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.09),
              ),
            ),
          ),

          // Sub-category badge — bottom-left of image panel
          Positioned(
            bottom: 10,
            left: 10,
            child: _Badge(
              label: event.subCategory,
              bgColor: Colors.white.withValues(alpha: 0.22),
              textColor: Colors.white,
              borderColor: Colors.white.withValues(alpha: 0.4),
            ),
          ),

          // Category badge — top-left
          Positioned(
            top: 10,
            left: 10,
            child: _Badge(
              label: categoryLabel,
              bgColor: Colors.white,
              textColor: event.baseColor,
              borderColor: Colors.transparent,
            ),
          ),

          // Emoji or image — centered
          Center(
            child: event.imageUrl != null
                ? Image.asset(
                    event.imageUrl!,
                    width: 72,
                    height: 72,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Text(
                          event.emoji ?? '🏆',
                          style: const TextStyle(fontSize: 52),
                        ),
                  )
                : Text(
                    event.emoji ?? '🏆',
                    style: const TextStyle(fontSize: 52),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pill badge — reusable inside the image panel
// ─────────────────────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;

  const _Badge({
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
