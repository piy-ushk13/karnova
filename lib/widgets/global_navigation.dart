// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:karnova/utils/theme.dart';

/// Global navigation component that adapts to screen size
/// Shows a top app bar on larger screens and animated bottom nav bar on all screens
class GlobalNavigation extends StatelessWidget {
  final String currentRoute;

  const GlobalNavigation({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    // Use responsive builder to determine layout
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen =
            constraints.maxWidth >= AppTheme.largeScreenBreakpoint;

        if (isLargeScreen) {
          // Top app bar for larger screens
          return _buildTopAppBar(context);
        } else {
          // Return empty container as we'll use bottom nav for mobile
          return const SizedBox.shrink();
        }
      },
    );
  }

  // Top app bar for larger screens
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 60.h,
      color: AppTheme.surfaceColor,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          // Logo
          Text(
            'TripOnBuddy',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

          // Navigation links
          _buildNavLink(context, 'Home', '/', Icons.home),
          SizedBox(width: 24.w),
          _buildNavLink(
            context,
            'Destinations',
            '/destinations',
            Icons.explore,
          ),
          SizedBox(width: 24.w),
          _buildNavLink(context, 'Stays', '/stays', Icons.hotel),
          SizedBox(width: 24.w),
          _buildNavLink(context, 'Itinerary', '/itinerary', Icons.map),
          SizedBox(width: 24.w),
          _buildNavLink(context, 'About', '/about', Icons.info),
          SizedBox(width: 24.w),
          _buildNavLink(context, 'Contact', '/contact', Icons.email),
          SizedBox(width: 24.w),
          _buildNavLink(context, 'Profile', '/profile', Icons.person),
        ],
      ),
    );
  }

  // Animated bottom navigation bar for all screen sizes
  static Widget buildBottomNavigationBar(
    BuildContext context,
    String currentRoute,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _getSelectedIndex(currentRoute),
          selectedItemColor: AppTheme.secondaryColor,
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: (index) => _onItemTapped(context, index),
          items: [
            _buildBottomNavItem(Icons.home, 'Home', currentRoute == '/'),
            _buildBottomNavItem(
              Icons.explore,
              'Destinations',
              currentRoute == '/destinations',
            ),
            _buildBottomNavItem(Icons.hotel, 'Stays', currentRoute == '/stays'),
            _buildBottomNavItem(
              Icons.map,
              'Itinerary',
              currentRoute == '/itinerary',
            ),
            _buildBottomNavItem(
              Icons.person,
              'Profile',
              currentRoute == '/profile',
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build animated bottom navigation items with enhanced animations
  static BottomNavigationBarItem _buildBottomNavItem(
    IconData icon,
    String label,
    bool isSelected,
  ) {
    return BottomNavigationBarItem(
      icon: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: isSelected ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Color.fromRGBO(
                255,
                90,
                95, // Hardcoded values for #FF5A5F
                value * 0.15, // Animated opacity
              ),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: Color.fromRGBO(255, 90, 95, 0.2),
                          blurRadius: 4 * value,
                          spreadRadius: 1 * value,
                        ),
                      ]
                      : null,
            ),
            child: Transform.scale(
              scale: 1.0 + (value * 0.1), // Subtle scale animation
              child: Icon(
                icon,
                color: Color.lerp(Colors.black, AppTheme.secondaryColor, value),
              ),
            ),
          );
        },
      ),
      label: label,
      activeIcon: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 90, 95, 0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppTheme.secondaryColor),
            ),
          );
        },
      ),
    );
  }

  // Helper method to get the selected index for bottom navigation
  static int _getSelectedIndex(String currentRoute) {
    switch (currentRoute) {
      case '/':
        return 0;
      case '/destinations':
        return 1;
      case '/stays':
        return 2;
      case '/itinerary':
        return 3;
      case '/profile':
        return 4;
      default:
        return 0;
    }
  }

  // Helper method to handle bottom navigation item taps
  static void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/destinations');
        break;
      case 2:
        context.go('/stays');
        break;
      case 3:
        context.go('/itinerary');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  // Helper method to build a navigation link for top app bar
  Widget _buildNavLink(
    BuildContext context,
    String title,
    String route,
    IconData icon,
  ) {
    final isActive = currentRoute == route;

    return InkWell(
      onTap: () => context.go(route),
      child: Row(
        children: [
          Icon(
            icon,
            color: isActive ? AppTheme.secondaryColor : Colors.black87,
            size: 20.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isActive ? AppTheme.secondaryColor : Colors.black,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isActive)
            Container(
              margin: EdgeInsets.only(left: 4.w),
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
