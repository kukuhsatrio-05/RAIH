class OnboardingItem {
  final String imagePath;
  final String title;
  final String description;

  OnboardingItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  factory OnboardingItem.fromMap(Map<String, dynamic> map) {
    return OnboardingItem(
      imagePath: map['image_path'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image_path': imagePath,
      'title': title,
      'description': description,
    };
  }
}

typedef OnboardingModel = OnboardingItem;
