// Augment: TripOnBuddy Website → Flutter App
class IndianState {
  final String id;
  final String name;
  final String region;
  final String capital;
  final String imageUrl;
  final List<String> famousFor;

  IndianState({
    required this.id,
    required this.name,
    required this.region,
    required this.capital,
    required this.imageUrl,
    required this.famousFor,
  });

  factory IndianState.fromJson(Map<String, dynamic> json) {
    return IndianState(
      id: json['id'],
      name: json['name'],
      region: json['region'],
      capital: json['capital'],
      imageUrl: json['imageUrl'],
      famousFor: List<String>.from(json['famousFor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'capital': capital,
      'imageUrl': imageUrl,
      'famousFor': famousFor,
    };
  }
}
