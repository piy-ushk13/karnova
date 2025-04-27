// Augment: TripOnBuddy Website → Flutter App
import 'package:karnova/models/weather.dart';

class ItineraryDetail {
  final String id;
  final String title;
  final String subtitle;
  final DateTime startDate;
  final DateTime endDate;
  final int travelers;
  final int budget;
  final String startLocation;
  final List<String> highlights;
  final List<WeatherForecast> weatherForecast;
  final List<DailyItinerary> dailyItineraries;
  final List<Accommodation> accommodations;
  final List<Transportation> transportations;
  final List<String> travelTips;

  ItineraryDetail({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.startDate,
    required this.endDate,
    required this.travelers,
    required this.budget,
    required this.startLocation,
    required this.highlights,
    required this.weatherForecast,
    required this.dailyItineraries,
    required this.accommodations,
    required this.transportations,
    required this.travelTips,
  });

  factory ItineraryDetail.fromJson(Map<String, dynamic> json) {
    return ItineraryDetail(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      travelers: json['travelers'],
      budget: json['budget'],
      startLocation: json['startLocation'],
      highlights: List<String>.from(json['highlights']),
      weatherForecast: (json['weatherForecast'] as List)
          .map((e) => WeatherForecast.fromJson(e))
          .toList(),
      dailyItineraries: (json['dailyItineraries'] as List)
          .map((e) => DailyItinerary.fromJson(e))
          .toList(),
      accommodations: (json['accommodations'] as List)
          .map((e) => Accommodation.fromJson(e))
          .toList(),
      transportations: (json['transportations'] as List)
          .map((e) => Transportation.fromJson(e))
          .toList(),
      travelTips: List<String>.from(json['travelTips']),
    );
  }

  Map<String, dynamic> toJson() {
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
      'weatherForecast': weatherForecast.map((e) => e.toJson()).toList(),
      'dailyItineraries': dailyItineraries.map((e) => e.toJson()).toList(),
      'accommodations': accommodations.map((e) => e.toJson()).toList(),
      'transportations': transportations.map((e) => e.toJson()).toList(),
      'travelTips': travelTips,
    };
  }

  // Get duration in days
  int get durationInDays {
    return endDate.difference(startDate).inDays + 1;
  }

  // Get formatted date range
  String get dateRange {
    final startMonth = _getMonthName(startDate.month);
    final endMonth = _getMonthName(endDate.month);
    
    if (startDate.month == endDate.month && startDate.year == endDate.year) {
      return '${startDate.day} – ${endDate.day} $startMonth, ${startDate.year}';
    } else if (startDate.year == endDate.year) {
      return '${startDate.day} $startMonth – ${endDate.day} $endMonth, ${startDate.year}';
    } else {
      return '${startDate.day} $startMonth, ${startDate.year} – ${endDate.day} $endMonth, ${endDate.year}';
    }
  }

  // Helper method to get month name
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  // Mock data for Mumbai itinerary
  static ItineraryDetail getMumbaiItinerary() {
    return ItineraryDetail(
      id: 'mumbai-001',
      title: 'Your Mumbai Adventure',
      subtitle: '5 days of exciting exploration in the city of dreams',
      startDate: DateTime(2025, 10, 15),
      endDate: DateTime(2025, 10, 20),
      travelers: 2,
      budget: 45000,
      startLocation: 'Mumbai, India',
      highlights: [
        'Gateway of India',
        'Marine Drive',
        'Elephanta Caves',
        'CST Railway Station',
        'Juhu Beach',
        'Siddhivinayak Temple',
      ],
      weatherForecast: WeatherService.getMockForecast(),
      dailyItineraries: [
        DailyItinerary(
          day: 1,
          title: 'Arrival in Mumbai',
          description: 'Arrive at Chhatrapati Shivaji International Airport and check-in to your hotel. Relax and prepare for your Mumbai adventure.',
          activities: [
            Activity(
              time: '14:00',
              title: 'Airport Arrival',
              description: 'Arrive at Mumbai Airport',
              cost: 0,
            ),
            Activity(
              time: '16:00',
              title: 'Hotel Check-in',
              description: 'Check in to your hotel and freshen up',
              cost: 8000,
            ),
            Activity(
              time: '19:00',
              title: 'Welcome Dinner',
              description: 'Enjoy a welcome dinner at a local restaurant',
              cost: 2000,
            ),
          ],
        ),
        DailyItinerary(
          day: 2,
          title: 'South Mumbai Exploration',
          description: 'Explore the historic and cultural landmarks of South Mumbai, including the iconic Gateway of India and the magnificent CST Railway Station.',
          activities: [
            Activity(
              time: '09:00',
              title: 'Gateway of India',
              description: 'Visit the iconic Gateway of India',
              cost: 0,
            ),
            Activity(
              time: '11:00',
              title: 'Elephanta Caves',
              description: 'Take a ferry to the Elephanta Caves',
              cost: 1500,
            ),
            Activity(
              time: '15:00',
              title: 'CST Railway Station',
              description: 'Visit the UNESCO World Heritage Site',
              cost: 0,
            ),
            Activity(
              time: '18:00',
              title: 'Marine Drive',
              description: 'Evening walk along the Queen\'s Necklace',
              cost: 0,
            ),
          ],
        ),
        DailyItinerary(
          day: 3,
          title: 'Cultural Mumbai',
          description: 'Immerse yourself in the cultural side of Mumbai with visits to temples, museums, and local markets.',
          activities: [
            Activity(
              time: '08:00',
              title: 'Siddhivinayak Temple',
              description: 'Morning visit to the famous temple',
              cost: 100,
            ),
            Activity(
              time: '11:00',
              title: 'Chhatrapati Shivaji Museum',
              description: 'Explore the city\'s premier museum',
              cost: 500,
            ),
            Activity(
              time: '14:00',
              title: 'Crawford Market',
              description: 'Shopping at the historic market',
              cost: 1000,
            ),
          ],
        ),
        DailyItinerary(
          day: 4,
          title: 'Mumbai Beaches',
          description: 'Relax and enjoy the beautiful beaches of Mumbai, from the popular Juhu Beach to the serene Aksa Beach.',
          activities: [
            Activity(
              time: '10:00',
              title: 'Juhu Beach',
              description: 'Visit the famous Juhu Beach',
              cost: 0,
            ),
            Activity(
              time: '13:00',
              title: 'Lunch at Beachside Cafe',
              description: 'Enjoy seafood at a beachside restaurant',
              cost: 1500,
            ),
            Activity(
              time: '16:00',
              title: 'Bandra Bandstand',
              description: 'Evening stroll at Bandra Bandstand',
              cost: 0,
            ),
          ],
        ),
        DailyItinerary(
          day: 5,
          title: 'Departure',
          description: 'Wrap up your Mumbai adventure with some last-minute shopping and prepare for departure.',
          activities: [
            Activity(
              time: '10:00',
              title: 'Souvenir Shopping',
              description: 'Last-minute shopping for souvenirs',
              cost: 2000,
            ),
            Activity(
              time: '13:00',
              title: 'Hotel Check-out',
              description: 'Check out from your hotel',
              cost: 0,
            ),
            Activity(
              time: '16:00',
              title: 'Airport Departure',
              description: 'Depart from Mumbai Airport',
              cost: 0,
            ),
          ],
        ),
      ],
      accommodations: [
        Accommodation(
          name: 'Taj Mahal Palace',
          address: 'Apollo Bunder, Colaba, Mumbai',
          checkIn: DateTime(2025, 10, 15),
          checkOut: DateTime(2025, 10, 20),
          cost: 25000,
          rating: 5.0,
          amenities: ['Free Wi-Fi', 'Swimming Pool', 'Spa', 'Restaurant'],
        ),
      ],
      transportations: [
        Transportation(
          type: 'Flight',
          from: 'Delhi',
          to: 'Mumbai',
          departureTime: DateTime(2025, 10, 15, 12, 0),
          arrivalTime: DateTime(2025, 10, 15, 14, 0),
          cost: 8000,
          provider: 'Air India',
        ),
        Transportation(
          type: 'Flight',
          from: 'Mumbai',
          to: 'Delhi',
          departureTime: DateTime(2025, 10, 20, 16, 0),
          arrivalTime: DateTime(2025, 10, 20, 18, 0),
          cost: 8000,
          provider: 'IndiGo',
        ),
      ],
      travelTips: [
        'Mumbai has a well-connected local train system, but it can get very crowded during peak hours.',
        'Always carry a bottle of water and stay hydrated, especially during summer months.',
        'Try the famous street food like Vada Pav and Pav Bhaji, but choose hygienic vendors.',
        'Use ride-hailing apps like Uber or Ola for convenient transportation around the city.',
        'Visit Marine Drive in the evening to witness the beautiful sunset and the Queen\'s Necklace view.',
      ],
    );
  }
}

