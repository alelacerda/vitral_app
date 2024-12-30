class StainedGlass {
  final String title;
  final String locationId;
  final List<String> informationIds;

  StainedGlass({
    required this.title,
    required this.locationId,
    required this.informationIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'locationId': locationId,
      'informationIds': informationIds,
    };
  }

  factory StainedGlass.fromMap(Map<String, dynamic> map) {
    return StainedGlass(
      title: map['title'],
      locationId: map['location'],
      informationIds: List<String>.from(map['info'] ?? []),
    );
  }
}