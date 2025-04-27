// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavbar extends StatelessWidget {
  final String currentRoute;

  const CustomBottomNavbar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(context, Icons.home, '/', 'Home'),
          _buildNavBarItem(
            context,
            Icons.explore,
            '/destinations',
            'Destinations',
          ),
          _buildNavBarItem(context, Icons.bookmark, '/bookings', 'Bookings'),
          _buildNavBarItem(context, Icons.map, '/itinerary', 'Itinerary'),
          _buildNavBarItem(context, Icons.person, '/profile', 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(
    BuildContext context,
    IconData icon,
    String route,
    String label,
  ) {
    final bool isSelected = currentRoute == route;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: isSelected ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (!isSelected) {
                try {
                  context.go(route);
                } catch (e) {
                  // Handle routes that don't exist yet
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$label coming soon!')),
                  );
                }
              }
            },
            customBorder: const CircleBorder(),
            splashColor: Colors.black.withAlpha(26), // ~0.1 opacity
            highlightColor: Colors.black.withAlpha(13), // ~0.05 opacity
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Color.lerp(Colors.transparent, Colors.black, value),
                  shape: BoxShape.circle,
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: Colors.black.withAlpha(
                                (26 * value).toInt(),
                              ), // ~0.1 opacity
                              blurRadius: 4 * value,
                              spreadRadius: 1 * value,
                            ),
                          ]
                          : null,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Color.lerp(Colors.grey, Colors.white, value),
                    size: 22.sp + (2.sp * value), // Slightly grow when selected
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
