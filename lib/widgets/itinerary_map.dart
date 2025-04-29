// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/models/itinerary_detail.dart';
import 'package:karnova/utils/theme.dart';

class ItineraryMap extends StatefulWidget {
  final DailyItinerary dailyItinerary;
  
  const ItineraryMap({
    super.key,
    required this.dailyItinerary,
  });

  @override
  State<ItineraryMap> createState() => _ItineraryMapState();
}

class _ItineraryMapState extends State<ItineraryMap> {
  // This would normally use a real map provider like Google Maps
  // For this demo, we'll create a simulated map view
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          // Map background (simulated)
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: _buildSimulatedMap(),
          ),
          
          // Route path
          CustomPaint(
            size: Size(double.infinity, 250.h),
            painter: RoutePainter(
              activities: widget.dailyItinerary.activities,
            ),
          ),
          
          // Location markers
          ...widget.dailyItinerary.activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            
            // Calculate position (for demo purposes)
            final xPosition = 20.w + (index * 60.w);
            final yPosition = 50.h + (index % 3 * 60.h);
            
            return Positioned(
              left: xPosition,
              top: yPosition,
              child: _buildMarker(index + 1, activity),
            );
          }),
          
          // Map controls (simulated)
          Positioned(
            right: 10.w,
            bottom: 10.h,
            child: Column(
              children: [
                _buildMapControl(Icons.add, () {}),
                SizedBox(height: 8.h),
                _buildMapControl(Icons.remove, () {}),
                SizedBox(height: 8.h),
                _buildMapControl(Icons.my_location, () {}),
              ],
            ),
          ),
          
          // Map attribution
          Positioned(
            left: 10.w,
            bottom: 10.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'Map data © TripOnBuddy',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSimulatedMap() {
    // This is a placeholder for a real map
    // In a real app, you would use a map provider like Google Maps
    return Container(
      color: const Color(0xFFE8EEF4), // Light blue-gray for map background
      child: CustomPaint(
        painter: SimulatedMapPainter(),
        size: Size(double.infinity, 250.h),
      ),
    );
  }
  
  Widget _buildMarker(int number, Activity activity) {
    return Column(
      children: [
        // Marker with number
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
        
        // Activity name tooltip on hover
        Tooltip(
          message: '${activity.time}: ${activity.title}',
          child: Container(
            margin: EdgeInsets.only(top: 4.h),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              activity.title.length > 10 
                  ? '${activity.title.substring(0, 10)}...' 
                  : activity.title,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildMapControl(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18.sp),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        color: Colors.black87,
      ),
    );
  }
}

// Custom painter for the route path
class RoutePainter extends CustomPainter {
  final List<Activity> activities;
  
  RoutePainter({required this.activities});
  
  @override
  void paint(Canvas canvas, Size size) {
    if (activities.isEmpty) return;
    
    final paint = Paint()
      ..color = AppTheme.primaryColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    final dashPaint = Paint()
      ..color = AppTheme.primaryColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    
    // Create points for each activity (for demo purposes)
    final points = activities.asMap().entries.map((entry) {
      final index = entry.key;
      final xPosition = 20.w + (index * 60.w) + 15.w; // Center of marker
      final yPosition = 50.h + (index % 3 * 60.h) + 15.h; // Center of marker
      return Offset(xPosition, yPosition);
    }).toList();
    
    // Draw path connecting all points
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      
      for (int i = 1; i < points.length; i++) {
        // Draw a curved path between points
        final prevPoint = points[i - 1];
        final currentPoint = points[i];
        
        // Control points for the curve
        final controlPoint1 = Offset(
          prevPoint.dx + (currentPoint.dx - prevPoint.dx) / 2,
          prevPoint.dy,
        );
        
        final controlPoint2 = Offset(
          prevPoint.dx + (currentPoint.dx - prevPoint.dx) / 2,
          currentPoint.dy,
        );
        
        path.cubicTo(
          controlPoint1.dx, controlPoint1.dy,
          controlPoint2.dx, controlPoint2.dy,
          currentPoint.dx, currentPoint.dy,
        );
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for simulated map background
class SimulatedMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw some simulated roads
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final secondaryRoadPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    // Main roads
    final mainRoad1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width, size.height * 0.3);
    
    final mainRoad2 = Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.2, size.height);
    
    final mainRoad3 = Path()
      ..moveTo(size.width * 0.6, 0)
      ..lineTo(size.width * 0.6, size.height);
    
    // Secondary roads
    final secondaryRoad1 = Path()
      ..moveTo(0, size.height * 0.6)
      ..lineTo(size.width, size.height * 0.6);
    
    final secondaryRoad2 = Path()
      ..moveTo(size.width * 0.4, 0)
      ..lineTo(size.width * 0.4, size.height);
    
    final secondaryRoad3 = Path()
      ..moveTo(size.width * 0.8, 0)
      ..lineTo(size.width * 0.8, size.height);
    
    // Draw blocks (buildings)
    final blockPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;
    
    // Draw some random blocks to simulate buildings
    for (int i = 0; i < 20; i++) {
      final left = (i * 30) % size.width;
      final top = ((i * 40) % size.height);
      final blockSize = 20.0 + (i % 5) * 5;
      
      canvas.drawRect(
        Rect.fromLTWH(left, top, blockSize, blockSize),
        blockPaint,
      );
    }
    
    // Draw roads on top of blocks
    canvas.drawPath(mainRoad1, roadPaint);
    canvas.drawPath(mainRoad2, roadPaint);
    canvas.drawPath(mainRoad3, roadPaint);
    
    canvas.drawPath(secondaryRoad1, secondaryRoadPaint);
    canvas.drawPath(secondaryRoad2, secondaryRoadPaint);
    canvas.drawPath(secondaryRoad3, secondaryRoadPaint);
    
    // Draw some green areas (parks)
    final parkPaint = Paint()
      ..color = Colors.green[100]!
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.4),
      30,
      parkPaint,
    );
    
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.7),
      25,
      parkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
