// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/controllers/trip_planning_controller.dart';
import 'package:karnova/models/itinerary_detail.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/animated_content.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';
import 'package:karnova/widgets/itinerary_map.dart';
import 'package:karnova/widgets/loading_overlay.dart';
import 'package:karnova/widgets/tips_banner.dart';

import 'package:karnova/repositories/trip_planning_repository.dart';

// Provider for all itineraries
final itinerariesProvider = Provider<List<ItineraryDetail>>((ref) {
  // Get the generated itinerary if available
  final generatedItinerary = ref.watch(generatedItineraryDetailProvider);

  // Create a list with the generated itinerary (if available) and the mock itinerary
  final itineraries = <ItineraryDetail>[];

  // Add the generated itinerary if available
  if (generatedItinerary != null) {
    itineraries.add(generatedItinerary);

    // Log that we're using a real generated itinerary
    if (kDebugMode) {
      print('Using real generated itinerary: ${generatedItinerary.title}');
      print('Number of days: ${generatedItinerary.dailyItineraries.length}');
      print(
        'Number of activities on day 1: ${generatedItinerary.dailyItineraries.first.activities.length}',
      );
    }
  }

  // If no itineraries are available, add a default mock itinerary
  // This ensures we always have at least one itinerary to display
  if (itineraries.isEmpty) {
    if (kDebugMode) {
      print('No generated itinerary available, using mock itinerary');
    }
    itineraries.add(ItineraryDetail.getMumbaiItinerary());
  }

  return itineraries;
});

class ItineraryScreenAnimated extends ConsumerStatefulWidget {
  const ItineraryScreenAnimated({super.key});

  @override
  ConsumerState<ItineraryScreenAnimated> createState() =>
      _ItineraryScreenAnimatedState();
}

