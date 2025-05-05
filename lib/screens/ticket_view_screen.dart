// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/animated_content.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';

class TicketViewScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? ticketData;
  
  const TicketViewScreen({
    super.key,
    this.ticketData,
  });

  @override
  ConsumerState<TicketViewScreen> createState() => _TicketViewScreenState();
}

class _TicketViewScreenState extends ConsumerState<TicketViewScreen> {
  bool _isLoading = false;
  bool _isBooked = false;
  
  @override
  Widget build(BuildContext context) {
    if (widget.ticketData == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sp,
                color: Colors.red,
              ),
              SizedBox(height: 16.h),
              Text(
                'No ticket data available',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Go Home',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    final ticketData = widget.ticketData!;
    final date = ticketData['date'] as DateTime;
    final formattedDate = '${date.day}/${date.month}/${date.year}';
    
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/ticket'),
      body: Stack(
        children: [
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
                          color: AppTheme.textPrimaryColor,
                          size: 20.sp,
                        ),
                        onPressed: () => context.pop(),
                      ),
                      Text(
                        _isBooked ? 'Your Ticket' : 'Ticket Details',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  
                  // Ticket card
                  AnimatedContent(
                    child: _buildTicketCard(ticketData, formattedDate),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Passenger details
                  if (_isBooked) ...[
                    AnimatedContent(
                      delay: const Duration(milliseconds: 200),
                      child: _buildPassengerDetails(),
                    ),
                    SizedBox(height: 24.h),
                    
                    // Barcode
                    AnimatedContent(
                      delay: const Duration(milliseconds: 300),
                      child: _buildBarcode(),
                    ),
                  ] else ...[
                    // Booking form
                    AnimatedContent(
                      delay: const Duration(milliseconds: 200),
                      child: _buildBookingForm(),
                    ),
                  ],
                  
                  SizedBox(height: 24.h),
                  
                  // Action button
                  if (!_isBooked)
                    AnimatedContent(
                      delay: const Duration(milliseconds: 300),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _bookTicket,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 24.h,
                                  width: 24.h,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.w,
                                  ),
                                )
                              : Text(
                                  'Book Now',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
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
  
  Widget _buildTicketCard(Map<String, dynamic> ticketData, String formattedDate) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: _getHeaderColor(ticketData['type']).withAlpha(20),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                // Company logo
                Container(
                  width: 48.w,
                  height: 48.w,
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
                  child: ticketData['logo'].isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            ticketData['logo'],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              _getTransportIcon(ticketData['type']),
                              color: _getHeaderColor(ticketData['type']),
                              size: 28.sp,
                            ),
                          ),
                        )
                      : Icon(
                          _getTransportIcon(ticketData['type']),
                          color: _getHeaderColor(ticketData['type']),
                          size: 28.sp,
                        ),
                ),
                SizedBox(width: 16.w),
                
                // Company and type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticketData['company'],
                        style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      Text(
                        '${ticketData['type']} • $formattedDate',
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Divider with scissors
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: -12.w),
                child: Center(
                  child: Icon(
                    Icons.circle,
                    size: 8.sp,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Flex(
                      direction: Axis.horizontal,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        (constraints.constrainWidth() / 10).floor(),
                        (index) => SizedBox(
                          width: 5.w,
                          height: 1.h,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                margin: EdgeInsets.only(right: -12.w),
                child: Center(
                  child: Icon(
                    Icons.circle,
                    size: 8.sp,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Route illustration
                Row(
                  children: [
                    // Departure
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          ticketData['sourceCode'],
                          style: GoogleFonts.roboto(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        SizedBox(
                          width: 100.w,
                          child: Text(
                            ticketData['source'],
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              color: AppTheme.textSecondaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Column(
                          children: [
                            SizedBox(height: 16.h),
                            Image.asset(
                              'assets/images/train_illustration.png',
                              height: 32.h,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                _getTransportIcon(ticketData['type']),
                                color: _getHeaderColor(ticketData['type']),
                                size: 32.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              ticketData['duration'],
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                color: AppTheme.textSecondaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Arrival
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'To',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          ticketData['destinationCode'],
                          style: GoogleFonts.roboto(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        SizedBox(
                          width: 100.w,
                          child: Text(
                            ticketData['destination'],
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              color: AppTheme.textSecondaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                
                // Time details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem('Departure', ticketData['departure']),
                    _buildDetailItem('Arrival', ticketData['arrival']),
                    _buildDetailItem('Date', formattedDate),
                  ],
                ),
                SizedBox(height: 16.h),
                
                // Price
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withAlpha(10),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total Price',
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Rp ${(ticketData['price'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                        style: GoogleFonts.roboto(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12.sp,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }
  
  Widget _buildPassengerDetails() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Passenger Details',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          _buildPassengerRow('Name', 'John Doe'),
          Divider(color: Colors.grey[200]),
          _buildPassengerRow('ID Number', '1234567890'),
          Divider(color: Colors.grey[200]),
          _buildPassengerRow('Seat', 'A12'),
          Divider(color: Colors.grey[200]),
          _buildPassengerRow('Class', 'Economy'),
        ],
      ),
    );
  }
  
  Widget _buildPassengerRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBarcode() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/barcode.png',
            height: 80.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 80.h,
              color: Colors.grey[200],
              child: Center(
                child: Icon(
                  Icons.qr_code,
                  size: 40.sp,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'TICKET-12345-67890',
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Show this code at the gate',
            style: GoogleFonts.roboto(
              fontSize: 12.sp,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBookingForm() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Passenger Information',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Name field
          _buildTextField(
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
          ),
          SizedBox(height: 16.h),
          
          // ID field
          _buildTextField(
            label: 'ID Number',
            hint: 'Enter your ID number',
            icon: Icons.credit_card,
          ),
          SizedBox(height: 16.h),
          
          // Email field
          _buildTextField(
            label: 'Email',
            hint: 'Enter your email',
            icon: Icons.email_outlined,
          ),
          SizedBox(height: 16.h),
          
          // Phone field
          _buildTextField(
            label: 'Phone',
            hint: 'Enter your phone number',
            icon: Icons.phone_outlined,
          ),
        ],
      ),
    );
  }
  
  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 20.sp,
              ),
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
  
  Future<void> _bookTicket() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate booking process
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
      _isBooked = true;
    });
    
    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ticket booked successfully!',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
  
  Color _getHeaderColor(String type) {
    switch (type) {
      case 'Flight':
        return Colors.blue;
      case 'Train':
        return Colors.orange;
      case 'Bus':
        return Colors.green;
      default:
        return AppTheme.primaryColor;
    }
  }
  
  IconData _getTransportIcon(String type) {
    switch (type) {
      case 'Flight':
        return Icons.flight;
      case 'Train':
        return Icons.train;
      case 'Bus':
        return Icons.directions_bus;
      default:
        return Icons.directions_car;
    }
  }
}
