// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/animated_content.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';

class HomeScreenRevamped extends ConsumerStatefulWidget {
  const HomeScreenRevamped({super.key});

  @override
  ConsumerState<HomeScreenRevamped> createState() => _HomeScreenRevampedState();
}

class _HomeScreenRevampedState extends ConsumerState<HomeScreenRevamped> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                
                // Top status bar with points and icons
                _buildTopStatusBar(),
                SizedBox(height: 24.h),
                
                // Main headline
                AnimatedContent(
                  child: Text(
                    'Travel Made Effortless',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                
                // Category cards
                AnimatedContent(
                  delay: const Duration(milliseconds: 200),
                  child: _buildCategoryCards(),
                ),
                SizedBox(height: 24.h),
                
                // Upcoming schedules section
                AnimatedContent(
                  delay: const Duration(milliseconds: 300),
                  child: _buildUpcomingSchedulesSection(),
                ),
                SizedBox(height: 24.h),
                
                // Recommendations section
                AnimatedContent(
                  delay: const Duration(milliseconds: 400),
                  child: _buildRecommendationsSection(),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTopStatusBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Points badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Icon(Icons.star, color: Colors.white, size: 16.sp),
              SizedBox(width: 4.w),
              Text(
                '320 points',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
        
        // Action icons
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.search, color: AppTheme.textPrimaryColor, size: 24.sp),
              onPressed: () {
                context.push('/search');
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: AppTheme.textPrimaryColor, size: 24.sp),
              onPressed: () {
                // Show notifications
              },
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildCategoryCards() {
    return SizedBox(
      height: 100.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryCard('Trains', Icons.train, AppTheme.primaryColor),
          SizedBox(width: 16.w),
          _buildCategoryCard('Flights', Icons.flight, Colors.indigo),
          SizedBox(width: 16.w),
          _buildCategoryCard('Boats', Icons.directions_boat, Colors.teal),
          SizedBox(width: 16.w),
          _buildCategoryCard('Bus', Icons.directions_bus, Colors.orange),
        ],
      ),
    );
  }
  
  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        context.push('/search', extra: {'category': title});
      },
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(40),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: color,
                size: 32.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildUpcomingSchedulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Schedules',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push('/itinerary');
              },
              child: Text(
                'View All',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildFlightCard(),
      ],
    );
  }
  
  Widget _buildFlightCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Airline info
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/en/thumb/9/9b/Garuda_Indonesia_Logo.svg/250px-Garuda_Indonesia_Logo.svg.png',
                  width: 32.w,
                  height: 32.w,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.flight,
                    size: 32.sp,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Garuda Airline',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const Spacer(),
              Text(
                'One way',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Flight route
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CGK',
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  Text(
                    '06:40',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                    Icon(
                      Icons.flight,
                      color: AppTheme.primaryColor,
                      size: 24.sp,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'DPS',
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  Text(
                    '09:15',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Additional info
          Row(
            children: [
              Icon(
                Icons.luggage,
                size: 16.sp,
                color: AppTheme.textSecondaryColor,
              ),
              SizedBox(width: 4.w),
              Text(
                '5 kg',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.push('/ticket');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'See Details',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommendations',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push('/destinations');
              },
              child: Text(
                'View All',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 180.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildRecommendationCard(
                'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
                'Mountain Retreat',
                'Swiss Alps',
              ),
              SizedBox(width: 16.w),
              _buildRecommendationCard(
                'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1488&q=80',
                'City Escape',
                'Tokyo, Japan',
              ),
              SizedBox(width: 16.w),
              _buildRecommendationCard(
                'https://images.unsplash.com/photo-1510414842594-a61c69b5ae57?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
                'Beach Paradise',
                'Bali, Indonesia',
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildRecommendationCard(String imageUrl, String title, String location) {
    return GestureDetector(
      onTap: () {
        context.push('/destinations');
      },
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                imageUrl,
                width: 160.w,
                height: 120.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 160.w,
                  height: 120.h,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image,
                    color: Colors.grey[400],
                    size: 40.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            
            // Title and location
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    location,
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: AppTheme.textSecondaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
