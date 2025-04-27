// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:karnova/models/destination.dart';
import 'package:karnova/services/api_service.dart';
import 'package:karnova/utils/theme.dart';

// Provider for a single destination
final destinationProvider = FutureProvider.family<Destination, String>((
  ref,
  id,
) async {
  // In a real app, this would fetch from an API
  try {
    // Simulating network delay
    await Future.delayed(const Duration(seconds: 1));

    // Use the API service instead of directly loading from assets
    final apiService = ref.read(apiServiceProvider);
    return await apiService.getDestination(id);
  } catch (e) {
    throw Exception('Failed to load destination: $e');
  }
});

class TourPackage {
  final String name;
  final String description;
  final int price;
  final Color color;
  final IconData icon;

  TourPackage({
    required this.name,
    required this.description,
    required this.price,
    required this.color,
    required this.icon,
  });
}

class DetailScreen extends ConsumerWidget {
  final String destinationId;

  const DetailScreen({super.key, required this.destinationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinationAsync = ref.watch(destinationProvider(destinationId));

    // Sample tour packages
    final List<TourPackage> tourPackages = [
      TourPackage(
        name: 'Snorkeling in crystal clear waters',
        description: '3 hours',
        price: 150000,
        color: AppTheme.primaryColor,
        icon: Icons.water,
      ),
      TourPackage(
        name: 'Surfing on waves of the sea',
        description: '2 hours',
        price: 200000,
        color: Colors.orange,
        icon: Icons.surfing,
      ),
      TourPackage(
        name: 'Camping on sandy beach',
        description: 'Full day',
        price: 350000,
        color: Colors.green,
        icon: Icons.landscape,
      ),
      TourPackage(
        name: 'Strolling around beautiful beaches',
        description: '4 hours',
        price: 100000,
        color: Colors.purple,
        icon: Icons.beach_access,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: destinationAsync.when(
        data: (destination) {
          return SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back, size: 20),
                        ),
                      ),
                      Text(
                        'Detail',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.refresh, size: 20),
                      ),
                    ],
                  ),
                ),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tour image
                        Stack(
                          children: [
                            Image.network(
                              destination.image,
                              height: 250.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            // Gradient overlay for better text visibility
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 100.h,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      const Color.fromRGBO(0, 0, 0, 0.7),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Tour title and details
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                '${destination.name} Full day Tour\'s',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),

                              // Activities
                              Text(
                                destination.activities.take(3).join(', '),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),

                              // See map button
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'See map',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              // Description section
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Detail more',
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Description text
                              Text(
                                'Embark on a breathtaking adventure with ${destination.name} Tour. Explore the stunning beauty of nature, immerse yourself in...',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // Tour Package section
                              Text(
                                'Tour Package',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12.h),

                              // Tour package cards
                              SizedBox(
                                height: 100.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: tourPackages.length,
                                  itemBuilder: (context, index) {
                                    final package = tourPackages[index];
                                    return Container(
                                      width: 150.w,
                                      margin: EdgeInsets.only(right: 12.w),
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: package.color,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            package.icon,
                                            color: Colors.white,
                                            size: 24.sp,
                                          ),
                                          Text(
                                            package.name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            package.description,
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom booking bar
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        // Price
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Rp.${destination.price}',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.secondaryColor,
                                ),
                              ),
                              Text(
                                '/person',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Book button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Booking functionality coming soon!',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.swipe, size: 16),
                                SizedBox(width: 8.w),
                                const Text('SWIPE TO BOOK'),
                              ],
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
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error loading destination: $error',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
