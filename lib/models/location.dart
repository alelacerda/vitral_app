class Location {
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final String phone;
  final String workingHours;
  final List<String> stainedGlasses;
  final String internalMapUrl;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.phone,
    required this.workingHours,
    required this.stainedGlasses,
    required this.internalMapUrl,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      phone: map['phone'],
      workingHours: map['workingHours'],
      stainedGlasses: List<String>.from(map['stainedGlasses'] ?? []),
      internalMapUrl: map['internalMap'],
    );
  }
}