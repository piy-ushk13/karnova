// Augment: TripOnBuddy Website → Flutter App
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:karnova/controllers/trip_planning_controller.dart';
import 'package:karnova/models/trip.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';
import 'package:karnova/widgets/loading_overlay.dart';

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
    // Get loading state from provider
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

    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Please wait a few seconds while we generate your itinerary...',
      child: Scaffold(
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
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
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

                    // Welcome message with illustrations
                    Row(
                      children: [
                        // Text part
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Where to next?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'serif',
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Plan your perfect journey',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(
                                    204,
                                  ), // 80% opacity
                                  fontSize: 16.sp,
                                  fontFamily: 'serif',
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Traveler illustration that blends with the background
                        Container(
                          width: 80.w,
                          height: 80.w,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Sky background with subtle gradient
                              Container(
                                width: 80.w,
                                height: 80.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.r),
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.lightBlue.shade100.withAlpha(150),
                                      Colors.lightBlue.shade200.withAlpha(100),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.2, 0.6, 1.0],
                                  ),
                                ),
                              ),

                              // Beach sand
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100.withAlpha(180),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(40.r),
                                      bottomRight: Radius.circular(40.r),
                                    ),
                                  ),
                                ),
                              ),

                              // Small huts in background
                              Positioned(
                                bottom: 20.h,
                                left: 10.w,
                                child: Container(
                                  width: 12.w,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: Colors.brown.shade300.withAlpha(200),
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // Roof
                                      Positioned(
                                        top: -5.h,
                                        left: -2.w,
                                        child: Container(
                                          width: 16.w,
                                          height: 6.h,
                                          decoration: BoxDecoration(
                                            color: Colors.brown.shade700
                                                .withAlpha(200),
                                            borderRadius: BorderRadius.circular(
                                              3.r,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Second hut
                              Positioned(
                                bottom: 18.h,
                                right: 15.w,
                                child: Container(
                                  width: 10.w,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    color: Colors.brown.shade400.withAlpha(200),
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // Roof
                                      Positioned(
                                        top: -4.h,
                                        left: -2.w,
                                        child: Container(
                                          width: 14.w,
                                          height: 5.h,
                                          decoration: BoxDecoration(
                                            color: Colors.brown.shade800
                                                .withAlpha(200),
                                            borderRadius: BorderRadius.circular(
                                              3.r,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Palm tree
                              Positioned(
                                bottom: 25.h,
                                left: 55.w,
                                child: Container(
                                  width: 4.w,
                                  height: 15.h,
                                  decoration: BoxDecoration(
                                    color: Colors.brown.shade600.withAlpha(200),
                                    borderRadius: BorderRadius.circular(1.r),
                                  ),
                                ),
                              ),

                              // Palm leaves
                              Positioned(
                                bottom: 38.h,
                                left: 48.w,
                                child: Container(
                                  width: 18.w,
                                  height: 8.h,
                                  child: Stack(
                                    children: List.generate(5, (index) {
                                      final angle =
                                          (index * (3.14159 / 5)) - 0.5;
                                      return Transform.rotate(
                                        angle: angle,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: 12.w,
                                            height: 2.5.h,
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade700
                                                  .withAlpha(200),
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),

                              // Traveler figure
                              Positioned(
                                bottom: 10.h,
                                left: 30.w,
                                child: Container(
                                  width: 20.w,
                                  height: 30.h,
                                  child: Stack(
                                    children: [
                                      // Body with yellow shirt
                                      Positioned(
                                        top: 8.h,
                                        left: 5.w,
                                        child: Container(
                                          width: 10.w,
                                          height: 15.h,
                                          decoration: BoxDecoration(
                                            color: Colors.yellow.shade300,
                                            borderRadius: BorderRadius.circular(
                                              5.r,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Head
                                      Positioned(
                                        top: 0,
                                        left: 5.w,
                                        child: Container(
                                          width: 10.w,
                                          height: 10.w,
                                          decoration: BoxDecoration(
                                            color: Colors.pink.shade200,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),

                                      // Hat
                                      Positioned(
                                        top: -2.h,
                                        left: 3.w,
                                        child: Container(
                                          width: 14.w,
                                          height: 4.h,
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade300,
                                            borderRadius: BorderRadius.circular(
                                              7.r,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Red shorts
                                      Positioned(
                                        top: 23.h,
                                        left: 5.w,
                                        child: Container(
                                          width: 10.w,
                                          height: 7.h,
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade400,
                                            borderRadius: BorderRadius.circular(
                                              3.r,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Left arm with bag
                                      Positioned(
                                        top: 12.h,
                                        left: 0,
                                        child: Container(
                                          width: 5.w,
                                          height: 3.h,
                                          decoration: BoxDecoration(
                                            color: Colors.yellow.shade300,
                                            borderRadius: BorderRadius.circular(
                                              1.r,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Right arm with bag
                                      Positioned(
                                        top: 12.h,
                                        right: 0,
                                        child: Container(
                                          width: 5.w,
                                          height: 3.h,
                                          decoration: BoxDecoration(
                                            color: Colors.yellow.shade300,
                                            borderRadius: BorderRadius.circular(
                                              1.r,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Left luggage bag
                                      Positioned(
                                        top: 15.h,
                                        left: -5.w,
                                        child: Container(
                                          width: 8.w,
                                          height: 10.h,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade600,
                                            borderRadius: BorderRadius.circular(
                                              2.r,
                                            ),
                                          ),
                                          child: Center(
                                            child: Container(
                                              width: 4.w,
                                              height: 1.h,
                                              color: Colors.yellow.shade600,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Right luggage bag
                                      Positioned(
                                        top: 15.h,
                                        right: -5.w,
                                        child: Container(
                                          width: 8.w,
                                          height: 10.h,
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade600,
                                            borderRadius: BorderRadius.circular(
                                              2.r,
                                            ),
                                          ),
                                          child: Center(
                                            child: Container(
                                              width: 4.w,
                                              height: 1.h,
                                              color: Colors.yellow.shade600,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Legs
                                      Positioned(
                                        bottom: 0,
                                        left: 7.w,
                                        child: Container(
                                          width: 3.w,
                                          height: 5.h,
                                          decoration: BoxDecoration(
                                            color: Colors.pink.shade200,
                                            borderRadius: BorderRadius.circular(
                                              1.r,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 7.w,
                                        child: Container(
                                          width: 3.w,
                                          height: 5.h,
                                          decoration: BoxDecoration(
                                            color: Colors.pink.shade200,
                                            borderRadius: BorderRadius.circular(
                                              1.r,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Subtle clouds
                              ...List.generate(3, (index) {
                                return Positioned(
                                  top: 10.h + (index * 10.h),
                                  left: 10.w + (index * 20.w),
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(begin: 0, end: 1),
                                    duration: Duration(seconds: 3 + index),
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(
                                          sin(value * 3.14159 * 2) * 3,
                                          0,
                                        ),
                                        child: Opacity(
                                          opacity: 0.6,
                                          child: Container(
                                            width: 15.w,
                                            height: 6.h,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withAlpha(
                                                150,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
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
                          Row(
                            children: [
                              // Title
                              Text(
                                'Plan Your Trip',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'serif',
                                ),
                              ),
                            ],
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

                    // Popular destinations section with illustration
                    Row(
                      children: [
                        // Title
                        Text(
                          'Popular Destinations',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: 'serif',
                          ),
                        ),
                        SizedBox(width: 12.w),

                        // Surreal globe illustration
                        SizedBox(
                          width: 60.w,
                          height: 60.w,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer space glow
                              Container(
                                width: 60.w,
                                height: 60.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.purple.shade900.withAlpha(100),
                                      Colors.indigo.shade900.withAlpha(50),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.2, 0.6, 1.0],
                                  ),
                                ),
                              ),

                              // Stars
                              ...List.generate(10, (index) {
                                final random = Random();
                                final size = 2.0 + random.nextDouble() * 2;
                                final posX = random.nextDouble() * 60;
                                final posY = random.nextDouble() * 60;

                                return Positioned(
                                  left: posX.w,
                                  top: posY.h,
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(begin: 0.3, end: 1.0),
                                    duration: Duration(
                                      milliseconds: 500 + (index * 200),
                                    ),
                                    builder: (context, value, child) {
                                      return Opacity(
                                        opacity: value,
                                        child: Container(
                                          width: size.w,
                                          height: size.w,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),

                              // Globe with continents
                              Container(
                                width: 32.w,
                                height: 32.w,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.lightBlue.shade200,
                                      Colors.blue.shade500,
                                    ],
                                    stops: const [0.3, 1.0],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.shade700.withAlpha(
                                        100,
                                      ),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Continents
                                    Positioned(
                                      top: 8.h,
                                      left: 8.w,
                                      child: Container(
                                        width: 10.w,
                                        height: 6.h,
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade700,
                                          borderRadius: BorderRadius.circular(
                                            3.r,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10.h,
                                      right: 5.w,
                                      child: Container(
                                        width: 12.w,
                                        height: 8.h,
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade700,
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Equator line
                                    Positioned(
                                      top: 16.h,
                                      left: 0,
                                      child: Container(
                                        width: 32.w,
                                        height: 1.h,
                                        color: Colors.white.withAlpha(100),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Orbiting airplane
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0, end: 2 * pi),
                                duration: const Duration(seconds: 4),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      cos(value) * 20,
                                      sin(value) * 10,
                                    ),
                                    child: Transform.rotate(
                                      angle: value + pi / 2,
                                      child: Icon(
                                        Icons.flight,
                                        color: Colors.white,
                                        size: 14.sp,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
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
