// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:karnova/models/destination.dart';
import 'package:karnova/services/api_service.dart';
import 'package:karnova/widgets/animated_content.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';
import 'package:karnova/utils/theme.dart';

// Provider for popular places
final popularPlacesProvider = FutureProvider<List<Destination>>((ref) async {
  try {
    // Get the API service
    final apiService = ref.read(apiServiceProvider);

    // Fetch all destinations
    final destinations = await apiService.getDestinations();

    // Sort by rating to get the most popular ones
    destinations.sort((a, b) => b.rating.compareTo(a.rating));

    // Return top destinations
    return destinations.take(6).toList();
  } catch (e) {
    throw Exception('Failed to load popular places: $e');
  }
});

class HomeScreenAnimated extends ConsumerStatefulWidget {
  const HomeScreenAnimated({super.key});

  @override
  ConsumerState<HomeScreenAnimated> createState() => _HomeScreenAnimatedState();
}

class _HomeScreenAnimatedState extends ConsumerState<HomeScreenAnimated> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final popularPlaces = ref.watch(popularPlacesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/'),
      body: SafeArea(
        child: AnimatedContent(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
              SizedBox(height: 24.h),

              // Header text
              AnimatedContent(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  'Where do you want\nto go?',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Search bar
              AnimatedContent(
                delay: const Duration(milliseconds: 200),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      Icon(Icons.search, color: Colors.grey[600]),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Find a tourist destination',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.sp,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Popular travel section
              AnimatedContent(
                delay: const Duration(milliseconds: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular travel',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/destinations'),
                      child: Text(
                        'View all',
                        style: TextStyle(color: Colors.blue[700], fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Popular places horizontal list
              AnimatedContent(
                delay: const Duration(milliseconds: 400),
                child: SizedBox(
                  height: 220.h,
                  child: popularPlaces.when(
                    data: (places) {
                      if (places.isEmpty) {
                        return const Center(child: Text('No places available'));
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: places.length.clamp(0, 6),
                        itemBuilder: (context, index) {
                          return AnimatedContent(
                            delay: Duration(milliseconds: 500 + (index * 100)),
                            slideBegin: const Offset(1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsets.only(right: 16.w),
                              child: _buildPopularPlaceCard(places[index]),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Center(child: Text('Failed to load places')),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Recent Collection section
              AnimatedContent(
                delay: const Duration(milliseconds: 600),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Collection',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View all',
                        style: TextStyle(color: Colors.blue[700], fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Recent collection item
              AnimatedContent(
                delay: const Duration(milliseconds: 700),
                slideBegin: const Offset(0.0, 0.5),
                child: _buildRecentCollectionItem(
                  'Klaten Central Java',
                  'Tour in the countryside with farmers in Kaliadem village',
                  '\$98.80',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularPlaceCard(Destination place) {
    return GestureDetector(
      onTap: () => context.go('/detail/${place.id}'),
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              child: Image.network(
                place.image,
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    place.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Location and price
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 14.sp),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          '${place.region}, ${place.country}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Price
                  Text(
                    '\$${place.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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

  Widget _buildRecentCollectionItem(
    String title,
    String description,
    String price,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red, size: 16.sp),
              SizedBox(width: 4.w),
              Text(
                title,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              price,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
