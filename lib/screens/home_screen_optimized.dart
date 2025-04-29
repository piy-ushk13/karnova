// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:karnova/controllers/trip_planning_controller.dart';
import 'package:karnova/models/trip.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';

class HomeScreenOptimized extends ConsumerStatefulWidget {
  const HomeScreenOptimized({super.key});

  @override
  ConsumerState<HomeScreenOptimized> createState() =>
      _HomeScreenOptimizedState();
}

class _HomeScreenOptimizedState extends ConsumerState<HomeScreenOptimized> {
  final TextEditingController _sourceController = TextEditingController(
    text: 'Belgaum, Karnataka, India',
  );
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _durationController = TextEditingController(
    text: '3',
  );
  final TextEditingController _travelersController = TextEditingController(
    text: '2',
  );

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  TravelPreference _selectedPreference = TravelPreference.adventure;
  bool _isInternational = false;

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    _durationController.dispose();
    _travelersController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _planTrip() {
    // Validate form fields
    if (_sourceController.text.isEmpty ||
        _destinationController.text.isEmpty ||
        _budgetController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _travelersController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Add a small delay to ensure keyboard is dismissed before showing loading animation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      // Get the trip planning controller
      final controller = ref.read(tripPlanningControllerProvider);

      // Generate itinerary using the controller
      controller.generateItinerary(
        fromLocation: _sourceController.text,
        location: _destinationController.text,
        startDate: _selectedDate,
        duration: int.parse(_durationController.text),
        budget: int.parse(_budgetController.text),
        isInternational: _isInternational,
        travelers: int.parse(_travelersController.text),
      );

      // Navigate to itinerary screen
      context.go('/itinerary');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.white, size: 20.sp),
            SizedBox(width: 4.w),
            Text(
              'Belgaum, Karnataka',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              Color(0xCC4E79FF), // 80% opacity primary color
              Color(0x994E79FF), // 60% opacity primary color
              Colors.white,
            ],
            stops: [0.0, 0.3, 0.5, 0.9],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // Welcome message
                  Text(
                    'Where to next?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Trip planner card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000), // 5% opacity black
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plan Your Trip',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'serif',
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Source field
                        TextField(
                          controller: _sourceController,
                          decoration: InputDecoration(
                            labelText: 'From',
                            hintText: 'Your starting point',
                            prefixIcon: const Icon(Icons.flight_takeoff),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Destination field
                        TextField(
                          controller: _destinationController,
                          decoration: InputDecoration(
                            labelText: 'To',
                            hintText: 'Your destination',
                            prefixIcon: const Icon(Icons.flight_land),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Date picker
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Date',
                                hintText: 'Select date',
                                prefixIcon: const Icon(Icons.calendar_today),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              controller: TextEditingController(
                                text: DateFormat(
                                  'MMM dd, yyyy',
                                ).format(_selectedDate),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Budget field
                        TextField(
                          controller: _budgetController,
                          decoration: InputDecoration(
                            labelText: 'Budget (₹)',
                            hintText: 'Enter your budget',
                            prefixIcon: const Icon(Icons.currency_rupee),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.h),

                        // Duration field
                        TextField(
                          controller: _durationController,
                          decoration: InputDecoration(
                            labelText: 'Duration (days)',
                            hintText: 'Enter number of days',
                            prefixIcon: const Icon(Icons.calendar_month),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.h),

                        // Travelers field
                        TextField(
                          controller: _travelersController,
                          decoration: InputDecoration(
                            labelText: 'Travelers',
                            hintText: 'Enter number of travelers',
                            prefixIcon: const Icon(Icons.people),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.h),

                        // International travel switch
                        Row(
                          children: [
                            Text(
                              'International Travel',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Switch(
                              value: _isInternational,
                              onChanged: (value) {
                                setState(() {
                                  _isInternational = value;
                                });
                              },
                              activeColor: AppTheme.primaryColor,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Travel preference
                        Text(
                          'Travel Preference',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Travel preference chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children:
                                TravelPreference.values.map((preference) {
                                  final isSelected =
                                      _selectedPreference == preference;
                                  return Padding(
                                    padding: EdgeInsets.only(right: 8.w),
                                    child: ChoiceChip(
                                      label: Text(
                                        preference.name,
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                      selected: isSelected,
                                      backgroundColor: Colors.grey[100],
                                      selectedColor: AppTheme.primaryColor,
                                      onSelected: (selected) {
                                        if (selected) {
                                          setState(() {
                                            _selectedPreference = preference;
                                          });
                                        }
                                      },
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Plan trip button
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton.icon(
                            onPressed: _planTrip,
                            icon: const Icon(Icons.explore),
                            label: const Text('Plan My Trip'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Popular destinations section
                  Text(
                    'Popular Destinations',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'serif',
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Popular destinations cards
                  SizedBox(
                    height: 180.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildDestinationCard(
                          'Goa',
                          'Beach Paradise',
                          'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80',
                        ),
                        _buildDestinationCard(
                          'Manali',
                          'Mountain Retreat',
                          'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80',
                        ),
                        _buildDestinationCard(
                          'Jaipur',
                          'Pink City',
                          'https://images.unsplash.com/photo-1599661046289-e31897846e41?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationCard(
    String name,
    String description,
    String imageUrl,
  ) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // 5% opacity black
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // Image
            Image.network(
              imageUrl,
              width: 160.w,
              height: 180.h,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 160.w,
                  height: 180.h,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                );
              },
            ),

            // Gradient overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xB3000000),
                  ], // 70% opacity black
                  stops: [0.6, 1.0],
                ),
              ),
            ),

            // Text
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: const Color(0xCCFFFFFF), // 80% opacity white
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
