class StainedGlassInfo {
  final String title;
  final String description;
  final String category;
  final List<double> position;
  final String? imageUrl;
  final String? articleId;

  StainedGlassInfo({
    required this.title,
    required this.description,
    required this.category,
    required this.position,
    this.imageUrl,
    this.articleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'position': position,
      'imageUrl': imageUrl,
      'articleId': articleId,
    };
  }

  factory StainedGlassInfo.fromMap(Map<String, dynamic> map) {
    return StainedGlassInfo(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      position: List<double>.from(map['position'] ?? []),
      imageUrl: map['imageUrl'],
      articleId: map['article'],
    );
  }
}