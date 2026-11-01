class DocumentModel {
  final String id;
  final String title;
  final String fileType; // 'PDF', 'DOC', 'PPT'
  final String authorName;
  final String authorInitials;
  final String category;
  final int downloadCount;
  final double fileSizeMB;

  DocumentModel({
    required this.id,
    required this.title,
    required this.fileType,
    required this.authorName,
    required this.authorInitials,
    required this.category,
    required this.downloadCount,
    required this.fileSizeMB,
  });

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] as String? ?? '',
      fileType: map['file_type'] as String? ?? 'PDF',
      authorName: map['author_name'] as String? ?? '',
      authorInitials: map['author_initials'] as String? ?? '',
      category: map['category'] as String? ?? '',
      downloadCount: (map['download_count'] as num?)?.toInt() ?? 0,
      fileSizeMB: (map['file_size_mb'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'file_type': fileType,
      'author_name': authorName,
      'author_initials': authorInitials,
      'category': category,
      'download_count': downloadCount,
      'file_size_mb': fileSizeMB,
    };
  }
}

class DocumentDetailModel {
  final String id;
  final String title;
  final String fileType;
  final String authorName;
  final String authorInitials;
  final String authorRole;
  final String category;
  final int downloadCount;
  final double fileSizeMB;
  final String uploadDate;
  final int totalPages;
  final double rating;
  final String description;

  DocumentDetailModel({
    required this.id,
    required this.title,
    required this.fileType,
    required this.authorName,
    required this.authorInitials,
    required this.authorRole,
    required this.category,
    required this.downloadCount,
    required this.fileSizeMB,
    required this.uploadDate,
    required this.totalPages,
    required this.rating,
    required this.description,
  });

  factory DocumentDetailModel.fromMap(Map<String, dynamic> map) {
    return DocumentDetailModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] as String? ?? '',
      fileType: map['file_type'] as String? ?? 'PDF',
      authorName: map['author_name'] as String? ?? '',
      authorInitials: map['author_initials'] as String? ?? '',
      authorRole: map['author_role'] as String? ?? '',
      category: map['category'] as String? ?? '',
      downloadCount: (map['download_count'] as num?)?.toInt() ?? 0,
      fileSizeMB: (map['file_size_mb'] as num?)?.toDouble() ?? 0.0,
      uploadDate: map['upload_date'] as String? ?? '',
      totalPages: (map['total_pages'] as num?)?.toInt() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'file_type': fileType,
      'author_name': authorName,
      'author_initials': authorInitials,
      'author_role': authorRole,
      'category': category,
      'download_count': downloadCount,
      'file_size_mb': fileSizeMB,
      'upload_date': uploadDate,
      'total_pages': totalPages,
      'rating': rating,
      'description': description,
    };
  }
}
