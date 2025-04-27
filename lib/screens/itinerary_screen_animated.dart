// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/models/itinerary_detail.dart';
import 'package:karnova/providers/trip_providers.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/animated_content.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';
import 'package:karnova/widgets/tips_banner.dart';

// Provider for Mumbai itinerary
final mumbaiItineraryProvider = Provider<ItineraryDetail>((ref) {
  return ItineraryDetail.getMumbaiItinerary();
});

class ItineraryScreenAnimated extends ConsumerStatefulWidget {
  const ItineraryScreenAnimated({super.key});

  @override
  ConsumerState<ItineraryScreenAnimated> createState() =>
      _ItineraryScreenAnimatedState();
}

class _ItineraryScreenAnimatedState
    extends ConsumerState<ItineraryScreenAnimated> {
  @override
  Widget build(BuildContext context) {
    final itinerary = ref.watch(mumbaiItineraryProvider);
    final isTripConfirmed = ref.watch(isTripConfirmedProvider);
    final tripData = ref.watch(currentTripProvider);

    // If trip is not confirmed and there's no trip data, redirect to home
    if (!isTripConfirmed && tripData == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If trip is not confirmed but there's trip data, redirect to confirmation
    if (!isTripConfirmed && tripData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/trip-confirmation');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If trip is confirmed, allow access to itinerary

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Itinerary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share functionality coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/itinerary'),
      body: SafeArea(
        child: AnimatedContent(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tips banner at the top
                      AnimatedContent(
                        delay: const Duration(milliseconds: 100),
                        child: const TipsBanner(
                          tip:
                              'Consider visiting Fort Aguada early in the morning to avoid crowds and get the best photos!',
                        ),
                      ),

                      // Trip Overview Card
                      AnimatedContent(
                        delay: const Duration(milliseconds: 200),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itinerary.title,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    itinerary.subtitle,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'October 15 – October 20, 2025',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.sp,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        size: 16.sp,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '${itinerary.travelers} Travelers',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      Icon(
                                        Icons.account_balance_wallet,
                                        size: 16.sp,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '₹${itinerary.budget} Budget',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      Icon(
                                        Icons.location_on,
                                        size: 16.sp,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: Text(
                                          'From ${itinerary.startLocation}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 14.sp,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Highlights Carousel
                      AnimatedContent(
                        delay: const Duration(milliseconds: 300),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Highlights',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              SizedBox(
                                height: 150.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: itinerary.highlights.length,
                                  itemBuilder: (context, index) {
                                    final highlight =
                                        itinerary.highlights[index];
                                    return AnimatedContent(
                                      delay: Duration(
                                        milliseconds: 400 + (index * 100),
                                      ),
                                      slideBegin: const Offset(1.0, 0.0),
                                      child: Container(
                                        width: 200.w,
                                        margin: EdgeInsets.only(right: 12.w),
                                        child: Card(
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              // Placeholder image with gradient overlay
                                              Container(
                                                color: Colors.grey[300],
                                                child: Center(
                                                  child: Icon(
                                                    Icons.image,
                                                    size: 40.sp,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ),
                                              // Gradient overlay
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.black.withAlpha(
                                                        179,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Caption
                                              Positioned(
                                                bottom: 12,
                                                left: 12,
                                                right: 12,
                                                child: Text(
                                                  highlight,
                                                  style: GoogleFonts.roboto(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.sp,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Weather Forecast
                      AnimatedContent(
                        delay: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Weather Forecast',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              SizedBox(
                                height: 100.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: itinerary.weatherForecast.length,
                                  itemBuilder: (context, index) {
                                    final weather =
                                        itinerary.weatherForecast[index];
                                    return AnimatedContent(
                                      delay: Duration(
                                        milliseconds: 600 + (index * 100),
                                      ),
                                      slideBegin: const Offset(0.0, 0.5),
                                      child: Container(
                                        width: 100.w,
                                        margin: EdgeInsets.only(right: 8.w),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.w),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${weather.date.day}/${weather.date.month}',
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  '${weather.temperature}°C',
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                                Icon(
                                                  _getWeatherIcon(
                                                    weather.condition,
                                                  ),
                                                  size: 20.sp,
                                                  color: AppTheme.primaryColor,
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  weather.condition,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 10.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Tabbed Section
                      AnimatedContent(
                        delay: const Duration(milliseconds: 700),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: DefaultTabController(
                            length: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TabBar(
                                  isScrollable: true,
                                  labelColor: AppTheme.primaryColor,
                                  unselectedLabelColor: Colors.grey[600],
                                  indicatorColor: AppTheme.primaryColor,
                                  tabs: const [
                                    Tab(text: 'Mumbai Tour'),
                                    Tab(text: 'Daily Itinerary'),
                                    Tab(text: 'Accommodation'),
                                    Tab(text: 'Transportation'),
                                    Tab(text: 'Travel Tips'),
                                  ],
                                ),
                                SizedBox(
                                  height: 300.h,
                                  child: TabBarView(
                                    children: [
                                      // Mumbai Tour Tab
                                      _buildMumbaiTourTab(),

                                      // Daily Itinerary Tab
                                      _buildDailyItineraryTab(itinerary),

                                      // Accommodation Tab
                                      Center(
                                        child: Text(
                                          'Accommodation content coming soon',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),

                                      // Transportation Tab
                                      Center(
                                        child: Text(
                                          'Transportation content coming soon',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),

                                      // Travel Tips Tab
                                      Center(
                                        child: Text(
                                          'Travel Tips content coming soon',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build daily itinerary tab
  Widget _buildDailyItineraryTab(ItineraryDetail itinerary) {
    return ListView.builder(
      itemCount: itinerary.dailyItineraries.length,
      itemBuilder: (context, index) {
        final day = itinerary.dailyItineraries[index];
        return AnimatedContent(
          delay: Duration(milliseconds: 800 + (index * 100)),
          slideBegin: const Offset(0.3, 0.0),
          child: ExpansionTile(
            title: Text(
              'Day ${day.day}: ${day.title}',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            subtitle: Text(
              day.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            children:
                day.activities.map((activity) {
                  return ListTile(
                    leading: Text(
                      activity.time,
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: Text(
                      activity.title,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      activity.description,
                      style: GoogleFonts.roboto(fontSize: 12.sp),
                    ),
                    trailing: Text(
                      '₹${activity.cost}',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  // Helper method to build Mumbai tour tab
  Widget _buildMumbaiTourTab() {
    return AnimatedContent(
      delay: const Duration(milliseconds: 800),
      child: GridView.builder(
        padding: EdgeInsets.all(8.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          final attractions = [
            'Gateway of India',
            'Marine Drive',
            'Elephanta Caves',
            'Chhatrapati Shivaji Terminus',
            'Juhu Beach',
            'Sanjay Gandhi National Park',
          ];

          return AnimatedContent(
            delay: Duration(milliseconds: 900 + (index * 100)),
            slideBegin: const Offset(0.0, 0.5),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder image
                  Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 40.sp,
                        color: Colors.grey[400],
                      ),
                    ),
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
                        ],
                      ),
                    ),
                  ),
                  // Caption
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Text(
                      attractions[index],
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper method to get weather icon
  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.water_drop;
      case 'stormy':
        return Icons.thunderstorm;
      default:
        return Icons.wb_sunny;
    }
  }
}
