// Augment: TripOnBuddy Website → Flutter App
import 'package:karnova/models/destination.dart';

enum TravelPreference {
  adventure,
  culture,
  relaxation,
  classical,
  shopping,
  food,
}

extension TravelPreferenceExtension on TravelPreference {
  String get name {
    switch (this) {
      case TravelPreference.adventure:
        return 'Adventure';
      case TravelPreference.culture:
        return 'Culture';
      case TravelPreference.relaxation:
        return 'Relaxation';
      case TravelPreference.classical:
        return 'Classical';
      case TravelPreference.shopping:
        return 'Shopping';
      case TravelPreference.food:
        return 'Food';
    }
  }

  String get icon {
    switch (this) {
      case TravelPreference.adventure:
        return 'hiking';
      case TravelPreference.culture:
        return 'account_balance';
      case TravelPreference.relaxation:
        return 'beach_access';
      case TravelPreference.classical:
        return 'music_note';
      case TravelPreference.shopping:
        return 'shopping_bag';
      case TravelPreference.food:
        return 'restaurant';
    }
  }
}

class Trip {
  final String id;
  final String startLocation;
  final bool isWorldwide;
  final String destination;
  final DateTime startDate;
  final int numberOfDays;
  final int budget;
  final TravelPreference preference;
  final Destination? destinationDetails;

  Trip({
    required this.id,
    required this.startLocation,
    required this.isWorldwide,
    required this.destination,
    required this.startDate,
    required this.numberOfDays,
    required this.budget,
    required this.preference,
    this.destinationDetails,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      startLocation: json['startLocation'],
      isWorldwide: json['isWorldwide'],
      destination: json['destination'],
      startDate: DateTime.parse(json['startDate']),
      numberOfDays: json['numberOfDays'],
      budget: json['budget'],
      preference: TravelPreference.values.firstWhere(
        (e) => e.name.toLowerCase() == json['preference'].toLowerCase(),
      ),
      destinationDetails: json['destinationDetails'] != null
          ? Destination.fromJson(json['destinationDetails'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startLocation': startLocation,
      'isWorldwide': isWorldwide,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'numberOfDays': numberOfDays,
      'budget': budget,
      'preference': preference.name,
      'destinationDetails': destinationDetails?.toJson(),
    };
  }

  Trip copyWith({
    String? id,
    String? startLocation,
    bool? isWorldwide,
    String? destination,
    DateTime? startDate,
    int? numberOfDays,
    int? budget,
    TravelPreference? preference,
    Destination? destinationDetails,
  }) {
    return Trip(
      id: id ?? this.id,
      startLocation: startLocation ?? this.startLocation,
      isWorldwide: isWorldwide ?? this.isWorldwide,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      budget: budget ?? this.budget,
      preference: preference ?? this.preference,
      destinationDetails: destinationDetails ?? this.destinationDetails,
    );
  }
}
