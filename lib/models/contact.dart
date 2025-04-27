// Augment: TripOnBuddy Website → Flutter App
class Contact {
  final String id;
  final String name;
  final String relationship; // 'Family' or 'Friend'
  final String email;
  final String phone;
  final String? image;
  final bool isFavorite;
  final List<String> recentTrips; // IDs of recent trips with this contact

  Contact({
    required this.id,
    required this.name,
    required this.relationship,
    required this.email,
    required this.phone,
    this.image,
    this.isFavorite = false,
    this.recentTrips = const [],
  });

  Contact copyWith({
    String? id,
    String? name,
    String? relationship,
    String? email,
    String? phone,
    String? image,
    bool? isFavorite,
    List<String>? recentTrips,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
      recentTrips: recentTrips ?? this.recentTrips,
    );
  }

  // Factory method to create a Contact from JSON
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      relationship: json['relationship'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      isFavorite: json['isFavorite'] ?? false,
      recentTrips: List<String>.from(json['recentTrips'] ?? []),
    );
  }

  // Convert Contact to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'email': email,
      'phone': phone,
      'image': image,
      'isFavorite': isFavorite,
      'recentTrips': recentTrips,
    };
  }
}