class _ItineraryScreenAnimatedState
    extends ConsumerState<ItineraryScreenAnimated>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itineraries = ref.watch(itinerariesProvider);
    final isLoading = ref.watch(tripPlanningLoadingProvider);
    final errorMessage = ref.watch(tripPlanningErrorProvider);
    final successMessage = ref.watch(tripPlanningSuccessProvider);

    // Show success message if available
    if (successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
      });
    }

    // Show error message if available
    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      });
    }

    // We'll always show the itinerary screen, regardless of confirmation status
    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Please wait a few seconds while we generate your itinerary...',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Your Itinerary',
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            // Edit Trip Button
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Trip',
              onPressed: () {
                if (_tabController.index == 0 && itineraries.isNotEmpty) {
                  _showEditTripDialog(context, itineraries[0]);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No trips to edit'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
            ),
            // Share Button
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Share Itinerary',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Share functionality coming soon!'),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: AppTheme.primaryColor,
            tabs: const [Tab(text: 'Upcoming Trips'), Tab(text: 'Past Trips')],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavbar(
          currentRoute: '/itinerary',
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Upcoming Trips Tab
              itineraries.isEmpty
                  ? _buildEmptyTripsView(isUpcoming: true)
                  : _buildUpcomingTripsTab(itineraries[0]),

              // Past Trips Tab
              _buildPastTripsTab(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build upcoming trips tab
  Widget _buildUpcomingTripsTab(ItineraryDetail itinerary) {
    return AnimatedContent(
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
                  elevation: 4,
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
                            Icon(
                              Icons.location_on,
                              color: AppTheme.primaryColor,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                itinerary
                                    .title, // Using title instead of destination
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            // Edit Trip Button
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: AppTheme.primaryColor,
                                size: 20.sp,
                              ),
                              onPressed: () {
                                _showEditTripDialog(context, itinerary);
                              },
                              tooltip: 'Edit Trip',
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoItem(
                              Icons.calendar_today,
                              'Duration',
                              '${itinerary.dailyItineraries.length} days', // Using dailyItineraries.length instead of duration
                            ),
                            _buildInfoItem(
                              Icons.people,
                              'Travelers',
                              '2 people', // Hardcoded value
                            ),
                            _buildInfoItem(
                              Icons.account_balance_wallet,
                              'Budget',
                              '₹${itinerary.totalBudget}', // Using totalBudget
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildWeatherItem('Day 1', 'Sunny', '32°C'),
                            _buildWeatherItem('Day 2', 'Cloudy', '28°C'),
                            _buildWeatherItem('Day 3', 'Rainy', '25°C'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Manage Itinerary Section
            AnimatedContent(
              delay: const Duration(milliseconds: 300),
              child: Padding(
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
                        Text(
                          'Manage Your Trip',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildManageButton(
                              icon: Icons.edit,
                              label: 'Edit Trip',
                              onTap:
                                  () => _showEditTripDialog(context, itinerary),
                            ),
                            _buildManageButton(
                              icon: Icons.add_circle_outline,
                              label: 'Add Activity',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Add activity feature coming soon!',
                                    ),
                                  ),
                                );
                              },
                            ),
                            _buildManageButton(
                              icon: Icons.delete_outline,
                              label: 'Delete Trip',
                              onTap: () {
                                _showDeleteConfirmationDialog(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Itinerary Tabs
            AnimatedContent(
              delay: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: AppTheme.primaryColor,
                        unselectedLabelColor: Colors.grey[600],
                        indicatorColor: AppTheme.primaryColor,
                        tabs: const [
                          Tab(text: 'Daily Itinerary'),
                          Tab(text: 'Trip Map'),
                        ],
                      ),
                      SizedBox(
                        height: 400.h,
                        child: TabBarView(
                          children: [
                            _buildDailyItineraryTab(itinerary),
                            _buildItineraryMapTab(itinerary),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build empty trips view
  Widget _buildEmptyTripsView({required bool isUpcoming}) {
    return AnimatedContent(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.flight_takeoff : Icons.history,
              size: 80.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 24.h),
            Text(
              isUpcoming ? 'No Upcoming Trips' : 'No Past Trips',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              isUpcoming
                  ? 'Plan a trip to see it here'
                  : 'Your completed trips will appear here',
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () {
                if (isUpcoming) {
                  // Navigate to trip planner
                  context.go('/');
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Plan a New Trip'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build past trips tab
  Widget _buildPastTripsTab() {
    return _buildEmptyTripsView(isUpcoming: false);
  }

  // Helper method to build info item
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20.sp),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.roboto(fontSize: 12.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Helper method to build weather item
  Widget _buildWeatherItem(String day, String condition, String temp) {
    return Column(
      children: [
        Text(
          day,
          style: GoogleFonts.roboto(fontSize: 12.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 4.h),
        Icon(
          _getWeatherIcon(condition),
          color: AppTheme.primaryColor,
          size: 20.sp,
        ),
        SizedBox(height: 2.h),
        Text(
          temp,
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
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

  // Helper method to build manage button
  Widget _buildManageButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 24.sp),
            SizedBox(height: 8.h),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Delete Trip',
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this trip? This action cannot be undone.',
            style: GoogleFonts.roboto(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Trip deleted successfully!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Show edit trip dialog
  void _showEditTripDialog(BuildContext context, ItineraryDetail itinerary) {
    // Controllers for text fields
    final titleController = TextEditingController(text: itinerary.title);
    final startDateController = TextEditingController(
      text:
          "${itinerary.startDate.day}/${itinerary.startDate.month}/${itinerary.startDate.year}",
    );
    final endDateController = TextEditingController(
      text:
          "${itinerary.endDate.day}/${itinerary.endDate.month}/${itinerary.endDate.year}",
    );
    final budgetController = TextEditingController(
      text: itinerary.budget.toString(),
    );
    final travelersController = TextEditingController(
      text: itinerary.travelers.toString(),
    );

    // Selected dates
    DateTime selectedStartDate = itinerary.startDate;
    DateTime selectedEndDate = itinerary.endDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Edit Trip',
                style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trip Title
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Trip Title',
                        labelStyle: TextStyle(color: Colors.black87),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Start Date
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedStartDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null && picked != selectedStartDate) {
                          setState(() {
                            selectedStartDate = picked;
                            startDateController.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: startDateController,
                          decoration: InputDecoration(
                            labelText: 'Start Date',
                            labelStyle: TextStyle(color: Colors.black87),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // End Date
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedEndDate,
                          firstDate: selectedStartDate,
                          lastDate: DateTime(2030),
                        );
                        if (picked != null && picked != selectedEndDate) {
                          setState(() {
                            selectedEndDate = picked;
                            endDateController.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: endDateController,
                          decoration: InputDecoration(
                            labelText: 'End Date',
                            labelStyle: TextStyle(color: Colors.black87),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Budget
                    TextField(
                      controller: budgetController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Budget (₹)',
                        labelStyle: TextStyle(color: Colors.black87),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Travelers
                    TextField(
                      controller: travelersController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Number of Travelers',
                        labelStyle: TextStyle(color: Colors.black87),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Here you would update the itinerary with the new values
                    // For now, we'll just show a success message
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Trip updated successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
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
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                // Day header
                ExpansionTile(
                  title: Text(
                    'Day ${day.day}: ${day.title}',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: Colors.black,
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
                  children: [
                    // Map showing the day's route
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Map title
                          Row(
                            children: [
                              Icon(
                                Icons.map,
                                size: 18.sp,
                                color: AppTheme.primaryColor,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Day ${day.day} Route Map',
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          // Map widget
                          ItineraryMap(dailyItinerary: day),
                          SizedBox(height: 16.h),

                          // Activities header
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 18.sp,
                                color: AppTheme.primaryColor,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Day ${day.day} Schedule',
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          // Activities list
                          ...day.activities.map(
                            (activity) => ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                              ),
                              leading: Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withAlpha(26),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    activity.time,
                                    style: GoogleFonts.roboto(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                activity.title,
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                activity.description,
                                style: GoogleFonts.roboto(
                                  fontSize: 12.sp,
                                  color: Colors.black87,
                                ),
                              ),
                              trailing: Text(
                                '₹${activity.cost}',
                                style: GoogleFonts.roboto(
                                  fontSize: 12.sp,
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build itinerary map tab
  Widget _buildItineraryMapTab(ItineraryDetail itinerary) {
    if (kDebugMode) {
      print('Building itinerary map for ${itinerary.title}');
      print('Number of days: ${itinerary.dailyItineraries.length}');
      print(
        'Number of activities on day 1: ${itinerary.dailyItineraries.first.activities.length}',
      );
    }

    return AnimatedContent(
      delay: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Trip Map',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ItineraryMap(
              destination:
                  itinerary.title.split(
                    ' ',
                  )[1], // Extract destination from title
              activities:
                  itinerary.dailyItineraries
                      .expand((day) => day.activities)
                      .map(
                        (activity) => activity.title,
                      ) // Use title instead of location
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // This method has been replaced by _buildItineraryMapTab
  // Keeping the comment for documentation purposes
}