class DailyItinerary {
  final int day;
  final String title;
  final String description;
  final List<Activity> activities;

  DailyItinerary({
    required this.day,
    required this.title,
    required this.description,
    required this.activities,
  });

  factory DailyItinerary.fromJson(Map<String, dynamic> json) {
    return DailyItinerary(
      day: json['day'],
      title: json['title'],
      description: json['description'],
      activities: (json['activities'] as List)
          .map((e) => Activity.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'title': title,
      'description': description,
      'activities': activities.map((e) => e.toJson()).toList(),
    };
  }
}

class Activity {
  final String time;
  final String title;
  final String description;
  final int cost;

  Activity({
    required this.time,
    required this.title,
    required this.description,
    required this.cost,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      time: json['time'],
      title: json['title'],
      description: json['description'],
      cost: json['cost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'title': title,
      'description': description,
      'cost': cost,
    };
  }
}

class Accommodation {
  final String name;
  final String address;
  final DateTime checkIn;
  final DateTime checkOut;
  final int cost;
  final double rating;
  final List<String> amenities;

  Accommodation({
    required this.name,
    required this.address,
    required this.checkIn,
    required this.checkOut,
    required this.cost,
    required this.rating,
    required this.amenities,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      name: json['name'],
      address: json['address'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      cost: json['cost'],
      rating: json['rating'].toDouble(),
      amenities: List<String>.from(json['amenities']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'cost': cost,
      'rating': rating,
      'amenities': amenities,
    };
  }
}

class Transportation {
  final String type;
  final String from;
  final String to;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int cost;
  final String provider;

  Transportation({
    required this.type,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.cost,
    required this.provider,
  });

  factory Transportation.fromJson(Map<String, dynamic> json) {
    return Transportation(
      type: json['type'],
      from: json['from'],
      to: json['to'],
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
      cost: json['cost'],
      provider: json['provider'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'from': from,
      'to': to,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'cost': cost,
      'provider': provider,
    };
  }
}
