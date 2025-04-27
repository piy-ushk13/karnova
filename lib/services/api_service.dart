// Augment: TripOnBuddy Website → Flutter App
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karnova/models/destination.dart';
import 'package:karnova/models/itinerary.dart';
import 'package:karnova/models/travel_tip.dart';
import 'dart:convert';

// Provider for the API service
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

class ApiService {
  final Dio _dio = Dio();

  // Base URL for the API (would be a real API in production)
  final String _baseUrl = 'https://api.triponbuddy.com/v1';

  // Constructor to set up Dio
  ApiService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);

    // Add interceptors for logging, authentication, etc.
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  // Mock method to get destinations
  // In a real app, this would make an actual API call
  Future<List<Destination>> getDestinations({
    String? query,
    int? budget,
    double? minRating,
    List<String>? categories,
  }) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, this would be:
      // final response = await _dio.get('/destinations', queryParameters: {
      //   'query': query,
      //   'budget': budget,
      //   'min_rating': minRating,
      //   'categories': categories?.join(','),
      // });

      // For now, load from local JSON
      const jsonString = '''
      {
        "destinations": [
          {
            "id": "1",
            "name": "Goa",
            "region": "West India",
            "country": "India",
            "description": "Goa is a state on the southwestern coast of India within the region known as the Konkan.",
            "image": "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
            "rating": 4.5,
            "price": 15000,
            "attractions": ["Calangute Beach", "Baga Beach", "Fort Aguada"],
            "activities": ["Beach Activities", "Water Sports", "Nightlife"],
            "tags": ["Beach", "Relaxation", "Nightlife"]
          },
          {
            "id": "2",
            "name": "Manali",
            "region": "North India",
            "country": "India",
            "description": "Manali is a high-altitude Himalayan resort town in India's northern Himachal Pradesh state.",
            "image": "https://images.unsplash.com/photo-1558436378-fda9dc0b2917?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
            "rating": 4.7,
            "price": 20000,
            "attractions": ["Rohtang Pass", "Solang Valley", "Hadimba Temple"],
            "activities": ["Trekking", "Skiing", "Paragliding"],
            "tags": ["Mountains", "Adventure", "Nature"]
          }
        ]
      }
      ''';

      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> destinationsJson = jsonData['destinations'];

      // Filter based on parameters
      var filteredDestinations = destinationsJson;

      if (query != null && query.isNotEmpty) {
        filteredDestinations =
            filteredDestinations
                .where(
                  (dest) =>
                      dest['name'].toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      dest['region'].toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      dest['country'].toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
      }

      if (budget != null) {
        filteredDestinations =
            filteredDestinations
                .where((dest) => dest['price'] <= budget)
                .toList();
      }

      if (minRating != null) {
        filteredDestinations =
            filteredDestinations
                .where((dest) => dest['rating'] >= minRating)
                .toList();
      }

      if (categories != null && categories.isNotEmpty) {
        filteredDestinations =
            filteredDestinations
                .where(
                  (dest) => (dest['tags'] as List).any(
                    (tag) => categories.contains(tag),
                  ),
                )
                .toList();
      }

      return filteredDestinations
          .map((json) => Destination.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load destinations: $e');
    }
  }

  // Get a single destination by ID
  Future<Destination> getDestination(String id) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));

      // In a real app, this would be:
      // final response = await _dio.get('/destinations/$id');

      // For now, load from local JSON and filter
      const jsonString = '''
      {
        "destinations": [
          {
            "id": "1",
            "name": "Goa",
            "region": "West India",
            "country": "India",
            "description": "Goa is a state on the southwestern coast of India within the region known as the Konkan.",
            "image": "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
            "rating": 4.5,
            "price": 15000,
            "attractions": ["Calangute Beach", "Baga Beach", "Fort Aguada"],
            "activities": ["Beach Activities", "Water Sports", "Nightlife"],
            "tags": ["Beach", "Relaxation", "Nightlife"]
          },
          {
            "id": "2",
            "name": "Manali",
            "region": "North India",
            "country": "India",
            "description": "Manali is a high-altitude Himalayan resort town in India's northern Himachal Pradesh state.",
            "image": "https://images.unsplash.com/photo-1558436378-fda9dc0b2917?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
            "rating": 4.7,
            "price": 20000,
            "attractions": ["Rohtang Pass", "Solang Valley", "Hadimba Temple"],
            "activities": ["Trekking", "Skiing", "Paragliding"],
            "tags": ["Mountains", "Adventure", "Nature"]
          },
          {
            "id": "3",
            "name": "Klaten",
            "region": "Central Java",
            "country": "Indonesia",
            "description": "Klaten is a regency in Central Java province of Indonesia, known for its beautiful landscapes and cultural heritage.",
            "image": "https://images.unsplash.com/photo-1570168007204-dfb528c6958f?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
            "rating": 4.6,
            "price": 18000,
            "attractions": ["Kebun Pink", "Kebun Teh", "Parangtritis", "Candinan", "Siwalan Bogor"],
            "activities": ["Cultural Tours", "Horseback Riding", "Temple Visits", "Palm Plantation Tours"],
            "tags": ["Culture", "Nature", "Heritage"]
          }
        ]
      }
      ''';

      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> destinationsJson = jsonData['destinations'];

      final destinationJson = destinationsJson.firstWhere(
        (dest) => dest['id'] == id,
        orElse: () => throw Exception('Destination not found'),
      );

      return Destination.fromJson(destinationJson);
    } catch (e) {
      throw Exception('Failed to load destination: $e');
    }
  }

  // Get a single destination by ID with additional details
  Future<Destination> getDestinationById(String id) async {
    try {
      // Get the basic destination info
      final destination = await getDestination(id);

      // In a real app, we would make additional API calls for more details
      // For now, we'll just return the destination
      return destination;
    } catch (e) {
      throw Exception('Failed to load destination details: $e');
    }
  }

  // Get travel tips
  Future<List<TravelTip>> getTravelTips() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));

      // In a real app, this would be:
      // final response = await _dio.get('/travel-tips');

      // For now, load from local JSON
      const jsonString = '''
      {
        "tips": [
          {
            "category": "Safety",
            "icon": "shield",
            "items": [
              "Always keep digital copies of important documents",
              "Share your itinerary with family or friends",
              "Research local emergency numbers before traveling"
            ]
          },
          {
            "category": "Money-Saving",
            "icon": "savings",
            "items": [
              "Book flights 2-3 months in advance for best rates",
              "Travel during shoulder seasons for better deals",
              "Use local transportation instead of taxis when safe"
            ]
          }
        ]
      }
      ''';

      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> tipsJson = jsonData['tips'];

      return tipsJson.map((json) => TravelTip.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load travel tips: $e');
    }
  }

  // Plan a trip
  Future<Map<String, dynamic>> planTrip({
    required String source,
    required String destination,
    required DateTime departureDate,
    required int budget,
    String? preference,
  }) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, this would be:
      // final response = await _dio.post('/trips/plan', data: {
      //   'source': source,
      //   'destination': destination,
      //   'departure_date': departureDate.toIso8601String(),
      //   'budget': budget,
      //   'preference': preference,
      // });

      // For now, return mock response
      return {
        'success': true,
        'message': 'Trip planned successfully',
        'trip_id': '12345',
        'itinerary_id': '67890',
      };
    } catch (e) {
      throw Exception('Failed to plan trip: $e');
    }
  }
}
