// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:karnova/widgets/global_navigation.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us'), elevation: 0),
      bottomNavigationBar: GlobalNavigation.buildBottomNavigationBar(
        context,
        '/about',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation for larger screens
            const GlobalNavigation(currentRoute: '/about'),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'About TripOnBuddy',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.h),

                      // Company image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                          height: 200.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Our story
                      Text(
                        'Our Story',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'TripOnBuddy was founded in 2023 with a simple mission: to make travel planning easier, more affordable, and more enjoyable for everyone. We believe that travel should be accessible to all, regardless of budget constraints.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Our team of travel enthusiasts and tech experts came together to create a platform that combines cutting-edge technology with deep travel expertise. We\'re passionate about helping people discover the incredible diversity of India, from its bustling cities to its serene natural landscapes.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 24.h),

                      // Our mission
                      Text(
                        'Our Mission',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'At TripOnBuddy, we\'re on a mission to revolutionize travel planning by:',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 8.h),
                      _buildBulletPoint(
                        context,
                        'Making travel planning simple and stress-free',
                      ),
                      _buildBulletPoint(
                        context,
                        'Helping travelers stick to their budgets without compromising on experiences',
                      ),
                      _buildBulletPoint(
                        context,
                        'Showcasing the incredible diversity of destinations across India',
                      ),
                      _buildBulletPoint(
                        context,
                        'Providing personalized recommendations based on traveler preferences',
                      ),
                      _buildBulletPoint(
                        context,
                        'Supporting local communities and sustainable tourism practices',
                      ),
                      SizedBox(height: 24.h),

                      // Our team
                      Text(
                        'Our Team',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Team members grid
                      GridView.count(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 3 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16.h,
                        crossAxisSpacing: 16.w,
                        children: [
                          _buildTeamMember(
                            context,
                            'https://randomuser.me/api/portraits/women/44.jpg',
                            'Priya Sharma',
                            'Founder & CEO',
                          ),
                          _buildTeamMember(
                            context,
                            'https://randomuser.me/api/portraits/men/32.jpg',
                            'Rahul Patel',
                            'CTO',
                          ),
                          _buildTeamMember(
                            context,
                            'https://randomuser.me/api/portraits/women/68.jpg',
                            'Ananya Singh',
                            'Head of Travel',
                          ),
                          _buildTeamMember(
                            context,
                            'https://randomuser.me/api/portraits/men/75.jpg',
                            'Vikram Mehta',
                            'Lead Developer',
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Contact us button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/contact');
                          },
                          icon: const Icon(Icons.email),
                          label: const Text('Contact Us'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8.h),
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
    BuildContext context,
    String imageUrl,
    String name,
    String role,
  ) {
    return Column(
      children: [
        CircleAvatar(radius: 50.r, backgroundImage: NetworkImage(imageUrl)),
        SizedBox(height: 8.h),
        Text(
          name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          role,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
