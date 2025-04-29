// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:karnova/widgets/glassmorphic_container.dart';

class CustomBottomNavbar extends StatelessWidget {
  final String currentRoute;

  const CustomBottomNavbar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 60.h,
      borderRadius: 30.r,
      blur: 10, // Reduced blur for better performance
      border: 1.0, // Thinner border
      borderColor: Colors.white,
      backgroundColor: const Color(0xFFB1CBFF),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (!isSelected) {
            try {
              context.go(route);
            } catch (e) {
              // Handle routes that don't exist yet
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$label coming soon!')));
            }
          }
        },
        customBorder: const CircleBorder(),
        splashColor: const Color(0x1A000000), // ~0.1 opacity black
        highlightColor: const Color(0x0D000000), // ~0.05 opacity black
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow:
                  isSelected
                      ? const [
                        BoxShadow(
                          color: Color(0x1A000000), // ~0.1 opacity black
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ]
                      : null,
            ),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  fontSize: isSelected ? 24.sp : 22.sp,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey,
                  size: isSelected ? 24.sp : 22.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
