// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/models/itinerary_detail.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/global_navigation.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';
import 'package:karnova/widgets/tips_banner.dart';

// Mock itinerary items
final itineraryItemsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'id': '1',
      'day': 1,
      'title': 'Arrival Day',
      'time': '10:00 AM',
      'description':
          'Arrive at Goa International Airport and check-in to hotel',
      'cost': 5000,
    },
    {
      'id': '2',
      'day': 1,
      'title': 'Beach Visit',
      'time': '2:00 PM',
      'description':
          'Visit Calangute Beach for relaxation and water activities',
      'cost': 1000,
    },
    {
      'id': '3',
      'day': 2,
      'title': 'Fort Aguada',
      'time': '9:00 AM',
      'description':
          'Explore the historic Fort Aguada and enjoy panoramic views',
      'cost': 500,
    },
    {
      'id': '4',
      'day': 2,
      'title': 'Local Cuisine',
      'time': '7:00 PM',
      'description': 'Dinner at a local restaurant to try Goan cuisine',
      'cost': 1500,
    },
    {
      'id': '5',
      'day': 3,
      'title': 'Dudhsagar Falls',
      'time': '8:00 AM',
      'description': 'Day trip to Dudhsagar Falls with guided tour',
      'cost': 3000,
    },
    {
      'id': '6',
      'day': 3,
      'title': 'Departure',
      'time': '8:00 PM',
      'description': 'Check-out from hotel and departure from Goa',
      'cost': 2000,
    },
  ];
});

// Provider for Mumbai itinerary
final mumbaiItineraryProvider = Provider<ItineraryDetail>((ref) {
  return ItineraryDetail.getMumbaiItinerary();
});

// Provider for total budget and spent amount
final budgetProvider = Provider<Map<String, int>>((ref) {
  final items = ref.watch(itineraryItemsProvider);
  final totalSpent = items.fold(0, (sum, item) => sum + (item['cost'] as int));
  return {
    'total': 20000, // Total budget
    'spent': totalSpent, // Amount spent
  };
});

class ItineraryScreen extends ConsumerStatefulWidget {
  const ItineraryScreen({super.key});

  @override
  ConsumerState<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends ConsumerState<ItineraryScreen> {
  @override
  Widget build(BuildContext context) {
    final itinerary = ref.watch(mumbaiItineraryProvider);

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
        child: Column(
          children: [
            // Top navigation for larger screens
            const GlobalNavigation(currentRoute: '/itinerary'),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tips banner at the top
                    const TipsBanner(
                      tip:
                          'Consider visiting Fort Aguada early in the morning to avoid crowds and get the best photos!',
                    ),

                    // Trip Overview Card
                    Padding(
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
                                    style: GoogleFonts.roboto(fontSize: 14.sp),
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
                                    style: GoogleFonts.roboto(fontSize: 14.sp),
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

                    // Highlights Carousel
                    Padding(
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
                                final highlight = itinerary.highlights[index];
                                return Container(
                                  width: 200.w,
                                  margin: EdgeInsets.only(right: 12.w),
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
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
                                            highlight,
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Weather Forecast
                    Padding(
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
                                return Container(
                                  width: 100.w,
                                  margin: EdgeInsets.only(right: 8.w),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
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
                                            _getWeatherIcon(weather.condition),
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
                                            overflow: TextOverflow.ellipsis,
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
                    SizedBox(height: 16.h),

                    // Tabbed Section
                    Padding(
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
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
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
        return ExpansionTile(
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
            style: GoogleFonts.roboto(fontSize: 12.sp, color: Colors.grey[600]),
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
        );
      },
    );
  }

  // Helper method to build Mumbai tour tab with grid layout
  Widget _buildMumbaiTourTab() {
    // List of Mumbai attractions
    final attractions = [
      {
        'name': 'Gateway of India',
        'description': 'Iconic monument built during the British Raj',
        'image': 'https://images.unsplash.com/photo-1570168007204-dfb528c6958f',
        'duration': '2 hours',
        'cost': '₹0',
        'rating': 4.8,
        'category': 'Monument',
      },
      {
        'name': 'Marine Drive',
        'description': 'Scenic 3.6km boulevard along the coast',
        'image': 'https://images.unsplash.com/photo-1570168007418-c1b5dd2cafcc',
        'duration': '1 hour',
        'cost': '₹0',
        'rating': 4.7,
        'category': 'Scenic',
      },
      {
        'name': 'Elephanta Caves',
        'description': 'Ancient cave temples dedicated to Lord Shiva',
        'image': 'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1',
        'duration': '4 hours',
        'cost': '₹600',
        'rating': 4.5,
        'category': 'Heritage',
      },
      {
        'name': 'Chhatrapati Shivaji Terminus',
        'description':
            'Historic railway station and UNESCO World Heritage Site',
        'image': 'https://images.unsplash.com/photo-1529253355930-ddbe423a2ac7',
        'duration': '1 hour',
        'cost': '₹0',
        'rating': 4.6,
        'category': 'Architecture',
      },
      {
        'name': 'Colaba Causeway',
        'description': 'Popular shopping street with various boutiques',
        'image': 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220',
        'duration': '3 hours',
        'cost': 'Varies',
        'rating': 4.4,
        'category': 'Shopping',
      },
      {
        'name': 'Juhu Beach',
        'description': 'Famous beach known for street food and entertainment',
        'image': 'https://images.unsplash.com/photo-1571423154929-b9f3d8b2a5a7',
        'duration': '2 hours',
        'cost': '₹0',
        'rating': 4.3,
        'category': 'Beach',
      },
    ];

    return Column(
      children: [
        // Tour summary card
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.map_outlined,
                          color: AppTheme.primaryColor,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mumbai City Tour',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'A comprehensive tour of Mumbai\'s top attractions',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTourInfoItem(
                        Icons.access_time,
                        '2 Days',
                        'Duration',
                      ),
                      _buildTourInfoItem(
                        Icons.location_on,
                        '6 Places',
                        'Attractions',
                      ),
                      _buildTourInfoItem(
                        Icons.directions_car,
                        '35 km',
                        'Distance',
                      ),
                      _buildTourInfoItem(Icons.star, '4.6', 'Rating'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Attractions grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: attractions.length,
            itemBuilder: (context, index) {
              final attraction = attractions[index];
              return _buildAttractionCard(attraction);
            },
          ),
        ),
      ],
    );
  }

  // Helper method to build tour info item
  Widget _buildTourInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: GoogleFonts.roboto(fontSize: 12.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // Helper method to build attraction card
  Widget _buildAttractionCard(Map<String, dynamic> attraction) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attraction image
          Stack(
            children: [
              Image.network(
                attraction['image'],
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120.h,
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[500],
                      ),
                    ),
                  );
                },
              ),
              // Category badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(150),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    attraction['category'],
                    style: GoogleFonts.roboto(
                      fontSize: 10.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Attraction details
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attraction['name'],
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  attraction['description'],
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          attraction['duration'],
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 12.sp, color: Colors.amber),
                        SizedBox(width: 4.w),
                        Text(
                          attraction['rating'].toString(),
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  attraction['cost'],
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get weather icon
  IconData _getWeatherIcon(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains('sunny')) {
      return Icons.wb_sunny;
    } else if (condition.contains('cloud')) {
      return Icons.cloud;
    } else if (condition.contains('rain')) {
      return Icons.grain;
    } else {
      return Icons.cloud_queue;
    }
  }
}
