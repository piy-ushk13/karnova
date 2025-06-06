// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:karnova/models/destination.dart';
import 'package:karnova/services/api_service.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';
// We need AppTheme for colors in some places
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

// Provider for popular tours
final popularToursProvider = FutureProvider<List<Destination>>((ref) async {
  try {
    // Get the API service
    final apiService = ref.read(apiServiceProvider);

    // Fetch destinations and filter for tours
    final destinations = await apiService.getDestinations();
    return destinations
        .where(
          (d) =>
              d.tags.any((tag) => tag.toLowerCase().contains('tour')) ||
              d.activities.any(
                (activity) => activity.toLowerCase().contains('tour'),
              ),
        )
        .toList();
  } catch (e) {
    throw Exception('Failed to load popular tours: $e');
  }
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  // Not using these fields with the new design
  // String _selectedCategory = 'All destinations';
  // final List<String> _categories = [
  //   'All destinations',
  //   'Bandung',
  //   'Bali',
  //   'Malang',
  // ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final popularPlaces = ref.watch(popularPlacesProvider);
    final popularTours = ref.watch(popularToursProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildCustomBottomNavigationBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          children: [
            SizedBox(height: 16.h),

            // Header with title and profile button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'new places',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.person, color: Colors.blue, size: 20.sp),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600]),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Category chips
            SizedBox(
              height: 40.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip('Suggested', isSelected: true),
                  _buildCategoryChip('Cities'),
                  _buildCategoryChip('Mountains'),
                  _buildCategoryChip('Beaches'),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Featured destination card
            popularPlaces.when(
              data: (places) {
                if (places.isEmpty) {
                  return const SizedBox.shrink();
                }
                return _buildFeaturedDestinationCard(places.first);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            ),
            SizedBox(height: 24.h),

            // Hot places section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Hot places',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 20.sp,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.go('/destinations'),
                  child: Text(
                    'See all',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Hot places grid
            popularPlaces.when(
              data: (places) {
                if (places.isEmpty) {
                  return const Center(child: Text('No places available'));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                  ),
                  itemCount: places.length.clamp(0, 4), // Show max 4 places
                  itemBuilder: (context, index) {
                    return _buildHotPlaceCard(places[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            ),
            SizedBox(height: 24.h),

            // Featured trips section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured trips',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See all',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Featured trips list
            popularTours.when(
              data: (tours) {
                if (tours.isEmpty) {
                  return const Center(child: Text('No tours available'));
                }

                return Column(
                  children: [
                    if (tours.isNotEmpty)
                      _buildTripItem('Vespa Tour', 'Rome, Italy'),
                    SizedBox(height: 12.h),
                    if (tours.length > 1)
                      _buildTripItem('Yoga retreat', 'Bali, Indonesia'),
                    SizedBox(height: 12.h),
                    if (tours.length > 2)
                      _buildTripItem('Oktoberfest', 'Munich, Germany'),
                    SizedBox(height: 12.h),
                    if (tours.length > 3)
                      _buildTripItem('Brooklyn Bridge', 'New York City, USA'),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBottomNavigationBar() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              red: 0,
              green: 0,
              blue: 0,
              alpha: 13,
            ),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(Icons.home, true),
          _buildNavBarItem(Icons.search, false),
          _buildNavBarItem(Icons.map, false),
          _buildNavBarItem(Icons.person_outline, false),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, bool isSelected) {
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Colors.amber : Colors.grey,
        size: 24.sp,
      ),
      onPressed: () {
        // Handle navigation
      },
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.black : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildFeaturedDestinationCard(Destination destination) {
    return Container(
      height: 220.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              red: 0,
              green: 0,
              blue: 0,
              alpha: 13,
            ),
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
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: Stack(
              children: [
                Image.network(
                  destination.image,
                  height: 150.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.bookmark_border,
                      color: Colors.amber,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      destination.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          destination.rating.toString(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  '${destination.region}, ${destination.country}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotPlaceCard(Destination place) {
    return GestureDetector(
      onTap: () => context.go('/detail/${place.id}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                red: 0,
                green: 0,
                blue: 0,
                alpha: 13,
              ),
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
                height: 80.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Details
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${place.region}, ${place.country}',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
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

  Widget _buildTripItem(String title, String location) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              red: 0,
              green: 0,
              blue: 0,
              alpha: 13,
            ),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Trip image
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1533105079780-92b9be482077?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Trip details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  location,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Arrow button
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.arrow_forward, color: Colors.white, size: 16.sp),
          ),
        ],
      ),
    );
  }
}
