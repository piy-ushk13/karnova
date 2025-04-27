// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karnova/models/area_of_interest.dart';
import 'package:karnova/models/transport_mode.dart';
import 'package:karnova/models/trip.dart';

// Provider for storing the current trip being planned
final currentTripProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

// Provider for selected transport modes
final selectedTransportModesProvider = StateProvider<List<TransportMode>>((ref) {
  // Default to flight as the initial selection
  return [TransportMode.flight];
});

// Provider for areas of interest
final areasOfInterestProvider = StateProvider<List<AreaOfInterest>>((ref) {
  return AreaOfInterest.getCommonAreas();
});

// Provider for selected areas of interest
final selectedAreasProvider = StateProvider<List<String>>((ref) {
  // Default to empty list
  return [];
});

// Provider to check if trip confirmation is complete
final isTripConfirmedProvider = StateProvider<bool>((ref) => false);
