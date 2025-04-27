// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/models/destination.dart';
import 'package:karnova/models/season.dart';
import 'package:karnova/models/state.dart';
import 'package:karnova/services/api_service.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/destination_card.dart';
import 'package:karnova/widgets/global_navigation.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';

// Provider for destinations data
final destinationsProvider = FutureProvider<List<Destination>>((ref) async {
  // In a real app, this would be fetched from an API
  try {
    // Get the API service
    final apiService = ref.read(apiServiceProvider);

    // Fetch destinations
    return await apiService.getDestinations();
  } catch (e) {
    throw Exception('Failed to load destinations: $e');
  }
});

// Provider for Indian states
final statesProvider = FutureProvider<List<IndianState>>((ref) async {
  try {
    // In a real app, this would fetch from an API
    // For now, we'll return a mock list
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      IndianState(
        id: 'all',
        name: 'All States',
        region: 'All',
        capital: '',
        imageUrl: '',
        famousFor: [],
      ),
      IndianState(
        id: 'goa',
        name: 'Goa',
        region: 'West India',
        capital: 'Panaji',
        imageUrl:
            'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2',
        famousFor: ['Beaches', 'Nightlife', 'Portuguese Architecture'],
      ),
      IndianState(
        id: 'kerala',
        name: 'Kerala',
        region: 'South India',
        capital: 'Thiruvananthapuram',
        imageUrl:
            'https://images.unsplash.com/photo-1602301818347-dfbd1ce0f05c',
        famousFor: ['Backwaters', 'Ayurveda', 'Spices'],
      ),
      IndianState(
        id: 'rajasthan',
        name: 'Rajasthan',
        region: 'North India',
        capital: 'Jaipur',
        imageUrl:
            'https://images.unsplash.com/photo-1599661046289-e31897846e41',
        famousFor: ['Forts', 'Palaces', 'Desert'],
      ),
      IndianState(
        id: 'himachal',
        name: 'Himachal Pradesh',
        region: 'North India',
        capital: 'Shimla',
        imageUrl: 'https://images.unsplash.com/photo-1558436378-fda9dc0b2917',
        famousFor: ['Mountains', 'Trekking', 'Adventure Sports'],
      ),
    ];
  } catch (e) {
    throw Exception('Failed to load states: $e');
  }
});

// Provider for filtered destinations
final filteredDestinationsProvider =
    StateProvider.family<List<Destination>, Map<String, String>>((
      ref,
      filters,
    ) {
      final destinationsAsync = ref.watch(destinationsProvider);

      return destinationsAsync.when(
        data: (destinations) {
          var filteredList = List<Destination>.from(destinations);

          // Filter by state
          if (filters['state'] != null && filters['state'] != 'all') {
            filteredList =
                filteredList
                    .where(
                      (dest) =>
                          dest.region.toLowerCase().contains(
                            filters['state']!.toLowerCase(),
                          ) ||
                          dest.name.toLowerCase().contains(
                            filters['state']!.toLowerCase(),
                          ),
                    )
                    .toList();
          }

          // Filter by season
          if (filters['season'] != null && filters['season'] != 'all') {
            final season = filters['season']!.toLowerCase();
            filteredList =
                filteredList
                    .where(
                      (dest) =>
                          dest.tags.any((tag) => tag.toLowerCase() == season) ||
                          dest.tags.any(
                            (tag) => tag.toLowerCase().contains(season),
                          ),
                    )
                    .toList();
          }

          return filteredList;
        },
        loading: () => [],
        error: (_, __) => [],
      );
    });

