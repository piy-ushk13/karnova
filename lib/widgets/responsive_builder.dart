// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:karnova/utils/theme.dart';

/// A widget that builds different layouts based on screen width
class ResponsiveBuilder extends StatelessWidget {
  /// Builder for small screens (mobile)
  final Widget Function(BuildContext) mobileBuilder;
  
  /// Builder for medium screens (tablet)
  final Widget Function(BuildContext)? tabletBuilder;
  
  /// Builder for large screens (desktop)
  final Widget Function(BuildContext)? desktopBuilder;

  const ResponsiveBuilder({
    super.key,
    required this.mobileBuilder,
    this.tabletBuilder,
    this.desktopBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Desktop layout
    if (screenWidth >= AppTheme.largeScreenBreakpoint && desktopBuilder != null) {
      return desktopBuilder!(context);
    }
    
    // Tablet layout
    if (screenWidth >= AppTheme.smallScreenBreakpoint && tabletBuilder != null) {
      return tabletBuilder!(context);
    }
    
    // Mobile layout (default)
    return mobileBuilder(context);
  }
}

/// Extension on BuildContext to easily access screen size information
extension ResponsiveExtension on BuildContext {
  /// Returns true if the screen width is less than the small breakpoint
  bool get isMobile => MediaQuery.of(this).size.width < AppTheme.smallScreenBreakpoint;
  
  /// Returns true if the screen width is between small and large breakpoints
  bool get isTablet => MediaQuery.of(this).size.width >= AppTheme.smallScreenBreakpoint && 
                       MediaQuery.of(this).size.width < AppTheme.largeScreenBreakpoint;
  
  /// Returns true if the screen width is greater than or equal to the large breakpoint
  bool get isDesktop => MediaQuery.of(this).size.width >= AppTheme.largeScreenBreakpoint;
}
