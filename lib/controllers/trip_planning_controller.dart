// Augment: TripOnBuddy Website → Flutter App
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karnova/models/itinerary_detail.dart';
import 'package:karnova/repositories/trip_planning_repository.dart';

// Provider for the trip planning controller
final tripPlanningControllerProvider = Provider<TripPlanningController>((ref) {
  final repository = ref.read(tripPlanningRepositoryProvider);
  return TripPlanningController(ref: ref, repository: repository);
});

// Provider for the loading state
final tripPlanningLoadingProvider = StateProvider<bool>((ref) => false);

// Provider for error messages
final tripPlanningErrorProvider = StateProvider<String?>((ref) => null);

// Provider for success messages
final tripPlanningSuccessProvider = StateProvider<String?>((ref) => null);

class TripPlanningController {
  final Ref _ref;
  final TripPlanningRepository _repository;

  TripPlanningController({
    required Ref ref,
    required TripPlanningRepository repository,
  }) : _ref = ref,
       _repository = repository;

  // Generate a new itinerary
  Future<void> generateItinerary({
    required String fromLocation,
    required String location,
    required DateTime startDate,
    required int duration,
    required int budget,
    required bool isInternational,
    required int travelers,
  }) async {
    int retryCount = 0;
    const maxRetries = 2;

    while (retryCount <= maxRetries) {
      try {
        // Set loading state to true
        _ref.read(tripPlanningLoadingProvider.notifier).state = true;
        // Clear any previous errors
        _ref.read(tripPlanningErrorProvider.notifier).state = null;

        // Generate the itinerary
        final itinerary = await _repository.generateItinerary(
          fromLocation: fromLocation,
          location: location,
          startDate: startDate,
          duration: duration,
          budget: budget,
          isInternational: isInternational,
          travelers: travelers,
        );

        // Validate the itinerary has required data
        if (itinerary.dailyItineraries.isEmpty) {
          throw Exception("Generated itinerary has no daily plans");
        }

        // Update the generated itinerary provider
        _ref.read(generatedItineraryDetailProvider.notifier).state = itinerary;

        // Show success message
        _ref.read(tripPlanningSuccessProvider.notifier).state =
            'Itinerary generated successfully';

        // Set a timer to clear the success message after 5 seconds
        Timer(const Duration(seconds: 5), () {
          if (_ref.read(tripPlanningSuccessProvider) != null) {
            _ref.read(tripPlanningSuccessProvider.notifier).state = null;
          }
        });

        // If we get here, the operation was successful
        break;
      } catch (e) {
        if (kDebugMode) {
          print('Error generating itinerary (attempt ${retryCount + 1}): $e');
        }

        // If we've reached the max retries, set the error message
        if (retryCount == maxRetries) {
          // Set error message
          _ref.read(tripPlanningErrorProvider.notifier).state =
              'Failed to generate itinerary. Please try again.';
        } else {
          // Otherwise, increment the retry count and try again
          retryCount++;
          continue;
        }
      } finally {
        // Only set loading to false if we're done with all retries
        if (retryCount == maxRetries ||
            _ref.read(generatedItineraryDetailProvider) != null) {
          _ref.read(tripPlanningLoadingProvider.notifier).state = false;
        }
      }
    }
  }

  // Edit an existing itinerary
  Future<void> editItinerary({
    required ItineraryDetail currentItinerary,
    String? newLocation,
    DateTime? newStartDate,
    int? newDuration,
    int? newBudget,
    int? newTravelers,
  }) async {
    try {
      // Set loading state to true
      _ref.read(tripPlanningLoadingProvider.notifier).state = true;
      // Clear any previous errors
      _ref.read(tripPlanningErrorProvider.notifier).state = null;

      // Edit the itinerary
      final updatedItinerary = await _repository.editItinerary(
        currentItinerary: currentItinerary,
        newLocation: newLocation,
        newStartDate: newStartDate,
        newDuration: newDuration,
        newBudget: newBudget,
        newTravelers: newTravelers,
      );

      // Update the generated itinerary provider
      _ref.read(generatedItineraryDetailProvider.notifier).state =
          updatedItinerary;

      // Show success message
      _ref.read(tripPlanningSuccessProvider.notifier).state =
          'Itinerary updated successfully';

      // Set a timer to clear the success message after 5 seconds
      Timer(const Duration(seconds: 5), () {
        if (_ref.read(tripPlanningSuccessProvider) != null) {
          _ref.read(tripPlanningSuccessProvider.notifier).state = null;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error editing itinerary: $e');
      }
      // Set error message
      _ref.read(tripPlanningErrorProvider.notifier).state =
          'Failed to update itinerary: ${e.toString()}';
    } finally {
      // Set loading state to false
      _ref.read(tripPlanningLoadingProvider.notifier).state = false;
    }
  }

  // Clear the current itinerary
  void clearItinerary() {
    _ref.read(generatedItineraryDetailProvider.notifier).state = null;
    _ref.read(tripPlanningErrorProvider.notifier).state = null;
    _ref.read(tripPlanningSuccessProvider.notifier).state = null;
  }
}
