import 'package:flutter/material.dart';

enum EventCategory { lomba, beasiswa }

class EventModel {
  final String id;
  final String title;
  final EventCategory category;
  final String subCategory; // e.g. "Hackathon", "Essai", "UI/UX Design", etc.
  final String organizer;
  final String location;
  final DateTime deadline;
  final String? emoji; // Current dummy icon representation
  final String? imageUrl; // Future image asset or network path
  final Color baseColor; // Background color for the image section of the card
  final String? description;
  final String? registrationUrl;

  // Detail-specific fields (optional for reusability)
  final DateTime? registrationOpen;
  final String? benefit; // e.g., "Rp. 50.000.000" or "FULL tuition + Living allowance"
  final String? teamSize; // e.g., "3-5 Orang" (for Lomba)
  final List<String>? requirements; // (for Beasiswa)
  final List<Map<String, String>>? benefitDetails; // [{"label": "Dana Hidup", "value": "Rp 1,4 Jt/bln"}] (for Beasiswa)
  final List<Map<String, String>>? selectionStages; // [{"stage": "Pendaftaran Online", "date": "1 Feb 2026 - 15 Feb 2026"}] (for Beasiswa)

  const EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.subCategory,
    required this.organizer,
    required this.location,
    required this.deadline,
    this.emoji,
    this.imageUrl,
    required this.baseColor,
    this.description,
    this.registrationUrl,
    this.registrationOpen,
    this.benefit,
    this.teamSize,
    this.requirements,
    this.benefitDetails,
    this.selectionStages,
  });

  EventModel copyWith({
    String? id,
    String? title,
    EventCategory? category,
    String? subCategory,
    String? organizer,
    String? location,
    DateTime? deadline,
    String? emoji,
    String? imageUrl,
    Color? baseColor,
    String? description,
    String? registrationUrl,
    DateTime? registrationOpen,
    String? benefit,
    String? teamSize,
    List<String>? requirements,
    List<Map<String, String>>? benefitDetails,
    List<Map<String, String>>? selectionStages,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      organizer: organizer ?? this.organizer,
      location: location ?? this.location,
      deadline: deadline ?? this.deadline,
      emoji: emoji ?? this.emoji,
      imageUrl: imageUrl ?? this.imageUrl,
      baseColor: baseColor ?? this.baseColor,
      description: description ?? this.description,
      registrationUrl: registrationUrl ?? this.registrationUrl,
      registrationOpen: registrationOpen ?? this.registrationOpen,
      benefit: benefit ?? this.benefit,
      teamSize: teamSize ?? this.teamSize,
      requirements: requirements ?? this.requirements,
      benefitDetails: benefitDetails ?? this.benefitDetails,
      selectionStages: selectionStages ?? this.selectionStages,
    );
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] as String? ?? '',
      category: (map['category'] as String?)?.toLowerCase() == 'beasiswa'
          ? EventCategory.beasiswa
          : EventCategory.lomba,
      subCategory: map['sub_category'] as String? ?? '',
      organizer: map['organizer'] as String? ?? '',
      location: map['location'] as String? ?? '',
      deadline: map['deadline'] != null
          ? DateTime.tryParse(map['deadline'].toString()) ?? DateTime.now()
          : DateTime.now(),
      emoji: map['emoji'] as String?,
      imageUrl: map['image_url'] as String?,
      baseColor: map['base_color'] != null
          ? Color(int.tryParse(map['base_color'].toString()) ?? 0xFF6C72FF)
          : const Color(0xFF6C72FF),
      description: map['description'] as String?,
      registrationUrl: map['registration_url'] as String?,
      registrationOpen: map['registration_open'] != null
          ? DateTime.tryParse(map['registration_open'].toString())
          : null,
      benefit: map['benefit'] as String?,
      teamSize: map['team_size'] as String?,
      requirements: (map['requirements'] as List?)?.map((e) => e.toString()).toList(),
      benefitDetails: (map['benefit_details'] as List?)
          ?.map((e) => Map<String, String>.from(e as Map))
          .toList(),
      selectionStages: (map['selection_stages'] as List?)
          ?.map((e) => Map<String, String>.from(e as Map))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'sub_category': subCategory,
      'organizer': organizer,
      'location': location,
      'deadline': deadline.toIso8601String(),
      'emoji': emoji,
      'image_url': imageUrl,
      'base_color': baseColor.toARGB32(),
      'description': description,
      'registration_url': registrationUrl,
      'registration_open': registrationOpen?.toIso8601String(),
      'benefit': benefit,
      'team_size': teamSize,
      'requirements': requirements,
      'benefit_details': benefitDetails,
      'selection_stages': selectionStages,
    };
  }
}
