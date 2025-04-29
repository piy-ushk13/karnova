// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/models/transport_mode.dart';
import 'package:karnova/providers/trip_providers.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/animated_content.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';

class TripConfirmationScreen extends ConsumerStatefulWidget {
  const TripConfirmationScreen({super.key});

  @override
  ConsumerState<TripConfirmationScreen> createState() =>
      _TripConfirmationScreenState();
}

class _TripConfirmationScreenState
    extends ConsumerState<TripConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final tripData = ref.watch(currentTripProvider);
    final selectedTransportModes = ref.watch(selectedTransportModesProvider);
    final areasOfInterest = ref.watch(areasOfInterestProvider);
    final selectedAreas = ref.watch(selectedAreasProvider);

    if (tripData == null) {
      // If no trip data, redirect to home
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Confirm Your Trip',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip Summary
              AnimatedContent(
                delay: const Duration(milliseconds: 300),
                child: _buildTripSummary(tripData),
              ),

              SizedBox(height: 24.h),

              // Transport Modes Section
              AnimatedContent(
                delay: const Duration(milliseconds: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Transport Modes',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Choose your preferred modes of transportation',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildTransportModeSelector(),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Areas of Interest Section
              AnimatedContent(
                delay: const Duration(milliseconds: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Areas of Interest',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Select areas you want to explore in ${tripData['destination']}',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildAreasOfInterestGrid(),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // Action Buttons
              AnimatedContent(
                delay: const Duration(milliseconds: 900),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Discard and go back to home
                          ref.read(currentTripProvider.notifier).state = null;
                          context.go('/');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: BorderSide(color: Colors.grey[400]!),
                        ),
                        child: Text(
                          'Discard',
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Confirm and proceed to bookings
                          ref.read(isTripConfirmedProvider.notifier).state =
                              true;

                          // Show a dialog asking where to go next
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text(
                                    'Trip Confirmed!',
                                    style: GoogleFonts.playfairDisplay(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  content: Text(
                                    'Your trip has been confirmed. Where would you like to go next?',
                                    style: GoogleFonts.roboto(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context.go('/bookings');
                                      },
                                      child: const Text('View Bookings'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context.go('/itinerary');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryColor,
                                      ),
                                      child: const Text('View Itinerary'),
                                    ),
                                  ],
                                ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          'Confirm',
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            color: Colors.white,
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
        ),
      ),
      bottomNavigationBar: const CustomBottomNavbar(
        currentRoute: '/trip-confirmation',
      ),
    );
  }

  Widget _buildTripSummary(Map<String, dynamic> tripData) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Summary',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          _buildSummaryRow('From', tripData['source']),
          _buildSummaryRow('To', tripData['destination']),
          _buildSummaryRow('Date', tripData['date']),
          _buildSummaryRow('Budget', '₹${tripData['budget']}'),
          _buildSummaryRow('Preference', tripData['preference']),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.roboto(fontSize: 14.sp, color: Colors.black87),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportModeSelector() {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children:
          TransportMode.values.map((mode) {
            final isSelected = ref
                .watch(selectedTransportModesProvider)
                .contains(mode);

            return InkWell(
              onTap: () {
                final currentModes = [
                  ...ref.read(selectedTransportModesProvider),
                ];

                if (isSelected) {
                  // Don't allow deselecting if it's the only mode selected
                  if (currentModes.length > 1) {
                    currentModes.remove(mode);
                    ref.read(selectedTransportModesProvider.notifier).state =
                        currentModes;
                  }
                } else {
                  currentModes.add(mode);
                  ref.read(selectedTransportModesProvider.notifier).state =
                      currentModes;
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color:
                        isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: AppTheme.primaryColor.withAlpha(77),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIconForName(mode.icon),
                      color: isSelected ? Colors.white : Colors.grey[700],
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      mode.name,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildAreasOfInterestGrid() {
    final areas = ref.watch(areasOfInterestProvider);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: areas.length,
      itemBuilder: (context, index) {
        final area = areas[index];
        final isSelected = ref.watch(selectedAreasProvider).contains(area.id);

        return InkWell(
          onTap: () {
            final currentSelectedAreas = [...ref.read(selectedAreasProvider)];

            if (isSelected) {
              currentSelectedAreas.remove(area.id);
            } else {
              currentSelectedAreas.add(area.id);
            }

            ref.read(selectedAreasProvider.notifier).state =
                currentSelectedAreas;
          },
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? AppTheme.primaryColor.withAlpha(26)
                      : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getIconForName(area.icon),
                  color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
                  size: 24.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  area.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color:
                        isSelected ? AppTheme.primaryColor : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to convert icon name to IconData
  IconData _getIconForName(String iconName) {
    switch (iconName) {
      case 'flight':
        return Icons.flight;
      case 'train':
        return Icons.train;
      case 'directions_bus':
        return Icons.directions_bus;
      case 'directions_car':
        return Icons.directions_car;
      case 'directions_boat':
        return Icons.directions_boat;
      case 'photo_camera':
        return Icons.photo_camera;
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'nature':
        return Icons.nature;
      case 'account_balance':
        return Icons.account_balance;
      case 'hiking':
        return Icons.hiking;
      default:
        return Icons.circle;
    }
  }
}
