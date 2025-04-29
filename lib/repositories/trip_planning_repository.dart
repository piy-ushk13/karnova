// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karnova/models/itinerary_detail.dart';
import 'package:karnova/services/gemini_ai_service.dart';
import 'package:uuid/uuid.dart';

// Provider for the trip planning repository
final tripPlanningRepositoryProvider = Provider<TripPlanningRepository>((ref) {
  final geminiAIService = ref.read(geminiAIServiceProvider);
  return TripPlanningRepository(geminiAIService: geminiAIService);
});

// Provider for the generated itinerary detail
final generatedItineraryDetailProvider = StateProvider<ItineraryDetail?>((ref) => null);

class TripPlanningRepository {
  final GeminiAIService geminiAIService;
  final _uuid = const Uuid();

  TripPlanningRepository({required this.geminiAIService});

  // Generate an itinerary using the AI service and convert it to ItineraryDetail
  Future<ItineraryDetail> generateItinerary({
    required String fromLocation,
    required String location,
    required DateTime startDate,
    required int duration,
    required int budget,
    required bool isInternational,
    required int travelers,
  }) async {
    try {
      // Generate the AI itinerary
      final aiItinerary = await geminiAIService.generateItinerary(
        fromLocation: fromLocation,
        location: location,
        startDate: startDate,
        duration: duration,
        budget: budget,
        isInternational: isInternational,
      );

      // Calculate end date
      final endDate = startDate.add(Duration(days: duration));

      // Create a title and subtitle
      final title = 'Your $location Adventure';
      final subtitle = '$duration days of exciting exploration';

      // Generate a unique ID
      final id = _uuid.v4();

      // Convert to ItineraryDetail format
      final itineraryJson = aiItinerary.toItineraryDetailJson(
        id: id,
        title: title,
        subtitle: subtitle,
        startDate: startDate,
        endDate: endDate,
        travelers: travelers,
        budget: budget,
        startLocation: fromLocation,
      );

      // Create the ItineraryDetail object
      return ItineraryDetail.fromJson(itineraryJson);
    } catch (e) {
      if (kDebugMode) {
        print('Error in generateItinerary: $e');
      }
      rethrow;
    }
  }

  // Edit an existing itinerary
  Future<ItineraryDetail> editItinerary({
    required ItineraryDetail currentItinerary,
    String? newLocation,
    DateTime? newStartDate,
    int? newDuration,
    int? newBudget,
    int? newTravelers,
  }) async {
    try {
      // If no changes, return the current itinerary
      if (newLocation == null && 
          newStartDate == null && 
          newDuration == null && 
          newBudget == null && 
          newTravelers == null) {
        return currentItinerary;
      }

      // Calculate the parameters for regeneration
      final location = newLocation ?? currentItinerary.title.split(' ')[1];
      final startDate = newStartDate ?? currentItinerary.startDate;
      final duration = newDuration ?? currentItinerary.durationInDays;
      final budget = newBudget ?? currentItinerary.budget;
      final travelers = newTravelers ?? currentItinerary.travelers;
      
      // Determine if it's international based on the destination
      final isInternational = !location.toLowerCase().contains('india');

      // Generate a new itinerary
      return await generateItinerary(
        fromLocation: currentItinerary.startLocation,
        location: location,
        startDate: startDate,
        duration: duration,
        budget: budget,
        isInternational: isInternational,
        travelers: travelers,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error in editItinerary: $e');
      }
      rethrow;
    }
  }
}
