// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:karnova/controllers/trip_planning_controller.dart';
import 'package:karnova/models/itinerary_detail.dart';
import 'package:karnova/repositories/trip_planning_repository.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/animated_content.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';
import 'package:karnova/widgets/plan_generation_animation.dart';

class AITripPlannerScreen extends ConsumerStatefulWidget {
  const AITripPlannerScreen({super.key});

  @override
  ConsumerState<AITripPlannerScreen> createState() =>
      _AITripPlannerScreenState();
}

class _AITripPlannerScreenState extends ConsumerState<AITripPlannerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _fromLocationController = TextEditingController(
    text: 'Belgaum, Karnataka, India',
  );
  final _destinationController = TextEditingController();
  final _budgetController = TextEditingController();
  final _durationController = TextEditingController();
  final _travelersController = TextEditingController(text: '2');

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  bool _isInternational = false;

  @override
  void dispose() {
    _fromLocationController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    _durationController.dispose();
    _travelersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch providers
    final isLoading = ref.watch(tripPlanningLoadingProvider);
    final errorMessage = ref.watch(tripPlanningErrorProvider);
    final successMessage = ref.watch(tripPlanningSuccessProvider);
    final generatedItinerary = ref.watch(generatedItineraryDetailProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trip Planner',
          style: TextStyle(
            fontFamily: 'sans-serif',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        actions: [
          if (generatedItinerary != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Start Over',
              onPressed: () {
                ref.read(tripPlanningControllerProvider).clearItinerary();
              },
            ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/'),
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child:
                generatedItinerary == null
                    ? _buildPlannerForm(context, isLoading, errorMessage)
                    : _buildGeneratedItinerary(context, generatedItinerary),
          ),

          // Loading animation overlay
          if (isLoading)
            const PlanGenerationAnimation(
              message:
                  'Please wait while we create your personalized travel plan with AI. '
                  'We\'re finding the best attractions, accommodations, and experiences '
                  'based on your preferences.',
            ),

          // Success message overlay with animation
          if (successMessage != null && !isLoading)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: AnimatedContent(
                slideBegin: const Offset(0, -1),
                duration: const Duration(milliseconds: 500),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green[100],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green[700],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                successMessage,
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'This message will disappear in 5 seconds',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.green[700],
                            size: 20,
                          ),
                          onPressed: () {
                            ref
                                .read(tripPlanningSuccessProvider.notifier)
                                .state = null;
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlannerForm(
    BuildContext context,
    bool isLoading,
    String? errorMessage,
  ) {
    return AnimatedContent(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Plan Your Dream Trip with AI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sans-serif',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Our AI will create a personalized itinerary based on your preferences',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: 'sans-serif',
                ),
              ),
              SizedBox(height: 24.h),

              // From Location
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From Location',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _fromLocationController,
                    decoration: InputDecoration(
                      labelText: 'From Location',
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'Roboto',
                      ),
                      hintText: 'Enter your starting location',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontFamily: 'Roboto',
                      ),
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your starting location';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Destination
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Destination',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      labelText: 'Destination',
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'Roboto',
                      ),
                      hintText: 'Where do you want to go?',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontFamily: 'Roboto',
                      ),
                      prefixIcon: const Icon(Icons.flight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a destination';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Date Picker
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start Date',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  InkWell(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 2),
                        ),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 12.w),
                          Icon(Icons.calendar_today, color: Colors.grey[700]),
                          SizedBox(width: 12.w),
                          Text(
                            DateFormat('dd MMM yyyy').format(_selectedDate),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black87,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Duration
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Duration (days)',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Duration (days)',
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'Roboto',
                      ),
                      hintText: 'How many days?',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontFamily: 'Roboto',
                      ),
                      prefixIcon: const Icon(Icons.timelapse),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the duration';
                      }
                      if (int.tryParse(value) == null || int.parse(value) < 1) {
                        return 'Please enter a valid number of days';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Budget
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Budget (₹)',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Budget (₹)',
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'Roboto',
                      ),
                      hintText: 'Your budget in INR',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontFamily: 'Roboto',
                      ),
                      prefixIcon: const Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your budget';
                      }
                      if (int.tryParse(value) == null ||
                          int.parse(value) < 1000) {
                        return 'Please enter a valid budget (min ₹1000)';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Travelers
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number of Travelers',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _travelersController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Number of Travelers',
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'Roboto',
                      ),
                      hintText: 'How many people?',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontFamily: 'Roboto',
                      ),
                      prefixIcon: const Icon(Icons.people),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of travelers';
                      }
                      if (int.tryParse(value) == null || int.parse(value) < 1) {
                        return 'Please enter a valid number of travelers';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // International Travel Switch
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SwitchListTile(
                  title: Text(
                    'International Travel',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  subtitle: Text(
                    'Enable for destinations outside India',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                      fontFamily: 'Roboto',
                    ),
                  ),
                  value: _isInternational,
                  onChanged: (value) {
                    setState(() {
                      _isInternational = value;
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Error Message
              if (errorMessage != null)
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.red[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[700],
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (errorMessage != null) SizedBox(height: 16.h),

              // Generate Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            if (_formKey.currentState!.validate()) {
                              _generateItinerary();
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Generate Itinerary',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'sans-serif',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Note about AI generation
              Text(
                'Note: AI-generated itineraries may take up to 30 seconds to create. The quality and accuracy of the itinerary depends on the information provided.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                  fontFamily: 'sans-serif',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneratedItinerary(
    BuildContext context,
    ItineraryDetail itinerary,
  ) {
    return AnimatedContent(
      child: Column(
        children: [
          // We don't need the success banner here anymore since we have the floating message
          // that automatically disappears

          // Itinerary summary
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Itinerary title
                  Text(
                    itinerary.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'sans-serif',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    itinerary.subtitle,
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16.h),

                  // Trip details
                  _buildInfoCard(
                    title: 'Trip Details',
                    content: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.location_on,
                          label: 'From',
                          value: itinerary.startLocation,
                        ),
                        _buildInfoRow(
                          icon: Icons.flight,
                          label: 'Destination',
                          value: itinerary.title.split(' ')[1],
                        ),
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: 'Dates',
                          value:
                              '${DateFormat('dd MMM yyyy').format(itinerary.startDate)} - ${DateFormat('dd MMM yyyy').format(itinerary.endDate)}',
                        ),
                        _buildInfoRow(
                          icon: Icons.timelapse,
                          label: 'Duration',
                          value: '${itinerary.durationInDays} days',
                        ),
                        _buildInfoRow(
                          icon: Icons.people,
                          label: 'Travelers',
                          value: '${itinerary.travelers} people',
                        ),
                        _buildInfoRow(
                          icon: Icons.currency_rupee,
                          label: 'Budget',
                          value: '₹${itinerary.budget}',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Highlights
                  _buildInfoCard(
                    title: 'Highlights',
                    content: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children:
                          itinerary.highlights.map((highlight) {
                            return Chip(
                              label: Text(highlight),
                              backgroundColor: Colors.blue[50],
                              side: BorderSide(color: Colors.blue[100]!),
                            );
                          }).toList(),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Travel Tips
                  _buildInfoCard(
                    title: 'Travel Tips',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          itinerary.travelTips.map((tip) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.tips_and_updates,
                                    size: 16.sp,
                                    color: AppTheme.primaryColor,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      tip,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to itinerary screen and pass the generated itinerary
                            context.go('/itinerary');
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text('View Full Itinerary'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Show edit dialog
                          _showEditDialog(context, itinerary);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: BorderSide(color: AppTheme.primaryColor),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget content}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12.h),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: AppTheme.primaryColor),
          SizedBox(width: 12.w),
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _generateItinerary() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Add a small delay to ensure keyboard is dismissed before showing loading animation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      final controller = ref.read(tripPlanningControllerProvider);

      controller.generateItinerary(
        fromLocation: _fromLocationController.text,
        location: _destinationController.text,
        startDate: _selectedDate,
        duration: int.parse(_durationController.text),
        budget: int.parse(_budgetController.text),
        isInternational: _isInternational,
        travelers: int.parse(_travelersController.text),
      );
    });
  }

  void _showEditDialog(BuildContext context, ItineraryDetail itinerary) {
    final destinationController = TextEditingController(
      text: itinerary.title.split(' ')[1],
    );
    final budgetController = TextEditingController(
      text: itinerary.budget.toString(),
    );
    final durationController = TextEditingController(
      text: itinerary.durationInDays.toString(),
    );
    final travelersController = TextEditingController(
      text: itinerary.travelers.toString(),
    );

    DateTime selectedDate = itinerary.startDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Itinerary'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Destination
                    TextField(
                      controller: destinationController,
                      decoration: const InputDecoration(
                        labelText: 'Destination',
                        prefixIcon: Icon(Icons.flight),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Date Picker
                    InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365 * 2),
                          ),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Start Date',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          DateFormat('dd MMM yyyy').format(selectedDate),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Duration
                    TextField(
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Duration (days)',
                        prefixIcon: Icon(Icons.timelapse),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Budget
                    TextField(
                      controller: budgetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Budget (₹)',
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Travelers
                    TextField(
                      controller: travelersController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Number of Travelers',
                        prefixIcon: Icon(Icons.people),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    // Update the itinerary
                    final controller = ref.read(tripPlanningControllerProvider);
                    controller.editItinerary(
                      currentItinerary: itinerary,
                      newLocation: destinationController.text,
                      newStartDate: selectedDate,
                      newDuration: int.tryParse(durationController.text),
                      newBudget: int.tryParse(budgetController.text),
                      newTravelers: int.tryParse(travelersController.text),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
