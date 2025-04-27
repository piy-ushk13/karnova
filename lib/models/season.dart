// Augment: TripOnBuddy Website → Flutter App
class Season {
  final String id;
  final String name;
  final String description;
  final String months;
  final String imageUrl;
  final List<String> bestDestinations;

  Season({
    required this.id,
    required this.name,
    required this.description,
    required this.months,
    required this.imageUrl,
    required this.bestDestinations,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      months: json['months'],
      imageUrl: json['imageUrl'],
      bestDestinations: List<String>.from(json['bestDestinations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'months': months,
      'imageUrl': imageUrl,
      'bestDestinations': bestDestinations,
    };
  }

  // List of all seasons
  static List<Season> getAllSeasons() {
    return [
      Season(
        id: 'winter',
        name: 'Winter',
        description: 'Cool and pleasant weather in most parts of India',
        months: 'December to February',
        imageUrl: 'https://images.unsplash.com/photo-1483921020237-2ff51e8e4b22',
        bestDestinations: ['Rajasthan', 'Kerala', 'Goa'],
      ),
      Season(
        id: 'summer',
        name: 'Summer',
        description: 'Hot weather in plains, perfect for hill stations',
        months: 'March to May',
        imageUrl: 'https://images.unsplash.com/photo-1473496169904-658ba7c44d8a',
        bestDestinations: ['Himachal Pradesh', 'Uttarakhand', 'Sikkim'],
      ),
      Season(
        id: 'monsoon',
        name: 'Monsoon',
        description: 'Rainy season with lush green landscapes',
        months: 'June to September',
        imageUrl: 'https://images.unsplash.com/photo-1428592953211-077101b2021b',
        bestDestinations: ['Western Ghats', 'Meghalaya', 'Valley of Flowers'],
      ),
      Season(
        id: 'autumn',
        name: 'Autumn',
        description: 'Pleasant weather after monsoon, festive season',
        months: 'October to November',
        imageUrl: 'https://images.unsplash.com/photo-1476820865390-c52aeebb9891',
        bestDestinations: ['West Bengal', 'Delhi', 'Varanasi'],
      ),
    ];
  }
}
