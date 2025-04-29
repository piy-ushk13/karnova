// Augment: TripOnBuddy Website → Flutter App
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/animated_content.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';
import 'package:karnova/widgets/glassmorphic_container.dart';

// Custom painter for globe grid lines
class GlobePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue.shade200
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw latitude lines
    for (int i = 1; i < 6; i++) {
      final latRadius = radius * (i / 6);
      canvas.drawCircle(center, latRadius, paint);
    }

    // Draw longitude lines
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi) / 4;
      final startX = center.dx + radius * math.cos(angle);
      final startY = center.dy + radius * math.sin(angle);
      final endX = center.dx + radius * math.cos(angle + math.pi);
      final endY = center.dy + radius * math.sin(angle + math.pi);

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for the app logo
class LogoPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;

  LogoPainter({required this.primaryColor, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the globe
    final globePaint =
        Paint()
          ..color = primaryColor
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.7, globePaint);

    // Draw the equator line
    final linePaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: radius * 1.4,
        height: radius * 1.4,
      ),
      -math.pi / 4,
      math.pi * 1.5,
      false,
      linePaint,
    );

    // Draw the airplane
    final planePath = Path();
    final planeCenter = Offset(
      center.dx + radius * 0.3,
      center.dy - radius * 0.2,
    );

    // Airplane body
    planePath.moveTo(planeCenter.dx - radius * 0.2, planeCenter.dy);
    planePath.lineTo(planeCenter.dx + radius * 0.2, planeCenter.dy);
    planePath.lineTo(
      planeCenter.dx + radius * 0.3,
      planeCenter.dy - radius * 0.1,
    );
    planePath.lineTo(
      planeCenter.dx - radius * 0.1,
      planeCenter.dy - radius * 0.1,
    );
    planePath.close();

    // Airplane wings
    planePath.moveTo(planeCenter.dx, planeCenter.dy);
    planePath.lineTo(
      planeCenter.dx - radius * 0.15,
      planeCenter.dy + radius * 0.15,
    );
    planePath.lineTo(
      planeCenter.dx + radius * 0.15,
      planeCenter.dy + radius * 0.15,
    );
    planePath.close();

    // Airplane tail
    planePath.moveTo(
      planeCenter.dx - radius * 0.15,
      planeCenter.dy - radius * 0.05,
    );
    planePath.lineTo(
      planeCenter.dx - radius * 0.25,
      planeCenter.dy - radius * 0.15,
    );
    planePath.lineTo(
      planeCenter.dx - radius * 0.1,
      planeCenter.dy - radius * 0.1,
    );
    planePath.close();

    final planePaint =
        Paint()
          ..color = accentColor
          ..style = PaintingStyle.fill;

    canvas.drawPath(planePath, planePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomeScreenModern extends ConsumerStatefulWidget {
  const HomeScreenModern({super.key});

  @override
  ConsumerState<HomeScreenModern> createState() => _HomeScreenModernState();
}

class _HomeScreenModernState extends ConsumerState<HomeScreenModern>
    with SingleTickerProviderStateMixin {
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _daysController = TextEditingController(
    text: '7',
  );
  final TextEditingController _budgetController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  String _selectedTripType = 'Adventure';

  // Animation controller for logo
  late AnimationController _logoAnimationController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Create a curved animation
    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation and repeat it
    _logoAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _daysController.dispose();
    _budgetController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
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
            // Custom logo with animation
            AnimatedBuilder(
              animation: _logoAnimationController,
              builder: (context, child) {
                return Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 4 + (_logoAnimationController.value * 2),
                        spreadRadius:
                            1 + (_logoAnimationController.value * 0.5),
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: LogoPainter(
                      primaryColor:
                          Color.lerp(
                            Color(0xFF4E79FF),
                            Color(0xFF5E8AFF),
                            _logoAnimationController.value,
                          )!,
                      accentColor: Color(0xFF2A4DA0),
                    ),
                    size: Size(40, 40),
                  ),
                );
              },
            ),
            SizedBox(width: 8),
            // App name
            Text(
              'TripOnBuddy',
              style: TextStyle(
                color: Color(0xFF2A4DA0),
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: 'sans-serif',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Color(0xFF2A4DA0)),
            onPressed: () {
              context.go('/profile');
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9EBEFF), // Medium light blue
              Color(0xFF7FA5FF), // Medium blue
              Color(0xFF5E8AFF), // Deeper blue
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),

                  // Header Text
                  AnimatedContent(
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      'Start Planning\nYour Journey',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF2A4DA0),
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'sans-serif',
                        shadows: [
                          Shadow(
                            color: Colors.black.withAlpha(20),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // 3D Globe Illustration with Animation
                  AnimatedContent(
                    delay: const Duration(milliseconds: 200),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 1),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.8 + (0.2 * value),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Globe
                              Container(
                                width: 180.w,
                                height: 180.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white,
                                      AppTheme.primaryColor.withBlue(220),
                                    ],
                                    stops: const [0.3, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(50),
                                      blurRadius: 15,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Stack(
                                    children: [
                                      // Gradient background
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.lightBlue.shade100,
                                            ],
                                            stops: const [0.3, 1.0],
                                          ),
                                        ),
                                      ),
                                      // Grid pattern
                                      Opacity(
                                        opacity: 0.2,
                                        child: CustomPaint(
                                          painter: GlobePainter(),
                                          size: Size(180.w, 180.w),
                                        ),
                                      ),
                                      // Continents
                                      Positioned.fill(
                                        child: Center(
                                          child: Icon(
                                            Icons.public,
                                            size: 120.sp,
                                            color: Color(0xFF5E8AFF),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Orbit Ring with Animation
                              Transform.rotate(
                                angle: value * 6.28,
                                child: Container(
                                  width: 200.w,
                                  height: 200.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withAlpha(77),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),

                              // Airplane with Animation
                              Positioned(
                                left: 20.w + (value * 10),
                                top: 70.h - (value * 5),
                                child: Transform.rotate(
                                  angle: -0.5,
                                  child: Icon(
                                    Icons.flight,
                                    color: Colors.white,
                                    size: 40.sp,
                                  ),
                                ),
                              ),

                              // Destination Pin with Animation
                              Positioned(
                                right: 30.w - (value * 5),
                                bottom: 60.h + (value * 5),
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: const Duration(milliseconds: 800),
                                  builder: (context, pinValue, child) {
                                    return Transform.translate(
                                      offset: Offset(0, 10 * (1 - pinValue)),
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 30.sp,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Form Fields
                  AnimatedContent(
                    delay: const Duration(milliseconds: 300),
                    child: _buildFormField(
                      icon: Icons.location_on,
                      label: 'Start Location',
                      value: 'Belgaum, Karnataka, India',
                      isEnabled: false,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  AnimatedContent(
                    delay: const Duration(milliseconds: 350),
                    child: _buildFormField(
                      icon: Icons.flight_takeoff,
                      label: 'Destination',
                      hint: 'Enter destination',
                      controller: _destinationController,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Date and Duration in a row
                  Row(
                    children: [
                      // Date Picker
                      Expanded(
                        child: AnimatedContent(
                          delay: const Duration(milliseconds: 400),
                          child: _buildDateField(),
                        ),
                      ),

                      SizedBox(width: 16.w),

                      // Duration
                      Expanded(
                        child: AnimatedContent(
                          delay: const Duration(milliseconds: 450),
                          child: _buildFormField(
                            icon: Icons.timelapse,
                            label: 'Number of Days',
                            controller: _daysController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Budget
                  AnimatedContent(
                    delay: const Duration(milliseconds: 500),
                    child: _buildFormField(
                      icon: Icons.currency_rupee,
                      label: 'Budget',
                      hint: 'Enter your budget',
                      controller: _budgetController,
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // Trip Type Categories
                  AnimatedContent(
                    delay: const Duration(milliseconds: 550),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTripTypeButton('Adventure', Icons.terrain),
                        _buildTripTypeButton('Relaxation', Icons.spa),
                        _buildTripTypeButton('Shopping', Icons.shopping_bag),
                        _buildTripTypeButton('Food', Icons.restaurant),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // Generate Button
                  AnimatedContent(
                    delay: const Duration(milliseconds: 600),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60.h,
                      child: GlassmorphicContainer(
                        width: double.infinity,
                        height: 60.h,
                        borderRadius: 16.r,
                        blur: 10,
                        border: 1.5,
                        borderColor: Colors.white,
                        backgroundColor: Color(0xFF4E79FF).withAlpha(150),
                        padding: EdgeInsets.zero,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _navigateToTripPlanner();
                            },
                            borderRadius: BorderRadius.circular(16.r),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.explore,
                                    size: 24.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Plan My Trip',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'sans-serif',
                                      letterSpacing: 0.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required IconData icon,
    required String label,
    String? hint,
    TextEditingController? controller,
    bool isEnabled = true,
    String? value,
    TextInputType? keyboardType,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: isEnabled ? 60.h : 70.h,
      borderRadius: 16.r,
      blur: 10,
      border: 1.5,
      borderColor: Colors.white,
      backgroundColor: Colors.white,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF4E79FF), size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child:
                isEnabled
                    ? TextField(
                      controller: controller,
                      keyboardType: keyboardType,
                      style: const TextStyle(
                        color: Color(0xFF2A4DA0),
                        fontFamily: 'sans-serif',
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: Color(
                            0xFF4E79FF,
                          ).withAlpha(179), // 70% opacity
                          fontFamily: 'sans-serif',
                        ),
                        labelText: label,
                        labelStyle: TextStyle(
                          color: Color(0xFF2A4DA0),
                          fontFamily: 'sans-serif',
                          fontWeight: FontWeight.w500,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: Color(0xFF2A4DA0),
                            fontSize: 12.sp,
                            fontFamily: 'sans-serif',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          value ?? '',
                          style: const TextStyle(
                            color: Color(0xFF2A4DA0),
                            fontFamily: 'sans-serif',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppTheme.primaryColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 70.h,
        borderRadius: 16.r,
        blur: 10,
        border: 1.5,
        borderColor: Colors.white,
        backgroundColor: Colors.white,
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Color(0xFF4E79FF), size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start Date',
                    style: TextStyle(
                      color: Color(0xFF2A4DA0),
                      fontSize: 12.sp,
                      fontFamily: 'sans-serif',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    DateFormat('dd/MM/yyyy').format(_selectedDate),
                    style: const TextStyle(
                      color: Color(0xFF2A4DA0),
                      fontFamily: 'sans-serif',
                      fontWeight: FontWeight.w500,
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

  Widget _buildTripTypeButton(String type, IconData icon) {
    final isSelected = _selectedTripType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTripType = type;
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 60.w,
            height: 60.w,
            child: GlassmorphicContainer(
              width: 60.w,
              height: 60.w,
              borderRadius: 16.r,
              blur: isSelected ? 15 : 10,
              border: isSelected ? 2 : 1,
              borderColor: isSelected ? Color(0xFF4E79FF) : Colors.white,
              backgroundColor:
                  isSelected
                      ? Colors.white.withAlpha(200)
                      : Colors.white.withAlpha(100),
              child: Center(
                child: Icon(
                  icon,
                  color: isSelected ? AppTheme.primaryColor : Color(0xFF4E79FF),
                  size: 30.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            type,
            style: TextStyle(
              color: Color(0xFF2A4DA0),
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'sans-serif',
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTripPlanner() {
    // Validate inputs
    if (_destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a destination'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_budgetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your budget'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to AI trip planner with the entered data
    context.go('/ai-trip-planner');
  }
}
