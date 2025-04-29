// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/foundation.dart';

class AIGeneratedItinerary {
  final List<DailyPlan> dailyPlans;
  final List<AccommodationSuggestion> accommodation;
  final List<String> travelTips;
  final String totalEstimatedCost;
  final String bestTimeToVisit;

  AIGeneratedItinerary({
    required this.dailyPlans,
    required this.accommodation,
    required this.travelTips,
    required this.totalEstimatedCost,
    required this.bestTimeToVisit,
  });

  factory AIGeneratedItinerary.fromJson(Map<String, dynamic> json) {
    return AIGeneratedItinerary(
      dailyPlans: (json['dailyPlans'] as List)
          .map((plan) => DailyPlan.fromJson(plan))
          .toList(),
      accommodation: (json['accommodation'] as List)
          .map((acc) => AccommodationSuggestion.fromJson(acc))
          .toList(),
      travelTips: List<String>.from(json['travelTips']),
      totalEstimatedCost: json['totalEstimatedCost'],
      bestTimeToVisit: json['bestTimeToVisit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyPlans': dailyPlans.map((plan) => plan.toJson()).toList(),
      'accommodation': accommodation.map((acc) => acc.toJson()).toList(),
      'travelTips': travelTips,
      'totalEstimatedCost': totalEstimatedCost,
      'bestTimeToVisit': bestTimeToVisit,
    };
  }

  // Convert to ItineraryDetail model for compatibility with existing app
  Map<String, dynamic> toItineraryDetailJson({
    required String id,
    required String title,
    required String subtitle,
    required DateTime startDate,
    required DateTime endDate,
    required int travelers,
    required int budget,
    required String startLocation,
  }) {
    // Extract highlights from daily plans
    final highlights = <String>[];
    for (final plan in dailyPlans) {
      for (final activity in plan.activities) {
        if (highlights.length < 6 && !highlights.contains(activity.location)) {
          highlights.add(activity.location);
        }
      }
    }

    // Convert daily plans to daily itineraries
    final dailyItineraries = dailyPlans.map((plan) {
      return {
        'day': plan.day,
        'title': 'Day ${plan.day}',
        'description': 'Exploring ${plan.activities.first.location}',
        'activities': plan.activities.map((activity) {
          return {
            'time': activity.time,
            'title': activity.activity,
            'description': '${activity.location} - ${activity.bookingInfo.availability}',
            'cost': _extractCostValue(activity.estimatedCost),
          };
        }).toList(),
      };
    }).toList();

    // Convert accommodation suggestions
    final accommodations = accommodation.map((acc) {
      return {
        'name': acc.name,
        'address': acc.description,
        'checkIn': startDate.toIso8601String(),
        'checkOut': endDate.toIso8601String(),
        'cost': _extractCostValue(acc.priceRange),
        'rating': _extractRatingValue(acc.rating),
        'amenities': ['Free Wi-Fi', 'Breakfast', 'Air Conditioning'],
      };
    }).toList();

    // Create mock transportation data
    final transportations = [
      {
        'type': 'Flight',
        'from': startLocation,
        'to': dailyPlans.first.activities.first.location,
        'departureTime': startDate.toIso8601String(),
        'arrivalTime': startDate.add(const Duration(hours: 2)).toIso8601String(),
        'cost': budget ~/ 5,
        'provider': 'Air India',
      },
      {
        'type': 'Flight',
        'from': dailyPlans.last.activities.last.location,
        'to': startLocation,
        'departureTime': endDate.subtract(const Duration(hours: 3)).toIso8601String(),
        'arrivalTime': endDate.toIso8601String(),
        'cost': budget ~/ 5,
        'provider': 'IndiGo',
      },
    ];

    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'travelers': travelers,
      'budget': budget,
      'startLocation': startLocation,
      'highlights': highlights,
      'weatherForecast': [], // This would be populated from a weather service
      'dailyItineraries': dailyItineraries,
      'accommodations': accommodations,
      'transportations': transportations,
      'travelTips': travelTips,
    };
  }

  // Helper method to extract cost value from string
  static int _extractCostValue(String costString) {
    try {
      // Remove all non-numeric characters except decimal point
      final numericString = costString.replaceAll(RegExp(r'[^0-9.]'), '');
      if (numericString.isEmpty) return 0;
      
      // Parse as double first to handle decimal values
      final value = double.parse(numericString);
      return value.toInt();
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing cost: $e');
      }
      return 0;
    }
  }

  // Helper method to extract rating value from string
  static double _extractRatingValue(String ratingString) {
    try {
      // Extract numeric part (e.g., "4.5/5" -> "4.5")
      final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(ratingString);
      if (match != null) {
        return double.parse(match.group(1)!);
      }
      return 4.0; // Default value
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing rating: $e');
      }
      return 4.0; // Default value
    }
  }
}

class DailyPlan {
  final int day;
  final List<ActivityPlan> activities;

  DailyPlan({
    required this.day,
    required this.activities,
  });

  factory DailyPlan.fromJson(Map<String, dynamic> json) {
    return DailyPlan(
      day: json['day'],
      activities: (json['activities'] as List)
          .map((activity) => ActivityPlan.fromJson(activity))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'activities': activities.map((activity) => activity.toJson()).toList(),
    };
  }
}

class ActivityPlan {
  final String time;
  final String activity;
  final String location;
  final String estimatedCost;
  final BookingInfo bookingInfo;

  ActivityPlan({
    required this.time,
    required this.activity,
    required this.location,
    required this.estimatedCost,
    required this.bookingInfo,
  });

  factory ActivityPlan.fromJson(Map<String, dynamic> json) {
    return ActivityPlan(
      time: json['time'],
      activity: json['activity'],
      location: json['location'],
      estimatedCost: json['estimatedCost'],
      bookingInfo: BookingInfo.fromJson(json['bookingInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'activity': activity,
      'location': location,
      'estimatedCost': estimatedCost,
      'bookingInfo': bookingInfo.toJson(),
    };
  }
}

class BookingInfo {
  final String availability;
  final String price;
  final String? bookingUrl;

  BookingInfo({
    required this.availability,
    required this.price,
    this.bookingUrl,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      availability: json['availability'],
      price: json['price'],
      bookingUrl: json['bookingUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'availability': availability,
      'price': price,
    };
    if (bookingUrl != null) {
      data['bookingUrl'] = bookingUrl;
    }
    return data;
  }
}

class AccommodationSuggestion {
  final String name;
  final String type;
  final String priceRange;
  final String rating;
  final String description;

  AccommodationSuggestion({
    required this.name,
    required this.type,
    required this.priceRange,
    required this.rating,
    required this.description,
  });

  factory AccommodationSuggestion.fromJson(Map<String, dynamic> json) {
    return AccommodationSuggestion(
      name: json['name'],
      type: json['type'],
      priceRange: json['priceRange'],
      rating: json['rating'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'priceRange': priceRange,
      'rating': rating,
      'description': description,
    };
  }
}
