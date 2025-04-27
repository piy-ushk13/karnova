// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:karnova/models/travel_tip.dart';
import 'package:karnova/services/api_service.dart';

// Provider for travel tips
final travelTipsProvider = FutureProvider<List<TravelTip>>((ref) async {
  try {
    // Get the API service
    final apiService = ref.read(apiServiceProvider);

    // Fetch travel tips
    return await apiService.getTravelTips();
  } catch (e) {
    throw Exception('Failed to load travel tips: $e');
  }
});

class TipsScreen extends ConsumerWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipsAsync = ref.watch(travelTipsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Travel Tips')),
      body: tipsAsync.when(
        data: (tips) {
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: tips.length,
            itemBuilder: (context, index) {
              final tip = tips[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ExpansionTile(
                  leading: Icon(
                    _getIconData(tip.icon),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    tip.category,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            tip.items.map((item) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'Error loading travel tips: $error',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'shield':
        return Icons.shield;
      case 'savings':
        return Icons.savings;
      case 'restaurant':
        return Icons.restaurant;
      case 'luggage':
        return Icons.luggage;
      case 'directions_bus':
        return Icons.directions_bus;
      default:
        return Icons.info;
    }
  }
}
