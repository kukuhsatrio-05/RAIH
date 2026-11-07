import 'package:flutter_test/flutter_test.dart';
import 'package:raih/features/profile/data/profile_model.dart';

void main() {
  group('ProfileModel.fromMap', () {
    test('maps existing profiles table column names', () {
      final profile = ProfileModel.fromMap({
        'id': 'user-id',
        'full_name': 'Raihan User',
        'phone_number': '+628123456789',
        'faculty': 'Fakultas Teknik',
      });

      expect(profile.fullName, 'Raihan User');
      expect(profile.whatsapp, '+628123456789');
      expect(profile.faculty, 'Fakultas Teknik');
    });

    test('prefers current profile fields over legacy aliases', () {
      final profile = ProfileModel.fromMap({
        'id': 'user-id',
        'full_name': 'Raihan User',
        'phone_number': '+628123456789',
        'whatsapp': '+628111111111',
        'faculty': 'Fakultas Teknik',
        'institution': 'Universitas Contoh',
      });

      expect(profile.whatsapp, '+628111111111');
      expect(profile.faculty, 'Fakultas Teknik');
    });
  });

  group('ProfileModel.toUpdateMap', () {
    test('only includes fields managed by the edit profile form', () {
      final profile = ProfileModel(
        id: 'user-id',
        fullName: 'Raihan User',
        email: 'raihan@example.com',
        role: 'Student',
        faculty: 'Universitas',
        location: 'Bandung',
        whatsapp: '+628123456789',
        linkedinUrl: 'https://linkedin.com/in/raihan',
        instagramHandle: 'raihan',
        headline: 'Student',
        bio: 'Tentang saya',
        cvUrl: 'https://example.com/cv.pdf',
        isProfileCompleted: true,
        isOpenToJoin: true,
        savedCount: 2,
        uploadedCount: 3,
        selectedCount: 1,
        avatarUrl: 'https://example.com/avatar.png',
        updatedAt: DateTime.utc(2026, 11, 4),
      );

      expect(profile.toUpdateMap(), {
        'full_name': 'Raihan User',
        'faculty': 'Universitas',
        'major': null,
        'location': 'Bandung',
        'whatsapp': '+628123456789',
        'linkedin_url': 'https://linkedin.com/in/raihan',
        'instagram_handle': 'raihan',
        'headline': 'Student',
        'bio': 'Tentang saya',
        'cv_url': 'https://example.com/cv.pdf',
        'is_profile_completed': true,
        'is_open_to_join': true,
        'updated_at': '2026-11-04T00:00:00.000Z',
      });
    });

    test('does not send avatar or read-only metadata', () {
      final profile = ProfileModel(id: 'user-id', fullName: 'Raihan User');

      final payload = profile.toUpdateMap();

      expect(payload, isNot(contains('avatar_url')));
      expect(payload, isNot(contains('saved_count')));
      expect(payload, isNot(contains('uploaded_count')));
      expect(payload, isNot(contains('selected_count')));
      expect(payload, isNot(contains('email')));
      expect(payload, isNot(contains('id')));
    });
  });
}
