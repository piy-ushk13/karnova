// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/animated_content.dart';
import 'package:karnova/widgets/budget_slider.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';
import 'package:karnova/widgets/glassmorphic_container.dart';

class SearchFormScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? initialData;

  const SearchFormScreen({super.key, this.initialData});

  @override
  ConsumerState<SearchFormScreen> createState() => _SearchFormScreenState();
}

class _SearchFormScreenState extends ConsumerState<SearchFormScreen> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  double _budget = 5000;
  int _travelers = 1;

  final List<String> _transportModes = ['Flight', 'Train', 'Bus', 'Car'];
  final List<String> _selectedTransportModes = [];

  @override
  void initState() {
    super.initState();

    // Set initial values if provided
    if (widget.initialData != null) {
      if (widget.initialData!.containsKey('category')) {
        final category = widget.initialData!['category'] as String;
        if (category == 'Flights') {
          _selectedTransportModes.add('Flight');
        } else if (category == 'Trains') {
          _selectedTransportModes.add('Train');
        } else if (category == 'Bus') {
          _selectedTransportModes.add('Bus');
        } else if (category == 'Boats') {
          _selectedTransportModes.add('Boat');
        }
      }
    }

    // Set default source
    _sourceController.text = 'Belgaum Karnataka India';
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/search'),
      body: Stack(
        children: [
          // Background image with gradient overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/scenic_background.png',
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppTheme.gradientStart, AppTheme.gradientEnd],
                      ),
                    ),
                  ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button and title
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        onPressed: () => context.pop(),
                      ),
                      Text(
                        'Plan Your Trip',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Form container
                  AnimatedContent(
                    child: GlassmorphicContainer(
                      width: double.infinity,
                      height: 800.h,
                      borderRadius: 24.r,
                      blur: 10.0,
                      backgroundColor: Colors.white,
                      borderColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Form title
                            Text(
                              'Where would you like to go?',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            SizedBox(height: 24.h),

                            // Source field
                            _buildTextField(
                              controller: _sourceController,
                              label: 'From',
                              hint: 'Enter your location',
                              icon: Icons.location_on_outlined,
                              readOnly: true,
                            ),
                            SizedBox(height: 16.h),

                            // Destination field
                            _buildTextField(
                              controller: _destinationController,
                              label: 'To',
                              hint: 'Where to?',
                              icon: Icons.location_on,
                            ),
                            SizedBox(height: 24.h),

                            // Date selection
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDateField(
                                    label: 'Start Date',
                                    value: _startDate,
                                    onTap: () => _selectDate(context, true),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: _buildDateField(
                                    label: 'End Date',
                                    value: _endDate,
                                    onTap: () => _selectDate(context, false),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),

                            // Budget slider
                            Text(
                              'Budget',
                              style: GoogleFonts.roboto(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            BudgetSlider(
                              value: _budget,
                              min: 1000,
                              max: 50000,
                              onChanged: (value) {
                                setState(() {
                                  _budget = value;
                                });
                              },
                            ),
                            SizedBox(height: 24.h),

                            // Travelers count
                            Text(
                              'Travelers',
                              style: GoogleFonts.roboto(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color:
                                        _travelers > 1
                                            ? AppTheme.primaryColor
                                            : Colors.grey,
                                    size: 24.sp,
                                  ),
                                  onPressed:
                                      _travelers > 1
                                          ? () {
                                            setState(() {
                                              _travelers--;
                                            });
                                          }
                                          : null,
                                ),
                                SizedBox(width: 16.w),
                                Text(
                                  '$_travelers',
                                  style: GoogleFonts.roboto(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: AppTheme.primaryColor,
                                    size: 24.sp,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _travelers++;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),

                            // Transport modes
                            Text(
                              'Transport Modes',
                              style: GoogleFonts.roboto(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children:
                                  _transportModes.map((mode) {
                                    final isSelected = _selectedTransportModes
                                        .contains(mode);
                                    return FilterChip(
                                      label: Text(mode),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() {
                                          if (selected) {
                                            _selectedTransportModes.add(mode);
                                          } else {
                                            _selectedTransportModes.remove(
                                              mode,
                                            );
                                          }
                                        });
                                      },
                                      backgroundColor: Colors.white,
                                      selectedColor: AppTheme.primaryColor
                                          .withAlpha(30),
                                      checkmarkColor: AppTheme.primaryColor,
                                      labelStyle: TextStyle(
                                        color:
                                            isSelected
                                                ? AppTheme.primaryColor
                                                : AppTheme.textPrimaryColor,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                      ),
                                    );
                                  }).toList(),
                            ),
                            SizedBox(height: 32.h),

                            // Search button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _search,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Search',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
              prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 20.sp),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  value != null
                      ? '${value.day}/${value.month}/${value.year}'
                      : 'Select date',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color:
                        value != null
                            ? AppTheme.textPrimaryColor
                            : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // If end date is before start date, reset it
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          // Only allow end date to be set if start date is set
          if (_startDate != null) {
            // Ensure end date is after start date
            if (picked.isAfter(_startDate!)) {
              _endDate = picked;
            } else {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'End date must be after start date',
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Please select a start date first',
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      });
    }
  }

  void _search() {
    // Validate form
    if (_destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a destination',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a start date',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select an end date',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedTransportModes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select at least one transport mode',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to results screen
    context.push(
      '/results',
      extra: {
        'source': _sourceController.text,
        'destination': _destinationController.text,
        'startDate': _startDate,
        'endDate': _endDate,
        'budget': _budget,
        'travelers': _travelers,
        'transportModes': _selectedTransportModes,
      },
    );
  }
}
