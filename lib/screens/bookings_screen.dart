// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/models/transport_mode.dart';
import 'package:karnova/providers/trip_providers.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/animated_content.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _bookingTypes = ['All', 'Hotels', 'Flights', 'Trains', 'Buses', 'Cars'];
  String _selectedType = 'All';

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
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Bookings',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsTab(isUpcoming: true),
          _buildBookingsTab(isUpcoming: false),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/bookings'),
    );
  }

  Widget _buildBookingsTab({required bool isUpcoming}) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking type filter
            AnimatedContent(
              delay: const Duration(milliseconds: 200),
              child: SizedBox(
                height: 40.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _bookingTypes.length,
                  itemBuilder: (context, index) {
                    final type = _bookingTypes[index];
                    final isSelected = type == _selectedType;
                    
                    return AnimatedContent(
                      delay: Duration(milliseconds: 300 + (index * 50)),
                      slideBegin: const Offset(1.0, 0.0),
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ChoiceChip(
                          label: Text(
                            type,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14.sp,
                            ),
                          ),
                          selected: isSelected,
                          backgroundColor: Colors.white,
                          selectedColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            side: BorderSide(
                              color: isSelected ? Colors.transparent : Colors.grey[300]!,
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedType = type;
                              });
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Bookings list
            AnimatedContent(
              delay: const Duration(milliseconds: 400),
              child: isUpcoming ? _buildUpcomingBookings() : _buildPastBookings(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingBookings() {
    // Get selected transport modes from provider
    final selectedModes = ref.watch(selectedTransportModesProvider);
    
    // If no transport modes are selected or filter is not "All", show empty state
    if (selectedModes.isEmpty && _selectedType == 'All') {
      return _buildEmptyState(
        'No upcoming bookings',
        'Your upcoming bookings will appear here once you confirm a trip.',
      );
    }
    
    // Filter bookings based on selected type
    List<TransportMode> filteredModes = [];
    if (_selectedType == 'All') {
      filteredModes = selectedModes;
    } else {
      // Filter by booking type
      switch (_selectedType) {
        case 'Flights':
          if (selectedModes.contains(TransportMode.flight)) {
            filteredModes.add(TransportMode.flight);
          }
          break;
        case 'Trains':
          if (selectedModes.contains(TransportMode.train)) {
            filteredModes.add(TransportMode.train);
          }
          break;
        case 'Buses':
          if (selectedModes.contains(TransportMode.bus)) {
            filteredModes.add(TransportMode.bus);
          }
          break;
        case 'Cars':
          if (selectedModes.contains(TransportMode.car)) {
            filteredModes.add(TransportMode.car);
          }
          break;
        case 'Hotels':
          // No transport mode for hotels, show hotel booking if any trip is confirmed
          if (ref.watch(isTripConfirmedProvider)) {
            return _buildHotelBooking();
          }
          break;
      }
    }
    
    if (filteredModes.isEmpty && _selectedType != 'Hotels') {
      return _buildEmptyState(
        'No ${_selectedType.toLowerCase()} bookings',
        'Your ${_selectedType.toLowerCase()} bookings will appear here once you confirm a trip with this transport mode.',
      );
    }
    
    // Show hotel booking if "All" or "Hotels" is selected and a trip is confirmed
    if ((_selectedType == 'All' || _selectedType == 'Hotels') && ref.watch(isTripConfirmedProvider)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedType == 'All') ...[
            Text(
              'Hotel Bookings',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            _buildHotelBooking(),
            SizedBox(height: 24.h),
          ] else
            _buildHotelBooking(),
            
          if (filteredModes.isNotEmpty && _selectedType == 'All') ...[
            Text(
              'Transport Bookings',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
          ],
          
          ...filteredModes.map((mode) => _buildTransportBooking(mode)).toList(),
        ],
      );
    }
    
    // Show only transport bookings
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: filteredModes.map((mode) => _buildTransportBooking(mode)).toList(),
    );
  }

  Widget _buildHotelBooking() {
    final tripData = ref.watch(currentTripProvider);
    
    return Card(
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
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.hotel,
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
                        'Luxury Hotel',
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        tripData?['destination'] ?? 'Unknown Location',
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(26),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    'Confirmed',
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(color: Colors.grey[300]),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBookingDetail('Check-in', tripData?['date'] ?? 'Unknown'),
                _buildBookingDetail('Check-out', 'In 3 days'),
                _buildBookingDetail('Guests', '2 Adults'),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone),
                    label: const Text('Contact'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportBooking(TransportMode mode) {
    final tripData = ref.watch(currentTripProvider);
    
    // Define icon and title based on transport mode
    IconData icon;
    String title;
    String provider;
    
    switch (mode) {
      case TransportMode.flight:
        icon = Icons.flight;
        title = 'Flight to ${tripData?['destination'] ?? 'Unknown'}';
        provider = 'Air India';
        break;
      case TransportMode.train:
        icon = Icons.train;
        title = 'Train to ${tripData?['destination'] ?? 'Unknown'}';
        provider = 'Indian Railways';
        break;
      case TransportMode.bus:
        icon = Icons.directions_bus;
        title = 'Bus to ${tripData?['destination'] ?? 'Unknown'}';
        provider = 'RedBus';
        break;
      case TransportMode.car:
        icon = Icons.directions_car;
        title = 'Car Rental';
        provider = 'Zoomcar';
        break;
      case TransportMode.ferry:
        icon = Icons.directions_boat;
        title = 'Ferry to ${tripData?['destination'] ?? 'Unknown'}';
        provider = 'Ferry Services';
        break;
    }
    
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
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
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
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
                          title,
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          provider,
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(26),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      'Confirmed',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Divider(color: Colors.grey[300]),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBookingDetail('From', tripData?['source'] ?? 'Unknown'),
                  _buildBookingDetail('To', tripData?['destination'] ?? 'Unknown'),
                  _buildBookingDetail('Date', tripData?['date'] ?? 'Unknown'),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.confirmation_number_outlined),
                      label: const Text('Ticket'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.primaryColor),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Details'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPastBookings() {
    return _buildEmptyState(
      'No past bookings',
      'Your booking history will appear here after your trips are completed.',
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 80.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Plan a Trip'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4.h),
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
}
