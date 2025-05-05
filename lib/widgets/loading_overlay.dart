// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/utils/theme.dart';

class LoadingOverlay extends StatelessWidget {
  final String message;
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message = 'Please wait a few seconds...',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The main content
        child,

        // Loading overlay
        if (isLoading)
          Container(
            color: Colors.black.withAlpha(179), // 70% opacity
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animation
                      SizedBox(
                        width: 150.w,
                        height: 150.w,
                        child: _buildLoadingAnimation(),
                      ),
                      SizedBox(height: 24.h),

                      // Message
                      Text(
                        message,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 16.h),

                      // Generating itinerary text
                      Text(
                        'Generating your perfect itinerary...',
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 24.h),

                      // Progress indicator
                      LinearProgressIndicator(
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingAnimation() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Use a simple circular progress indicator as fallback
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            strokeWidth: 4.w,
          ),
          SizedBox(height: 16.h),
          Text(
            'Creating your dream trip',
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
