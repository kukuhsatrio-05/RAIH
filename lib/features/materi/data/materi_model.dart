class MateriSectionModel {
  final String id;
  final String topic;
  final int color;
  final List<String> items;

  const MateriSectionModel({
    required this.id,
    required this.topic,
    required this.color,
    required this.items,
  });

  factory MateriSectionModel.fromMap(Map<String, dynamic> map) {
    return MateriSectionModel(
      id: map['id']?.toString() ?? '',
      topic: map['topic'] as String? ?? '',
      color: (map['color'] as num?)?.toInt() ?? 0xFF6C72FF,
      items: (map['items'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic': topic,
      'color': color,
      'items': items,
    };
  }
}

typedef MateriModel = MateriSectionModel;
