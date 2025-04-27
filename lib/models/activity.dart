// Augment: TripOnBuddy Website → Flutter App
class Activity {
  final String id;
  final String name;
  final String description;
  final int cost;
  final String? imageUrl;
  final String? location;
  final DateTime? startTime;
  final DateTime? endTime;

  Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    this.imageUrl,
    this.location,
    this.startTime,
    this.endTime,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      cost: json['cost'],
      imageUrl: json['imageUrl'],
      location: json['location'],
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cost': cost,
      'imageUrl': imageUrl,
      'location': location,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }
}
