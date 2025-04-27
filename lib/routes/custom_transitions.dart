// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transitions for the app
class CustomPageTransitions {
  /// Creates a smooth sliding transition between pages
  static CustomTransitionPage<T> slideTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    bool rightToLeft = true,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = Offset(rightToLeft ? 1.0 : -1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        // Fade transition combined with slide
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation.drive(
              Tween<double>(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve)),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Determines the transition direction based on route paths
  static bool determineTransitionDirection(String currentPath, String nextPath) {
    // Define the order of main routes
    final routeOrder = [
      '/',
      '/destinations',
      '/stays',
      '/itinerary',
      '/profile',
    ];
    
    // Find indices of current and next routes
    final currentIndex = routeOrder.indexOf(currentPath);
    final nextIndex = routeOrder.indexOf(nextPath);
    
    // If either route is not in the main routes, default to right-to-left
    if (currentIndex == -1 || nextIndex == -1) {
      return true;
    }
    
    // Return true for right-to-left (next index is greater than current)
    return nextIndex > currentIndex;
  }
}
