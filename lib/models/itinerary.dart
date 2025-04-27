// Augment: TripOnBuddy Website → Flutter App
import 'package:karnova/models/activity.dart';

class ItineraryItem {
  final String id;
  final int day;
  final String title;
  final String description;
  final List<Activity> activities;
  final int cost;

  ItineraryItem({
    required this.id,
    required this.day,
    required this.title,
    required this.description,
    required this.activities,
    required this.cost,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    return ItineraryItem(
      id: json['id'],
      day: json['day'],
      title: json['title'],
      description: json['description'],
      activities:
          (json['activities'] as List)
              .map((activity) => Activity.fromJson(activity))
              .toList(),
      cost: json['cost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'title': title,
      'description': description,
      'activities': activities.map((activity) => activity.toJson()).toList(),
      'cost': cost,
    };
  }
}

class Itinerary {
  final String id;
  final String tripId;
  final List<ItineraryItem> items;
  final int totalCost;

  Itinerary({
    required this.id,
    required this.tripId,
    required this.items,
    required this.totalCost,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'],
      tripId: json['tripId'],
      items:
          (json['items'] as List)
              .map((item) => ItineraryItem.fromJson(item))
              .toList(),
      totalCost: json['totalCost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalCost': totalCost,
    };
  }
}
