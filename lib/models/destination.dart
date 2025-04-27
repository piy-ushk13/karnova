// Augment: TripOnBuddy Website → Flutter App
class Destination {
  final String id;
  final String name;
  final String region;
  final String country;
  final String description;
  final String image;
  final double rating;
  final int price;
  final List<String> attractions;
  final List<String> activities;
  final List<String> tags;

  Destination({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.description,
    required this.image,
    required this.rating,
    required this.price,
    required this.attractions,
    required this.activities,
    required this.tags,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'],
      name: json['name'],
      region: json['region'],
      country: json['country'],
      description: json['description'],
      image: json['image'],
      rating: json['rating'].toDouble(),
      price: json['price'],
      attractions: List<String>.from(json['attractions']),
      activities: List<String>.from(json['activities']),
      tags: List<String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'country': country,
      'description': description,
      'image': image,
      'rating': rating,
      'price': price,
      'attractions': attractions,
      'activities': activities,
      'tags': tags,
    };
  }
}
