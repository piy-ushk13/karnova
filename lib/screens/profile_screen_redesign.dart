// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';
import 'dart:math' as math;

// Mock data for visited places
final visitedPlacesProvider = Provider<List<VisitedPlace>>((ref) {
  return [
    VisitedPlace(
      id: '1',
      name: 'Bali',
      country: 'Indonesia',
      date: 'March 2023',
      image:
          'https://images.unsplash.com/photo-1537996194471-e657df975ab4?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      rating: 4.8,
    ),
    VisitedPlace(
      id: '2',
      name: 'Paris',
      country: 'France',
      date: 'December 2022',
      image:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      rating: 4.5,
    ),
    VisitedPlace(
      id: '3',
      name: 'Tokyo',
      country: 'Japan',
      date: 'August 2022',
      image:
          'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      rating: 4.9,
    ),
    VisitedPlace(
      id: '4',
      name: 'New York',
      country: 'USA',
      date: 'May 2022',
      image:
          'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      rating: 4.6,
    ),
    VisitedPlace(
      id: '5',
      name: 'Sydney',
      country: 'Australia',
      date: 'January 2022',
      image:
          'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      rating: 4.7,
    ),
  ];
});

// Mock data for travel stats
final travelStatsProvider = Provider<TravelStats>((ref) {
  return TravelStats(
    countriesVisited: 12,
    citiesVisited: 28,
    totalTrips: 15,
    totalDistance: 48250,
  );
});

