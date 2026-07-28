import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/model/event_model.dart';
import 'package:raih/ui/features/home/providers/event_provider.dart';

class UploadView extends ConsumerStatefulWidget {
  const UploadView({super.key});

  @override
  ConsumerState<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends ConsumerState<UploadView> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _organizerCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  EventCategory _category = EventCategory.lomba;
  String _subCategory = eventSubCategories[1];
  DateTime _deadline = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _titleCtrl.dispose();
    _organizerCtrl.dispose();
    _locationCtrl.dispose();
    _descCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final event = EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text,
      category: _category,
      subCategory: _subCategory,
      organizer: _organizerCtrl.text,
      location: _locationCtrl.text,
      deadline: _deadline,
      emoji: _category == EventCategory.lomba ? '🏆' : '🎓',
      baseColor: _category == EventCategory.lomba
          ? const Color(0xFF6C72FF)
          : const Color(0xFF2ECC71),
      description: _descCtrl.text,
      registrationUrl: _urlCtrl.text,
    );
    ref.read(eventProvider.notifier).addEvent(event);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Event berhasil ditambahkan!'),
        backgroundColor: Color(0xFF4A5CFC),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tambah Info',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E))),
                const SizedBox(height: 4),
                const Text('Bagikan peluang kepada sesama',
                    style: TextStyle(
                        fontSize: 13, color: Color(0xFF9094A6))),
                const SizedBox(height: 24),

                // Category toggle
                Row(
                  children: [EventCategory.lomba, EventCategory.beasiswa].map((c) {
                    final label = c == EventCategory.lomba ? 'Lomba' : 'Beasiswa';
                    final active = _category == c;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _category = c),
                        child: Container(
                          margin: EdgeInsets.only(
                              right: c == EventCategory.lomba ? 8 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(0xFF4A5CFC)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: active
                                    ? const Color(0xFF4A5CFC)
                                    : const Color(0xFFE8E9F0)),
                          ),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: active
                                  ? Colors.white
                                  : const Color(0xFF9094A6),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                _Input(label: 'Nama Acara', ctrl: _titleCtrl),
                _Input(label: 'Penyelenggara', ctrl: _organizerCtrl),
                _Input(label: 'Lokasi', ctrl: _locationCtrl),
                _Input(
                    label: 'Deskripsi',
                    ctrl: _descCtrl,
                    maxLines: 3,
                    required: false),
                _Input(
                    label: 'Link Pendaftaran',
                    ctrl: _urlCtrl,
                    required: false),

                // Sub-category dropdown
                const Text('Sub Kategori',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E))),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _subCategory,
                  decoration: _inputDecoration,
                  items: eventSubCategories
                      .skip(1)
                      .map((s) =>
                          DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _subCategory = v!),
                ),
                const SizedBox(height: 16),

                // Deadline
                const Text('Deadline',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E))),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _deadline,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setState(() => _deadline = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: const Color(0xFFE8E9F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 18, color: Color(0xFF9094A6)),
                        const SizedBox(width: 10),
                        Text(
                          '${_deadline.day}/${_deadline.month}/${_deadline.year}',
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF1A1A2E)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A5CFC),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Kirim Info',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final _inputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFE8E9F0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFE8E9F0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFF4A5CFC)),
  ),
);

class _Input extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final int maxLines;
  final bool required;

  const _Input({
    required this.label,
    required this.ctrl,
    this.maxLines = 1,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 8),
          TextFormField(
            controller: ctrl,
            maxLines: maxLines,
            decoration: _inputDecoration.copyWith(hintText: label),
            validator: required
                ? (v) =>
                    v == null || v.trim().isEmpty ? '$label wajib diisi' : null
                : null,
          ),
        ],
      ),
    );
  }
}
