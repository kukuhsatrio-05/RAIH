import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/features/profile/data/profile_model.dart';
import 'package:raih/features/profile/data/profile_repository.dart';
import 'package:raih/features/profile/presentation/profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _facultyController = TextEditingController();
  final _majorController = TextEditingController();
  final _bioController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _instagramController = TextEditingController();

  static const List<String> _faculties = [
    'Fakultas Ilmu Komputer (FILKOM)',
    'Fakultas Teknik (FT)',
    'Fakultas Ekonomi dan Bisnis (FEB)',
    'Fakultas Hukum (FH)',
    'Fakultas Ilmu Administrasi (FIA)',
    'Fakultas Pertanian (FP)',
    'Fakultas Peternakan (FAPET)',
    'Fakultas Kedokteran (FK)',
    'Fakultas Perikanan dan Ilmu Kelautan (FPIK)',
    'Fakultas Matematika dan Ilmu Pengetahuan Alam (FMIPA)',
    'Fakultas Teknologi Pertanian (FTP)',
    'Fakultas Ilmu Sosial dan Ilmu Politik (FISIP)',
    'Fakultas Ilmu Budaya (FIB)',
    'Fakultas Kedokteran Gigi (FKG)',
    'Fakultas Kedokteran Hewan (FKH)',
    'Program Vokasi',
    'Lainnya',
  ];

  static const List<String> _suggestedSkills = [
    'UI/UX Design',
    'Graphic Design',
    'Mobile Development',
    'Web Development',
    'Data Analysis',
    'Machine Learning',
    'Project Management',
    'Public Speaking',
    'Writing',
    'Marketing',
  ];

  final Set<String> _selectedSkills = {};
  bool _isLoading = false;
  bool _isInitializing = true;
  bool _isOpenToJoin = false;
  bool _isMentor = false;
  PlatformFile? _selectedCv;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadProfile);
  }

  void _showStatusConflictDialog(String newStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konflik Status'),
        content: Text('Anda tidak dapat mengaktifkan $newStatus bersamaan dengan status lainnya. Pilih salah satu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isInitializing = true;
      _loadError = null;
    });

    final profileState = ref.read(profileProvider);
    ProfileModel? profile = profileState.profile;

    if (profile == null) {
      await ref.read(profileProvider.notifier).fetchOwnProfile();
      profile = ref.read(profileProvider).profile;
    }

    if (!mounted) return;

    if (profile != null) {
      _nameController.text = profile.fullName;
      _facultyController.text = profile.faculty ?? '';
      _majorController.text = profile.major ?? '';
      _bioController.text = profile.bio ?? '';
      _linkedinController.text = profile.linkedinUrl ?? '';
      _whatsappController.text = profile.whatsapp ?? '';
      _instagramController.text = profile.instagramHandle ?? '';
      _isOpenToJoin = profile.isOpenToJoin;
      _isMentor = profile.isMentor;
      _selectedSkills.addAll(profile.skills);
    } else {
      _loadError = ref.read(profileProvider).error ?? 'Gagal memuat profil';
    }

    setState(() => _isInitializing = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _facultyController.dispose();
    _majorController.dispose();
    _bioController.dispose();
    _linkedinController.dispose();
    _whatsappController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  Future<void> _pickCv() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      if (file.size > 5 * 1024 * 1024) {
        _showMessage('Ukuran CV maksimal 5 MB.');
        return;
      }
      if (file.bytes == null) {
        _showMessage('File CV tidak dapat dibaca. Coba pilih file lain.');
        return;
      }
      setState(() => _selectedCv = file);
    } catch (e) {
      _showMessage('Gagal memilih CV: $e');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final current = ref.read(profileProvider).profile!;

      String? cvUrl = current.cvUrl;
      if (_selectedCv != null && _selectedCv!.bytes != null) {
        cvUrl = await ref
            .read(profileRepositoryProvider)
            .uploadCv(current.id, _selectedCv!.bytes!, _selectedCv!.name);
      }

      final updated = current.copyWith(
        fullName: _nameController.text.trim(),
        faculty: _facultyController.text.trim(),
        major: _majorController.text.trim(),
        bio: _bioController.text.trim(),
        linkedinUrl: _linkedinController.text.trim(),
        whatsapp: _whatsappController.text.trim(),
        instagramHandle: _instagramController.text.trim(),
        isOpenToJoin: _isOpenToJoin,
        isMentor: _isMentor,
        cvUrl: cvUrl,
        isProfileCompleted: true,
      );

      await ref
          .read(profileProvider.notifier)
          .updateProfile(updated, skills: _selectedSkills.toList());

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_loadError != null) {
      return Scaffold(body: Center(child: Text(_loadError!)));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            // Header Blue with Overlap
            SizedBox(
              height: 180,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.blueGradientStart,
                          AppColors.blueGradientEnd,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'Edit Profil',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Avatar section
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4),
                                color: Colors.grey[200],
                              ),
                              child: const CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/100',
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3B82F6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildCard([
                        _buildToggle('Join My Team', 'Tampilkan statusmu ke pengguna lain', _isOpenToJoin, (value) {
                          if (value && _isMentor) {
                            _showStatusConflictDialog('Join My Team');
                          } else {
                            setState(() => _isOpenToJoin = value);
                          }
                        }),
                        const Divider(),
                        _buildToggle('Mentor', 'Tampilkan statusmu ke pengguna lain', _isMentor, (value) {
                          if (value && _isOpenToJoin) {
                            _showStatusConflictDialog('Mentor');
                          } else {
                            setState(() => _isMentor = value);
                          }
                        }),
                        if (_isOpenToJoin) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(10)),
                            child: const Row(children: [
                              Icon(Icons.circle, size: 8, color: Color(0xFF15803D)),
                              SizedBox(width: 8),
                              Expanded(child: Text('Profilmu terlihat oleh calon rekan tim', style: TextStyle(color: Color(0xFF15803D), fontSize: 12))),
                            ]),
                          ),
                        ],
                      ]),
                      const SizedBox(height: 24),
                      Align(alignment: Alignment.centerLeft, child: _sectionHeader('Informasi Dasar')),
                      const SizedBox(height: 12),
                      _buildCard([
                        _buildInputField('Nama Lengkap', _nameController, 'Masukkan nama lengkap'),
                        const SizedBox(height: 16),
                        _buildFacultyDropdown('Fakultas'),
                        const SizedBox(height: 16),
                        _buildInputField('Jurusan / Program Studi', _majorController, 'Teknik Informatika'),
                        const SizedBox(height: 16),
                        _buildBioField(),
                      ]),
                      const SizedBox(height: 24),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        _sectionHeader('Keahlian'),
                        Text('${_selectedSkills.length}/5', style: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
                      ]),
                      const SizedBox(height: 12),
                      _buildCard([
                        Wrap(spacing: 8, runSpacing: 8, children: _selectedSkills.map((skill) => _buildSkillChip(skill, isSelected: true)).toList()),
                        if (_selectedSkills.isNotEmpty) const SizedBox(height: 12),
                        const Text('Maksimum 5 keahlian dipilih', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        const SizedBox(height: 12),
                        Wrap(spacing: 8, runSpacing: 8, children: _suggestedSkills.where((skill) => !_selectedSkills.contains(skill)).map((skill) => _buildSkillChip(skill, isSelected: false)).toList()),
                      ]),
                      const SizedBox(height: 24),
                      Align(alignment: Alignment.centerLeft, child: _sectionHeader('Tautan Sosial')),
                      const SizedBox(height: 12),
                      _buildCard([
                        _buildInputField('LinkedIn', _linkedinController, 'linkedin.com/in/username'),
                        const SizedBox(height: 16),
                        _buildInputField('WhatsApp', _whatsappController, '08123456789'),
                        const SizedBox(height: 16),
                        _buildInputField('Instagram', _instagramController, 'instagram.com'),
                      ]),
                      const SizedBox(height: 24),
                      Align(alignment: Alignment.centerLeft, child: _sectionHeader('Curriculum Vitae (CV)')),
                      const SizedBox(height: 4),
                      const Align(alignment: Alignment.centerLeft, child: Text('Format PDF, maks. 5 MB', style: TextStyle(color: Color(0xFF64748B), fontSize: 12))),
                      const SizedBox(height: 12),
                      _buildCvUploadBox(),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _save,
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.blueNormal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                          child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Simpan perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildToggle(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF22C55E),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildFacultyDropdown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: _faculties.contains(_facultyController.text)
              ? _facultyController.text
              : null,
          items: _faculties
              .map(
                (f) => DropdownMenuItem(
                  value: f,
                  child: Text(f, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: (val) =>
              setState(() => _facultyController.text = val ?? ''),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          validator: label == 'Nama Lengkap'
              ? (value) => value == null || value.trim().isEmpty
                    ? 'Nama lengkap wajib diisi'
                    : null
              : null,
        ),
      ],
    );
  }

  Widget _buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bio',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _bioController,
          maxLines: 4,
          maxLength: 200,
          decoration: InputDecoration(
            hintText: 'Ceritakan tentang dirimu...',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedSkills.remove(skill);
          } else if (_selectedSkills.length < 5) {
            _selectedSkills.add(skill);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFFE2E8F0),
            style: isSelected ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isSelected ? skill : '+ $skill',
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF64748B),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              const Icon(Icons.close, size: 14, color: Color(0xFF3B82F6)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCvUploadBox() {
    final hasFile = _selectedCv != null;
    return GestureDetector(
      onTap: _pickCv,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.upload, color: Color(0xFF3B82F6)),
            ),
            const SizedBox(height: 12),
            Text(
              hasFile ? _selectedCv!.name : 'Upload CV-mu',
              style: const TextStyle(
                color: Color(0xFF3B82F6),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Text(
              'Ketuk untuk memilih file',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
