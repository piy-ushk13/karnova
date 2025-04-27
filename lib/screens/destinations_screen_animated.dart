// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/models/destination.dart';
import 'package:karnova/services/api_service.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/animated_content.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';

// Provider for destinations
final destinationsProvider = FutureProvider<List<Destination>>((ref) async {
  try {
    final apiService = ref.read(apiServiceProvider);
    return await apiService.getDestinations();
  } catch (e) {
    throw Exception('Failed to load destinations: $e');
  }
});

class DestinationsScreenAnimated extends ConsumerStatefulWidget {
  const DestinationsScreenAnimated({super.key});

  @override
  ConsumerState<DestinationsScreenAnimated> createState() => _DestinationsScreenAnimatedState();
}

class _DestinationsScreenAnimatedState extends ConsumerState<DestinationsScreenAnimated> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final destinationsAsync = ref.watch(destinationsProvider);

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/destinations'),
      body: SafeArea(
        child: AnimatedContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with search bar
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Explore beautiful destinations',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    
                    // Search bar
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search destinations',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: AppTheme.primaryColor),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              
              // Filter chips
              AnimatedContent(
                delay: const Duration(milliseconds: 200),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', true),
                        _buildFilterChip('Beach', false),
                        _buildFilterChip('Mountain', false),
                        _buildFilterChip('City', false),
                        _buildFilterChip('Cultural', false),
                        _buildFilterChip('Adventure', false),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              
              // Destinations list
              Expanded(
                child: destinationsAsync.when(
                  data: (destinations) {
                    // Filter destinations based on search query
                    final filteredDestinations = _searchQuery.isEmpty
                        ? destinations
                        : destinations.where((destination) {
                            final name = destination.name.toLowerCase();
                            final region = destination.region.toLowerCase();
                            final country = destination.country.toLowerCase();
                            final query = _searchQuery.toLowerCase();
                            return name.contains(query) ||
                                region.contains(query) ||
                                country.contains(query);
                          }).toList();
                    
                    if (filteredDestinations.isEmpty) {
                      return AnimatedContent(
                        delay: const Duration(milliseconds: 300),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64.sp,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No destinations found',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Try a different search term',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    // Use staggered animation for the list
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: filteredDestinations.length,
                        itemBuilder: (context, index) {
                          final destination = filteredDestinations[index];
                          return AnimatedContent(
                            delay: Duration(milliseconds: 300 + (index * 100)),
                            slideBegin: const Offset(0, 0.3),
                            child: _buildDestinationCard(context, destination),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text('Error loading destinations: $error'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Handle filter selection
        },
        backgroundColor: Colors.white,
        selectedColor: AppTheme.primaryColor.withAlpha(25),
        checkmarkColor: AppTheme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      ),
    );
  }

  Widget _buildDestinationCard(BuildContext context, Destination destination) {
    return GestureDetector(
      onTap: () => context.go('/detail/${destination.id}'),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Destination image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: Stack(
                children: [
                  // Image
                  Image.network(
                    destination.image,
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(128),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                  
                  // Location info
                  Positioned(
                    bottom: 12.h,
                    left: 12.w,
                    right: 12.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Location name
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destination.name,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 2,
                                    color: Colors.black.withAlpha(128),
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${destination.region}, ${destination.country}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2,
                                        color: Colors.black.withAlpha(128),
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        // Rating
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(153),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16.sp,
                                color: Colors.amber,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                destination.rating.toString(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
            ),
            
            // Destination details
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    destination.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16.h),
                  
                  // Price and view details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Starting from',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '₹${destination.price}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      
                      // View details button
                      ElevatedButton(
                        onPressed: () => context.go('/detail/${destination.id}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
