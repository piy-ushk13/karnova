// Augment: TripOnBuddy Website → Flutter App
class AreaOfInterest {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool isSelected;

  AreaOfInterest({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.isSelected = false,
  });

  AreaOfInterest copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    bool? isSelected,
  }) {
    return AreaOfInterest(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory AreaOfInterest.fromJson(Map<String, dynamic> json) {
    return AreaOfInterest(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'isSelected': isSelected,
    };
  }

  // Generate common areas of interest for a destination
  static List<AreaOfInterest> getCommonAreas() {
    return [
      AreaOfInterest(
        id: '1',
        name: 'Tourist Attractions',
        description: 'Popular sightseeing spots',
        icon: 'photo_camera',
      ),
      AreaOfInterest(
        id: '2',
        name: 'Local Cuisine',
        description: 'Food and dining experiences',
        icon: 'restaurant',
      ),
      AreaOfInterest(
        id: '3',
        name: 'Shopping',
        description: 'Markets and shopping centers',
        icon: 'shopping_bag',
      ),
      AreaOfInterest(
        id: '4',
        name: 'Nature',
        description: 'Parks, gardens, and natural attractions',
        icon: 'nature',
      ),
      AreaOfInterest(
        id: '5',
        name: 'Cultural Sites',
        description: 'Museums, temples, and historical places',
        icon: 'account_balance',
      ),
      AreaOfInterest(
        id: '6',
        name: 'Adventure',
        description: 'Outdoor and adventure activities',
        icon: 'hiking',
      ),
    ];
  }
}
