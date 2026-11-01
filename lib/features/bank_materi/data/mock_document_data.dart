import 'package:raih/features/bank_materi/data/bank_materi_model.dart';

/// Centralized mock data sumber tunggal untuk Bank Materi.
/// Data DocumentDetailModel dipakai di list maupun halaman detail.
class MockDocumentData {
  static final List<DocumentDetailModel> documents = [
    DocumentDetailModel(
      id: '1',
      title: 'Panduan Lengkap Membuat Business Plan',
      fileType: 'PDF',
      authorName: 'Dr. Andi Pratama, M.Sc.',
      authorInitials: 'AP',
      authorRole: 'Dosen Kewirausahaan',
      category: 'Kewirausahaan',
      downloadCount: 1204,
      fileSizeMB: 2.4,
      uploadDate: '21 Apr 2026',
      totalPages: 48,
      rating: 4.9,
      description:
          'Panduan komprehensif membuat business plan yang profesional dan siap pitching. '
          'Mencakup analisis pasar, proyeksi keuangan, strategi pemasaran, dan tips '
          'memenangkan kompetisi business plan tingkat nasional maupun internasional.',
    ),
    DocumentDetailModel(
      id: '2',
      title: 'Template Proposal PKM 5 Bidang Lengkap',
      fileType: 'DOC',
      authorName: 'Team Raih',
      authorInitials: 'TR',
      authorRole: 'Tim Konten Raih',
      category: 'Proposal',
      downloadCount: 204,
      fileSizeMB: 2.9,
      uploadDate: '10 Mei 2026',
      totalPages: 32,
      rating: 4.7,
      description:
          'Template proposal PKM (Program Kreativitas Mahasiswa) lengkap mencakup 5 bidang: '
          'PKM-RE, PKM-K, PKM-PM, PKM-PI, dan PKM-GFT. Setiap template sudah disesuaikan '
          'dengan format terbaru yang ditetapkan oleh Dikti.',
    ),
    DocumentDetailModel(
      id: '3',
      title: 'Modul Belajar Python untuk Data Science',
      fileType: 'PDF',
      authorName: 'Rina Kusuma S.Kom',
      authorInitials: 'RK',
      authorRole: 'Praktisi Data Science',
      category: 'Teknologi',
      downloadCount: 672,
      fileSizeMB: 7.4,
      uploadDate: '05 Jun 2026',
      totalPages: 96,
      rating: 4.8,
      description:
          'Modul belajar Python lengkap dari dasar hingga mahir untuk keperluan analisis data. '
          'Mencakup NumPy, Pandas, Matplotlib, hingga pengantar Machine Learning dengan '
          'Scikit-learn. Dilengkapi contoh kasus nyata dan latihan soal di setiap bab.',
    ),
    DocumentDetailModel(
      id: '4',
      title: 'Template Presentasi Lomba Anti Membosankan',
      fileType: 'PPT',
      authorName: 'Rama Justitia S.Pd',
      authorInitials: 'RJ',
      authorRole: 'Desainer UI/UX & Presenter',
      category: 'Desain',
      downloadCount: 98,
      fileSizeMB: 3.8,
      uploadDate: '18 Jun 2026',
      totalPages: 20,
      rating: 4.6,
      description:
          'Kumpulan template presentasi modern dan menarik yang siap pakai untuk berbagai jenis '
          'lomba. Desain minimalis, tipografi yang kuat, dan layout yang bersih akan membantu '
          'kamu tampil profesional dan percaya diri di hadapan juri.',
    ),
  ];

  /// Cari dokumen berdasarkan ID
  static DocumentDetailModel? findById(String id) {
    try {
      return documents.firstWhere((doc) => doc.id == id);
    } catch (_) {
      return null;
    }
  }
}
