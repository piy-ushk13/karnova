// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karnova/routes/custom_transitions.dart';
import 'package:karnova/screens/about_screen.dart';
import 'package:karnova/screens/ai_trip_planner_screen.dart';
import 'package:karnova/screens/contact_screen.dart';
import 'package:karnova/screens/contacts_management_screen.dart';
import 'package:karnova/screens/destinations_screen_animated.dart';
import 'package:karnova/screens/destination_detail_animated.dart';
import 'package:karnova/screens/bookings_screen.dart';
import 'package:karnova/screens/home_screen_modern.dart';
import 'package:karnova/screens/home_screen_new_design.dart';
import 'package:karnova/screens/home_screen_optimized.dart';
import 'package:karnova/screens/itinerary_screen_animated.dart';
import 'package:karnova/screens/profile_screen_redesign.dart';
import 'package:karnova/screens/results_screen.dart';
import 'package:karnova/screens/tips_screen.dart';
import 'package:karnova/screens/trip_confirmation_screen.dart';

// Track the current route for determining transition direction
String _currentRoute = '/';

// Helper function to determine transition direction based on route order
bool _determineTransitionDirection(GoRouterState state) {
  final nextRoute = state.matchedLocation;

  // Define the order of main routes
  final routeOrder = [
    '/',
    '/destinations',
    '/bookings',
    '/trip-confirmation',
    '/itinerary',
    '/profile',
  ];

  // Find indices of current and next routes
  final currentIndex = routeOrder.indexOf(_currentRoute);
  final nextIndex = routeOrder.indexOf(nextRoute);

  // If either route is not in the main routes, default to right-to-left
  if (currentIndex == -1 || nextIndex == -1) {
    return true;
  }

  // Return true for right-to-left (next index is greater than current)
  return nextIndex > currentIndex;
}

// App router configuration using go_router
final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  // Update current route on route changes
  redirect: (context, state) {
    _currentRoute = state.matchedLocation;
    return null;
  },
  routes: [
    // Home screen route (Optimized Design)
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const HomeScreenOptimized(),
            rightToLeft: true,
          ),
    ),

    // Modern home screen route (accessible via /modern-home)
    GoRoute(
      path: '/modern-home',
      name: 'modern-home',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const HomeScreenModern(),
            rightToLeft: true,
          ),
    ),

    // Old home screen route (accessible via /old-home)
    GoRoute(
      path: '/old-home',
      name: 'old-home',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const HomeScreenNewDesign(),
            rightToLeft: true,
          ),
    ),

    // AI Trip Planner screen route
    GoRoute(
      path: '/ai-trip-planner',
      name: 'ai-trip-planner',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const AITripPlannerScreen(),
            rightToLeft: true,
          ),
    ),

    // Destinations screen route
    GoRoute(
      path: '/destinations',
      name: 'destinations',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const DestinationsScreenAnimated(),
            rightToLeft: _determineTransitionDirection(state),
          ),
    ),

    // Results screen route
    GoRoute(
      path: '/results',
      name: 'results',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const ResultsScreen(),
            rightToLeft: true,
          ),
    ),

    // Detail screen route with parameter
    GoRoute(
      path: '/detail/:id',
      name: 'detail',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return CustomPageTransitions.slideTransition(
          context: context,
          state: state,
          child: DestinationDetailAnimated(destinationId: id),
          rightToLeft: true,
        );
      },
    ),

    // Itinerary screen route
    GoRoute(
      path: '/itinerary',
      name: 'itinerary',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const ItineraryScreenAnimated(),
            rightToLeft: _determineTransitionDirection(state),
          ),
    ),

    // Tips screen route
    GoRoute(
      path: '/tips',
      name: 'tips',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const TipsScreen(),
            rightToLeft: true,
          ),
    ),

    // Profile screen route
    GoRoute(
      path: '/profile',
      name: 'profile',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const ProfileScreen(),
            rightToLeft: _determineTransitionDirection(state),
          ),
    ),

    // About screen route
    GoRoute(
      path: '/about',
      name: 'about',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const AboutScreen(),
            rightToLeft: true,
          ),
    ),

    // Contact screen route
    GoRoute(
      path: '/contact',
      name: 'contact',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const ContactScreen(),
            rightToLeft: true,
          ),
    ),

    // Bookings screen route
    GoRoute(
      path: '/bookings',
      name: 'bookings',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const BookingsScreen(),
            rightToLeft: _determineTransitionDirection(state),
          ),
    ),

    // Trip confirmation screen route
    GoRoute(
      path: '/trip-confirmation',
      name: 'trip-confirmation',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const TripConfirmationScreen(),
            rightToLeft: _determineTransitionDirection(state),
          ),
    ),

    // Contacts management screen route
    GoRoute(
      path: '/contacts',
      name: 'contacts',
      pageBuilder:
          (context, state) => CustomPageTransitions.slideTransition(
            context: context,
            state: state,
            child: const ContactsManagementScreen(),
            rightToLeft: true,
          ),
    ),
  ],

  // Error page for invalid routes
  errorBuilder:
      (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Oops! The page you are looking for does not exist.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
);
