// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// No theme provider needed as we're using light theme only

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Profile header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50.r,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.person, size: 50.sp, color: Colors.white),
                ),
                SizedBox(height: 16.h),
                Text(
                  'John Doe',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 4.h),
                Text(
                  'john.doe@example.com',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),

          // Saved Trips
          _buildListTile(
            context,
            Icons.bookmark,
            'Saved Trips',
            'View your saved trip plans',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Saved trips functionality coming soon!'),
                ),
              );
            },
          ),

          // Itinerary
          _buildListTile(
            context,
            Icons.map,
            'Your Itineraries',
            'View and manage your itineraries',
            () => context.go('/itinerary'),
          ),

          // Preferences
          _buildListTile(
            context,
            Icons.settings,
            'Preferences',
            'Customize your app experience',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Preferences functionality coming soon!'),
                ),
              );
            },
          ),

          const Divider(),

          // About
          _buildListTile(
            context,
            Icons.info,
            'About',
            'Learn more about TripOnBuddy',
            () {
              showAboutDialog(
                context: context,
                applicationName: 'TripOnBuddy',
                applicationVersion: '1.0.0',
                applicationIcon: Icon(
                  Icons.travel_explore,
                  size: 40.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                children: [
                  const Text(
                    'TripOnBuddy is your ultimate travel companion, helping you plan trips within your budget and discover new destinations.',
                  ),
                ],
              );
            },
          ),

          // Help & Support
          _buildListTile(
            context,
            Icons.help,
            'Help & Support',
            'Get assistance with the app',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Help & Support functionality coming soon!'),
                ),
              );
            },
          ),

          // Logout
          _buildListTile(
            context,
            Icons.logout,
            'Logout',
            'Sign out of your account',
            () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Logout functionality coming soon!',
                                ),
                              ),
                            );
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