// Mock data for upcoming trips
final upcomingTripsProvider = Provider<List<UpcomingTrip>>((ref) {
  return [
    UpcomingTrip(
      id: '1',
      destination: 'Santorini',
      country: 'Greece',
      startDate: 'June 15, 2023',
      endDate: 'June 25, 2023',
      image:
          'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
    ),
    UpcomingTrip(
      id: '2',
      destination: 'Kyoto',
      country: 'Japan',
      startDate: 'September 10, 2023',
      endDate: 'September 20, 2023',
      image:
          'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
    ),
  ];
});

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visitedPlaces = ref.watch(visitedPlacesProvider);
    final travelStats = ref.watch(travelStatsProvider);
    final upcomingTrips = ref.watch(upcomingTripsProvider);

    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit profile coming soon!')),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/profile'),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              slivers: [
                // Profile header
                SliverToBoxAdapter(child: _buildProfileHeader()),

                // Travel stats
                SliverToBoxAdapter(child: _buildTravelStats(travelStats)),

                // Section title for visited places
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Places I\'ve Visited',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('View all places coming soon!'),
                              ),
                            );
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.blue[300],
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Visited places grid
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final place = visitedPlaces[index];
                      return _buildVisitedPlaceCard(place, index);
                    }, childCount: visitedPlaces.length),
                  ),
                ),

                // Section title for upcoming trips
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Upcoming Trips',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Add new trip coming soon!'),
                              ),
                            );
                          },
                          child: Text(
                            'Add New',
                            style: TextStyle(
                              color: Colors.blue[300],
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Upcoming trips list
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: upcomingTrips.length,
                      itemBuilder: (context, index) {
                        final trip = upcomingTrips[index];
                        return _buildUpcomingTripCard(trip);
                      },
                    ),
                  ),
                ),

                // Settings and preferences
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Settings & Preferences',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildSettingsTile(
                              Icons.notifications_outlined,
                              'Notifications',
                              'Manage your notification preferences',
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Notifications settings coming soon!',
                                    ),
                                  ),
                                );
                              },
                            ),
                            _buildSettingsTile(
                              Icons.people,
                              'Contacts',
                              'Manage family and friends for trip planning',
                              () {
                                context.go('/contacts');
                              },
                            ),
                            _buildSettingsTile(
                              Icons.language,
                              'Language',
                              'Change app language',
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Language settings coming soon!',
                                    ),
                                  ),
                                );
                              },
                            ),
                            _buildSettingsTile(
                              Icons.help_outline,
                              'Help & Support',
                              'Get assistance with the app',
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Help & Support coming soon!',
                                    ),
                                  ),
                                );
                              },
                            ),
                            _buildSettingsTile(
                              Icons.logout,
                              'Logout',
                              'Sign out of your account',
                              () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        backgroundColor: const Color(
                                          0xFF2A2A2A,
                                        ),
                                        title: const Text('Logout'),
                                        content: const Text(
                                          'Are you sure you want to logout?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Logout functionality coming soon!',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text('Logout'),
                                          ),
                                        ],
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom padding
                SliverToBoxAdapter(child: SizedBox(height: 24.h)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Profile image with animated blue border
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: const [
                      Color(0xFF4E79FF), // Light blue
                      Color(0xFF0D47A1), // Dark blue
                      Color(0xFF4E79FF), // Light blue
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    startAngle: 0,
                    endAngle: math.pi * 2 * value,
                    transform: GradientRotation(value * math.pi * 2),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF1E1E1E),
                    backgroundImage: const NetworkImage(
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16.h),

          // User name with shimmer effect
          ShimmerText(
            text: 'John Doe',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 4.h),
          Text(
            'Travel Enthusiast',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[400]),
          ),
          SizedBox(height: 8.h),
          Text(
            'john.doe@example.com',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
          ),
          SizedBox(height: 16.h),

          // Follow and message buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit profile coming soon!')),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share profile coming soon!')),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTravelStats(TravelStats stats) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Travel Statistics',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    stats.countriesVisited.toString(),
                    'Countries',
                    Icons.public,
                    Colors.blue[300]!,
                  ),
                  _buildStatItem(
                    stats.citiesVisited.toString(),
                    'Cities',
                    Icons.location_city,
                    Colors.purple[300]!,
                  ),
                  _buildStatItem(
                    stats.totalTrips.toString(),
                    'Trips',
                    Icons.flight,
                    Colors.orange[300]!,
                  ),
                  _buildStatItem(
                    '${(stats.totalDistance / 1000).toStringAsFixed(1)}k',
                    'Kilometers',
                    Icons.timeline,
                    Colors.green[300]!,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color.withAlpha(51), // ~0.2 opacity
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey[400])),
      ],
    );
  }

  Widget _buildVisitedPlaceCard(VisitedPlace place, int index) {
    // Staggered animation for grid items
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = index * 0.2;
        final start = delay;
        final end = math.min(start + 0.4, 1.0);

        final curvedAnimation = CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOut),
        );

        return Transform.scale(
          scale: Tween<double>(begin: 0.8, end: 1.0).evaluate(curvedAnimation),
          child: Opacity(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).evaluate(curvedAnimation),
            child: child,
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.network(
              place.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(179),
                  ], // ~0.7 opacity
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    place.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 12.sp),
                      SizedBox(width: 4.w),
                      Text(
                        place.country,
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        place.date,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[300],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 14.sp),
                          SizedBox(width: 2.w),
                          Text(
                            place.rating.toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTripCard(UpcomingTrip trip) {
    return Container(
      width: 280.w,
      margin: EdgeInsets.only(right: 16.w),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background image
            Image.network(
              trip.image,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  height: 200.h,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),

            // Gradient overlay
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(179),
                  ], // ~0.7 opacity
                ),
              ),
            ),

            // Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.destination,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          trip.country,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${trip.startDate} - ${trip.endDate}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                          ),
                          child: const Text('View Details'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[300]),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[500])),
      trailing: const Icon(Icons.chevron_right, color: Colors.white),
      onTap: onTap,
    );
  }
}

// Shimmer text effect
class ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const ShimmerText({super.key, required this.text, required this.style});

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [Colors.white, Colors.blue, Colors.white],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(_controller.value * 2 * math.pi),
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style.copyWith(color: Colors.white),
          ),
        );
      },
    );
  }
}

// Data models
class VisitedPlace {
  final String id;
  final String name;
  final String country;
  final String date;
  final String image;
  final double rating;

  VisitedPlace({
    required this.id,
    required this.name,
    required this.country,
    required this.date,
    required this.image,
    required this.rating,
  });
}

class TravelStats {
  final int countriesVisited;
  final int citiesVisited;
  final int totalTrips;
  final int totalDistance;

  TravelStats({
    required this.countriesVisited,
    required this.citiesVisited,
    required this.totalTrips,
    required this.totalDistance,
  });
}

class UpcomingTrip {
  final String id;
  final String destination;
  final String country;
  final String startDate;
  final String endDate;
  final String image;

  UpcomingTrip({
    required this.id,
    required this.destination,
    required this.country,
    required this.startDate,
    required this.endDate,
    required this.image,
  });
}
