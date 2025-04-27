// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:karnova/models/destination.dart';
import 'package:karnova/services/api_service.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/destination_card.dart';

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

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinationsAsync = ref.watch(destinationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Results'),
        // Show origin→destination and budget in subtitle
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // This would be dynamic in a real app
                Text(
                  'Delhi → Goa',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Budget: ₹20,000',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
      body: destinationsAsync.when(
        data: (destinations) {
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: DestinationCard(
                  destination: destination,
                  onTap: () => context.go('/detail/${destination.id}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Text(
                'Error loading destinations: $error',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show filter options in a modal bottom sheet
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            builder: (context) => const FilterBottomSheet(),
          );
        },
        tooltip: 'Filter',
        child: const Icon(Icons.filter_list),
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(5000, 50000);
  double _rating = 3.0;
  final List<String> _selectedCategories = [];

  final List<String> _categories = [
    'Beach',
    'Mountain',
    'Adventure',
    'Culture',
    'Relaxation',
    'Food',
    'Shopping',
    'Wildlife',
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Filter Results',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 24.h),

                // Price Range
                Text(
                  'Price Range',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 100000,
                  divisions: 20,
                  labels: RangeLabels(
                    '₹${_priceRange.start.round()}',
                    '₹${_priceRange.end.round()}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      _priceRange = values;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('₹0'), Text('₹100,000')],
                ),
                SizedBox(height: 24.h),

                // Rating
                Text(
                  'Minimum Rating',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _rating,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        label: _rating.toString(),
                        onChanged: (value) {
                          setState(() {
                            _rating = value;
                          });
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Text(_rating.toString()),
                        const Icon(Icons.star, color: Colors.amber),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Categories
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children:
                      _categories.map((category) {
                        final isSelected = _selectedCategories.contains(
                          category,
                        );
                        return FilterChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppTheme.secondaryColor,
                          backgroundColor: AppTheme.surfaceColor,
                          side: BorderSide(
                            color:
                                isSelected
                                    ? AppTheme.secondaryColor
                                    : AppTheme.dividerColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.standardBorderRadius,
                            ),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedCategories.add(category);
                              } else {
                                _selectedCategories.remove(category);
                              }
                            });
                          },
                        );
                      }).toList(),
                ),
                SizedBox(height: 32.h),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Apply filters and close sheet
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
                SizedBox(height: 8.h),

                // Reset button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _priceRange = const RangeValues(5000, 50000);
                        _rating = 3.0;
                        _selectedCategories.clear();
                      });
                    },
                    child: const Text('Reset Filters'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
