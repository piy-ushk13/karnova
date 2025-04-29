// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:karnova/models/destination.dart';
import 'package:karnova/services/api_service.dart';
import 'package:karnova/utils/theme.dart';
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

// Provider for hotels data
final hotelsProvider = FutureProvider<List<Hotel>>((ref) async {
  try {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    // In a real app, this would fetch from an API
    // For now, we'll return mock data
    return [
      Hotel(
        id: '1',
        name: 'Taj Palace',
        location: 'Goa, India',
        description: 'Luxury beachfront hotel with stunning views',
        image:
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
        price: 12000,
        rating: 4.8,
        amenities: ['Pool', 'Spa', 'Restaurant', 'Beach Access', 'Free WiFi'],
        destinationId: '1',
      ),
      Hotel(
        id: '2',
        name: 'Himalayan Retreat',
        location: 'Manali, India',
        description: 'Cozy mountain lodge with panoramic views',
        image:
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
        price: 8000,
        rating: 4.5,
        amenities: ['Fireplace', 'Restaurant', 'Mountain View', 'Free WiFi'],
        destinationId: '2',
      ),
      Hotel(
        id: '3',
        name: 'Lakeside Resort',
        location: 'Udaipur, India',
        description: 'Elegant resort on the shores of Lake Pichola',
        image:
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
        price: 15000,
        rating: 4.9,
        amenities: ['Pool', 'Spa', 'Lake View', 'Restaurant', 'Free WiFi'],
        destinationId: '3',
      ),
      Hotel(
        id: '4',
        name: 'Desert Oasis',
        location: 'Jaisalmer, India',
        description: 'Authentic desert camp with modern amenities',
        image:
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
        price: 6000,
        rating: 4.3,
        amenities: [
          'Desert View',
          'Cultural Shows',
          'Camel Safari',
          'Free WiFi',
        ],
        destinationId: '4',
      ),
      Hotel(
        id: '5',
        name: 'Backwater Houseboat',
        location: 'Kerala, India',
        description: 'Traditional houseboat with modern comforts',
        image:
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
        price: 9000,
        rating: 4.7,
        amenities: [
          'Private Deck',
          'Traditional Cuisine',
          'Guided Tours',
          'Air Conditioning',
        ],
        destinationId: '5',
      ),
    ];
  } catch (e) {
    throw Exception('Failed to load hotels: $e');
  }
});

// Provider for filtered hotels
final filteredHotelsProvider = StateProvider.family<List<Hotel>, String>((
  ref,
  destinationId,
) {
  final hotelsAsync = ref.watch(hotelsProvider);

  return hotelsAsync.when(
    data: (hotels) {
      if (destinationId == 'all') {
        return hotels;
      } else {
        return hotels
            .where((hotel) => hotel.destinationId == destinationId)
            .toList();
      }
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Hotel model
class Hotel {
  final String id;
  final String name;
  final String location;
  final String description;
  final String image;
  final int price;
  final double rating;
  final List<String> amenities;
  final String destinationId;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.amenities,
    required this.destinationId,
  });
}

class StaysScreen extends ConsumerStatefulWidget {
  const StaysScreen({super.key});

  @override
  ConsumerState<StaysScreen> createState() => _StaysScreenState();
}

class _StaysScreenState extends ConsumerState<StaysScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDestination = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final destinationsAsync = ref.watch(destinationsProvider);
    final filteredHotels = ref.watch(
      filteredHotelsProvider(_selectedDestination),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Stays'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter functionality coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/stays'),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search hotels',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                // In a real app, this would filter the hotels
              },
            ),
          ),

          // Destination filter
          SizedBox(
            height: 50.h,
            child: destinationsAsync.when(
              data: (destinations) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: destinations.length + 1, // +1 for "All" option
                  itemBuilder: (context, index) {
                    String id = index == 0 ? 'all' : destinations[index - 1].id;
                    String name =
                        index == 0
                            ? 'All Destinations'
                            : destinations[index - 1].name;
                    bool isSelected = id == _selectedDestination;

                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ChoiceChip(
                        label: Text(
                          name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            fontSize: 14.sp,
                          ),
                        ),
                        selected: isSelected,
                        backgroundColor: Colors.white,
                        selectedColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          side: BorderSide(
                            color:
                                isSelected
                                    ? Colors.transparent
                                    : Colors.grey[300]!,
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedDestination = id;
                            });
                          }
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (_, __) => Center(
                    child: Text(
                      'Error loading destinations',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ),
            ),
          ),

          // Hotels list
          Expanded(
            child:
                filteredHotels.isEmpty
                    ? Center(
                      child: Text(
                        'No hotels available for this destination',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: filteredHotels.length,
                      itemBuilder: (context, index) {
                        final hotel = filteredHotels[index];
                        return _buildHotelCard(hotel);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Hotel hotel) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotel image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            child: Image.network(
              hotel.image,
              height: 180.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180.h,
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 40.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
          ),

          // Hotel details
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        hotel.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18.sp),
                        SizedBox(width: 4.w),
                        Text(
                          hotel.rating.toString(),
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

                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16.sp,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      hotel.location,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Description
                Text(
                  hotel.description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),

                // Amenities
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children:
                      hotel.amenities.map((amenity) {
                        return Chip(
                          label: Text(
                            amenity,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: AppTheme.primaryColor,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                ),
                SizedBox(height: 12.h),

                // Price and book button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${hotel.price}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.secondaryColor,
                          ),
                        ),
                        Text(
                          'per night',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Book hotel
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking functionality coming soon!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                      ),
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
