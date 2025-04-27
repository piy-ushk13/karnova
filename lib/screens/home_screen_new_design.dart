// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:karnova/models/trip.dart';
import 'package:karnova/providers/trip_providers.dart';
import 'package:karnova/services/api_service.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/animated_content.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';

class HomeScreenNewDesign extends ConsumerStatefulWidget {
  const HomeScreenNewDesign({super.key});

  @override
  ConsumerState<HomeScreenNewDesign> createState() =>
      _HomeScreenNewDesignState();
}

class _HomeScreenNewDesignState extends ConsumerState<HomeScreenNewDesign> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  TravelPreference _selectedPreference = TravelPreference.adventure;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Ocean',
    'Mountains',
    'Desert',
    'Forest',
    'City',
  ];

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _planTrip() async {
    if (_sourceController.text.isEmpty ||
        _destinationController.text.isEmpty ||
        _budgetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final apiService = ref.read(apiServiceProvider);
      final result = await apiService.planTrip(
        source: _sourceController.text,
        destination: _destinationController.text,
        departureDate: _selectedDate,
        budget: int.parse(_budgetController.text),
        preference: _selectedPreference.name,
      );

      // Check if widget is still mounted before using context
      if (!mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      if (result['success'] == true) {
        // Store trip data in provider
        ref.read(currentTripProvider.notifier).state = {
          'source': _sourceController.text,
          'destination': _destinationController.text,
          'date': DateFormat('MMM dd, yyyy').format(_selectedDate),
          'budget': _budgetController.text,
          'preference': _selectedPreference.name,
          'trip_id': result['trip_id'],
        };

        // Reset confirmation state
        ref.read(isTripConfirmedProvider.notifier).state = false;

        // Navigate to confirmation screen instead of itinerary
        context.go('/trip-confirmation');
      }
    } catch (e) {
      // Check if widget is still mounted before using context
      if (!mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to plan trip: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/'),
      body: Stack(
        children: [
          // Background image
          Image.network(
            'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),

          // Dark overlay for better text visibility
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withAlpha(153), // 0.6 opacity
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // Location header
                    AnimatedContent(
                      delay: const Duration(milliseconds: 100),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Belgaum, Karnataka, India',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Location name
                    AnimatedContent(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'Gokak Falls',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Category chips
                    AnimatedContent(
                      delay: const Duration(milliseconds: 300),
                      child: SizedBox(
                        height: 40.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final isSelected = category == _selectedCategory;

                            return Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: ChoiceChip(
                                label: Text(
                                  category,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                selected: isSelected,
                                backgroundColor: Colors.white,
                                selectedColor: AppTheme.primaryColor,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Trip planner card
                    AnimatedContent(
                      delay: const Duration(milliseconds: 400),
                      slideBegin: const Offset(0, 0.3),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26), // 0.1 opacity
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Welcome message
                            Text(
                              'Welcome Traveler!',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Start your journey with your first trip and plan your itinerary',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 24.h),

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
                                    prefixIcon: const Icon(
                                      Icons.calendar_today,
                                    ),
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
                                labelText: 'Budget',
                                hintText: 'Enter your budget',
                                prefixIcon: const Icon(Icons.attach_money),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 16.h),

                            // Travel preference
                            Text(
                              'Travel Preference',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children:
                                  TravelPreference.values.map((preference) {
                                    return ChoiceChip(
                                      label: Text(
                                        preference.name,
                                        style: TextStyle(
                                          color:
                                              _selectedPreference == preference
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                      ),
                                      selected:
                                          _selectedPreference == preference,
                                      backgroundColor: Colors.grey[200],
                                      selectedColor: AppTheme.primaryColor,
                                      onSelected: (selected) {
                                        if (selected) {
                                          setState(() {
                                            _selectedPreference = preference;
                                          });
                                        }
                                      },
                                    );
                                  }).toList(),
                            ),
                            SizedBox(height: 24.h),

                            // Plan trip button
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: _planTrip,
                                icon: const Icon(Icons.add),
                                label: const Text('New Itinerary'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.secondaryColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 12.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
