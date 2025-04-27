// Augment: TripOnBuddy Website → Flutter App
class TravelTip {
  final String category;
  final String icon;
  final List<String> items;

  TravelTip({
    required this.category,
    required this.icon,
    required this.items,
  });

  factory TravelTip.fromJson(Map<String, dynamic> json) {
    return TravelTip(
      category: json['category'],
      icon: json['icon'],
      items: List<String>.from(json['items']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'icon': icon,
      'items': items,
    };
  }
}
