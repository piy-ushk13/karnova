// Augment: TripOnBuddy Website → Flutter App
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karnova/models/destination.dart';
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
          },
          {
            "id": "3",
            "name": "Jaipur",
            "region": "North India",
            "country": "India",
            "description": "Jaipur is the capital of India's Rajasthan state. It evokes the royal family that once ruled the region and that, in 1727, founded what is now called the Old City, or 'Pink City'.",
            "image": "https://images.unsplash.com/photo-1477587458883-47145ed94245?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
            "rating": 4.6,
            "price": 18000,
            "attractions": ["Hawa Mahal", "Amber Fort", "City Palace", "Jantar Mantar"],
            "activities": ["Heritage Tours", "Shopping", "Food Tours", "Elephant Rides"],
            "tags": ["Culture", "Heritage", "History", "Shopping"]
          },
          {
            "id": "4",
            "name": "Kerala",
            "region": "South India",
            "country": "India",
            "description": "Kerala, a state on India's tropical Malabar Coast, has nearly 600km of Arabian Sea shoreline. It's known for its palm-lined beaches and backwaters.",
            "image": "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
            "rating": 4.8,
            "price": 25000,
            "attractions": ["Alleppey Backwaters", "Munnar", "Wayanad", "Kovalam Beach"],
            "activities": ["Houseboat Stay", "Ayurvedic Treatments", "Wildlife Safari", "Tea Plantation Tours"],
            "tags": ["Backwaters", "Nature", "Relaxation", "Ayurveda"]
          },
          {
            "id": "5",
            "name": "Darjeeling",
            "region": "East India",
            "country": "India",
            "description": "Darjeeling is a town in India's West Bengal state, in the Himalayan foothills. Once a summer resort for the British Raj elite.",
            "image": "https://images.unsplash.com/photo-1544181093-c712fb401bdc?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
            "rating": 4.5,
            "price": 22000,
            "attractions": ["Tiger Hill", "Batasia Loop", "Darjeeling Himalayan Railway", "Happy Valley Tea Estate"],
            "activities": ["Tea Garden Tours", "Toy Train Ride", "Trekking", "Sunrise Viewing"],
            "tags": ["Mountains", "Tea", "Nature", "Scenic"]
          },
          {
            "id": "6",
            "name": "Varanasi",
            "region": "North India",
            "country": "India",
            "description": "Varanasi is a city in the northern Indian state of Uttar Pradesh dating to the 11th century B.C.E. Regarded as the spiritual capital of India.",
            "image": "https://images.unsplash.com/photo-1561361058-c24cecae35ca",
            "rating": 4.4,
            "price": 16000,
            "attractions": ["Dashashwamedh Ghat", "Kashi Vishwanath Temple", "Sarnath", "Assi Ghat"],
            "activities": ["Boat Rides", "Temple Tours", "Ganga Aarti", "Spiritual Experiences"],
            "tags": ["Spiritual", "Culture", "History", "Religion"]
          },
          {
            "id": "7",
            "name": "Andaman Islands",
            "region": "Bay of Bengal",
            "country": "India",
            "description": "The Andaman Islands are an Indian archipelago in the Bay of Bengal. Known for pristine beaches, coral reefs and water sports.",
            "image": "https://images.unsplash.com/photo-1586094332115-6ca0e9dcd84f",
            "rating": 4.9,
            "price": 35000,
            "attractions": ["Radhanagar Beach", "Cellular Jail", "Ross Island", "Havelock Island"],
            "activities": ["Scuba Diving", "Snorkeling", "Island Hopping", "Beach Activities"],
            "tags": ["Beach", "Islands", "Adventure", "Water Sports"]
          },
          {
            "id": "8",
            "name": "Ladakh",
            "region": "North India",
            "country": "India",
            "description": "Ladakh is a region administered by India as a union territory, and constitutes a part of the larger Kashmir region. Known for high altitude landscapes.",
            "image": "https://images.unsplash.com/photo-1589881133595-a3c085cb731d",
            "rating": 4.8,
            "price": 30000,
            "attractions": ["Pangong Lake", "Nubra Valley", "Leh Palace", "Magnetic Hill"],
            "activities": ["Motorcycle Tours", "Trekking", "Monastery Visits", "Camping"],
            "tags": ["Mountains", "Adventure", "Scenic", "Culture"]
          },
          {
            "id": "9",
            "name": "Udaipur",
            "region": "North India",
            "country": "India",
            "description": "Udaipur, formerly the capital of the Mewar Kingdom, is a city in the western Indian state of Rajasthan. Known as the 'City of Lakes'.",
            "image": "https://images.unsplash.com/photo-1599661046289-e31897846e41",
            "rating": 4.7,
            "price": 22000,
            "attractions": ["Lake Pichola", "City Palace", "Jag Mandir", "Fateh Sagar Lake"],
            "activities": ["Boat Rides", "Palace Tours", "Cultural Shows", "Shopping"],
            "tags": ["Lakes", "Palaces", "Culture", "Romantic"]
          },
          {
            "id": "10",
            "name": "Rishikesh",
            "region": "North India",
            "country": "India",
            "description": "Rishikesh is a city in India's northern state of Uttarakhand, in the Himalayan foothills beside the Ganges River. Known as a center for yoga and meditation.",
            "image": "https://images.unsplash.com/photo-1585516356459-9d7a79952f9b",
            "rating": 4.6,
            "price": 18000,
            "attractions": ["Laxman Jhula", "Triveni Ghat", "Beatles Ashram", "Neelkanth Mahadev Temple"],
            "activities": ["Yoga", "Meditation", "River Rafting", "Camping"],
            "tags": ["Spiritual", "Adventure", "Yoga", "Nature"]
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
      // Use the same destinations as in getDestinations method
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
            "name": "Jaipur",
            "region": "North India",
            "country": "India",
            "description": "Jaipur is the capital of India's Rajasthan state. It evokes the royal family that once ruled the region and that, in 1727, founded what is now called the Old City, or 'Pink City'.",
            "image": "https://images.unsplash.com/photo-1477587458883-47145ed94245?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
            "rating": 4.6,
            "price": 18000,
            "attractions": ["Hawa Mahal", "Amber Fort", "City Palace", "Jantar Mantar"],
            "activities": ["Heritage Tours", "Shopping", "Food Tours", "Elephant Rides"],
            "tags": ["Culture", "Heritage", "History", "Shopping"]
          },
          {
            "id": "4",
            "name": "Kerala",
            "region": "South India",
            "country": "India",
            "description": "Kerala, a state on India's tropical Malabar Coast, has nearly 600km of Arabian Sea shoreline. It's known for its palm-lined beaches and backwaters.",
            "image": "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
            "rating": 4.8,
            "price": 25000,
            "attractions": ["Alleppey Backwaters", "Munnar", "Wayanad", "Kovalam Beach"],
            "activities": ["Houseboat Stay", "Ayurvedic Treatments", "Wildlife Safari", "Tea Plantation Tours"],
            "tags": ["Backwaters", "Nature", "Relaxation", "Ayurveda"]
          },
          {
            "id": "5",
            "name": "Darjeeling",
            "region": "East India",
            "country": "India",
            "description": "Darjeeling is a town in India's West Bengal state, in the Himalayan foothills. Once a summer resort for the British Raj elite.",
            "image": "https://images.unsplash.com/photo-1544181093-c712fb401bdc?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80",
            "rating": 4.5,
            "price": 22000,
            "attractions": ["Tiger Hill", "Batasia Loop", "Darjeeling Himalayan Railway", "Happy Valley Tea Estate"],
            "activities": ["Tea Garden Tours", "Toy Train Ride", "Trekking", "Sunrise Viewing"],
            "tags": ["Mountains", "Tea", "Nature", "Scenic"]
          },
          {
            "id": "6",
            "name": "Varanasi",
            "region": "North India",
            "country": "India",
            "description": "Varanasi is a city in the northern Indian state of Uttar Pradesh dating to the 11th century B.C.E. Regarded as the spiritual capital of India.",
            "image": "https://images.unsplash.com/photo-1561361058-c24cecae35ca",
            "rating": 4.4,
            "price": 16000,
            "attractions": ["Dashashwamedh Ghat", "Kashi Vishwanath Temple", "Sarnath", "Assi Ghat"],
            "activities": ["Boat Rides", "Temple Tours", "Ganga Aarti", "Spiritual Experiences"],
            "tags": ["Spiritual", "Culture", "History", "Religion"]
          },
          {
            "id": "7",
            "name": "Andaman Islands",
            "region": "Bay of Bengal",
            "country": "India",
            "description": "The Andaman Islands are an Indian archipelago in the Bay of Bengal. Known for pristine beaches, coral reefs and water sports.",
            "image": "https://images.unsplash.com/photo-1586094332115-6ca0e9dcd84f",
            "rating": 4.9,
            "price": 35000,
            "attractions": ["Radhanagar Beach", "Cellular Jail", "Ross Island", "Havelock Island"],
            "activities": ["Scuba Diving", "Snorkeling", "Island Hopping", "Beach Activities"],
            "tags": ["Beach", "Islands", "Adventure", "Water Sports"]
          },
          {
            "id": "8",
            "name": "Ladakh",
            "region": "North India",
            "country": "India",
            "description": "Ladakh is a region administered by India as a union territory, and constitutes a part of the larger Kashmir region. Known for high altitude landscapes.",
            "image": "https://images.unsplash.com/photo-1589881133595-a3c085cb731d",
            "rating": 4.8,
            "price": 30000,
            "attractions": ["Pangong Lake", "Nubra Valley", "Leh Palace", "Magnetic Hill"],
            "activities": ["Motorcycle Tours", "Trekking", "Monastery Visits", "Camping"],
            "tags": ["Mountains", "Adventure", "Scenic", "Culture"]
          },
          {
            "id": "9",
            "name": "Udaipur",
            "region": "North India",
            "country": "India",
            "description": "Udaipur, formerly the capital of the Mewar Kingdom, is a city in the western Indian state of Rajasthan. Known as the 'City of Lakes'.",
            "image": "https://images.unsplash.com/photo-1599661046289-e31897846e41",
            "rating": 4.7,
            "price": 22000,
            "attractions": ["Lake Pichola", "City Palace", "Jag Mandir", "Fateh Sagar Lake"],
            "activities": ["Boat Rides", "Palace Tours", "Cultural Shows", "Shopping"],
            "tags": ["Lakes", "Palaces", "Culture", "Romantic"]
          },
          {
            "id": "10",
            "name": "Rishikesh",
            "region": "North India",
            "country": "India",
            "description": "Rishikesh is a city in India's northern state of Uttarakhand, in the Himalayan foothills beside the Ganges River. Known as a center for yoga and meditation.",
            "image": "https://images.unsplash.com/photo-1585516356459-9d7a79952f9b",
            "rating": 4.6,
            "price": 18000,
            "attractions": ["Laxman Jhula", "Triveni Ghat", "Beatles Ashram", "Neelkanth Mahadev Temple"],
            "activities": ["Yoga", "Meditation", "River Rafting", "Camping"],
            "tags": ["Spiritual", "Adventure", "Yoga", "Nature"]
          },
          {
            "id": "11",
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