// Provider for seasonal recommendations
final seasonalRecommendationsProvider = Provider<List<Destination>>((ref) {
  final destinationsAsync = ref.watch(destinationsProvider);

  return destinationsAsync.when(
    data: (destinations) {
      // Get current season
      final now = DateTime.now();
      String currentSeason;

      if (now.month >= 12 || now.month <= 2) {
        currentSeason = 'winter';
      } else if (now.month >= 3 && now.month <= 5) {
        currentSeason = 'summer';
      } else if (now.month >= 6 && now.month <= 9) {
        currentSeason = 'monsoon';
      } else {
        currentSeason = 'autumn';
      }

      // Filter destinations by current season
      return destinations
          .where(
            (dest) => dest.tags.any(
              (tag) => tag.toLowerCase().contains(currentSeason),
            ),
          )
          .toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

class DestinationsScreen extends ConsumerStatefulWidget {
  const DestinationsScreen({super.key});

  @override
  ConsumerState<DestinationsScreen> createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends ConsumerState<DestinationsScreen> {
  String _selectedState = 'all';
  String _selectedSeason = 'all';

  @override
  Widget build(BuildContext context) {
    final statesAsync = ref.watch(statesProvider);
    final filteredDestinations = ref.watch(
      filteredDestinationsProvider({
        'state': _selectedState,
        'season': _selectedSeason,
      }),
    );
    final seasonalRecommendations = ref.watch(seasonalRecommendationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Destinations'), elevation: 0),
      bottomNavigationBar: const CustomBottomNavbar(
        currentRoute: '/destinations',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation for larger screens
            const GlobalNavigation(currentRoute: '/destinations'),

            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Page header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore India\'s Incredible Destinations',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Discover the diverse beauty of India – from majestic mountains and serene beaches to ancient temples and vibrant cities.',
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Filter controls
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Filter Destinations',
                                    style: GoogleFonts.roboto(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),

                                  // State dropdown
                                  Row(
                                    children: [
                                      Expanded(
                                        child: statesAsync.when(
                                          data:
                                              (
                                                states,
                                              ) => DropdownButtonFormField<
                                                String
                                              >(
                                                decoration:
                                                    const InputDecoration(
                                                      labelText: 'State',
                                                      prefixIcon: Icon(
                                                        Icons.location_on,
                                                      ),
                                                    ),
                                                value: _selectedState,
                                                items:
                                                    states
                                                        .map(
                                                          (state) =>
                                                              DropdownMenuItem(
                                                                value: state.id,
                                                                child: Text(
                                                                  state.name,
                                                                ),
                                                              ),
                                                        )
                                                        .toList(),
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      _selectedState = value;
                                                    });
                                                  }
                                                },
                                              ),
                                          loading:
                                              () => const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                          error:
                                              (_, __) => const Text(
                                                'Failed to load states',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                        ),
                                      ),
                                      SizedBox(width: 16.w),

                                      // Season dropdown
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            labelText: 'Season',
                                            prefixIcon: Icon(Icons.wb_sunny),
                                          ),
                                          value: _selectedSeason,
                                          items: [
                                            const DropdownMenuItem(
                                              value: 'all',
                                              child: Text('All Seasons'),
                                            ),
                                            ...Season.getAllSeasons().map(
                                              (season) => DropdownMenuItem(
                                                value: season.id,
                                                child: Text(season.name),
                                              ),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                _selectedSeason = value;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),

                                  // Reset filters button
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _selectedState = 'all';
                                          _selectedSeason = 'all';
                                        });
                                      },
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Reset Filters'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Destinations list
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Destinations',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),

                  filteredDestinations.isEmpty
                      ? SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.h),
                            child: Column(
                              children: [
                                const CircularProgressIndicator(),
                                SizedBox(height: 16.h),
                                Text(
                                  'No destinations found. Try different filters.',
                                  style: GoogleFonts.roboto(fontSize: 16.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      : SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width >
                                            AppTheme.smallScreenBreakpoint
                                        ? 2
                                        : 1,
                                childAspectRatio: 1.2,
                                mainAxisSpacing: 16.h,
                                crossAxisSpacing: 16.w,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final destination = filteredDestinations[index];
                            return DestinationCard(
                              destination: destination,
                              onTap:
                                  () => context.go('/detail/${destination.id}'),
                            );
                          }, childCount: filteredDestinations.length),
                        ),
                      ),

                  // Seasonal recommendations
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seasonal Recommendations',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Best destinations to visit this season',
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Horizontal list of seasonal recommendations
                          SizedBox(
                            height: 200.h,
                            child:
                                seasonalRecommendations.isEmpty
                                    ? Center(
                                      child: Text(
                                        'No seasonal recommendations available',
                                        style: GoogleFonts.roboto(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    )
                                    : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: seasonalRecommendations.length,
                                      itemBuilder: (context, index) {
                                        final destination =
                                            seasonalRecommendations[index];
                                        return Container(
                                          width: 250.w,
                                          margin: EdgeInsets.only(right: 16.w),
                                          child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                            ),
                                            child: InkWell(
                                              onTap:
                                                  () => context.go(
                                                    '/detail/${destination.id}',
                                                  ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Destination image
                                                  SizedBox(
                                                    height: 120.h,
                                                    width: double.infinity,
                                                    child: Image.network(
                                                      destination.image,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          color:
                                                              Colors.grey[300],
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .image_not_supported,
                                                              size: 40.sp,
                                                              color:
                                                                  Colors
                                                                      .grey[600],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),

                                                  // Destination details
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                      12.w,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          destination.name,
                                                          style:
                                                              GoogleFonts.roboto(
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                        SizedBox(height: 4.h),
                                                        Text(
                                                          '${destination.region}, ${destination.country}',
                                                          style: GoogleFonts.roboto(
                                                            fontSize: 12.sp,
                                                            color:
                                                                Colors
                                                                    .grey[600],
                                                          ),
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                          ),
                        ],
                      ),
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
}
