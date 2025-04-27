// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:karnova/widgets/global_navigation.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // In a real app, this would send the form data to a backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Thank you for your message! We\'ll get back to you soon.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us'), elevation: 0),
      bottomNavigationBar: GlobalNavigation.buildBottomNavigationBar(
        context,
        '/contact',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation for larger screens
            const GlobalNavigation(currentRoute: '/contact'),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Get in Touch',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'We\'d love to hear from you! Fill out the form below and we\'ll get back to you as soon as possible.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 24.h),

                      // Contact form and info in a row for larger screens, column for smaller screens
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            // Larger screens: side-by-side layout
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Contact form
                                Expanded(flex: 3, child: _buildContactForm()),
                                SizedBox(width: 24.w),
                                // Contact info
                                Expanded(flex: 2, child: _buildContactInfo()),
                              ],
                            );
                          } else {
                            // Smaller screens: stacked layout
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Contact form
                                _buildContactForm(),
                                SizedBox(height: 32.h),
                                // Contact info
                                _buildContactInfo(),
                              ],
                            );
                          }
                        },
                      ),

                      SizedBox(height: 32.h),

                      // Map
                      Text(
                        'Our Location',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: SizedBox(
                          height: 200.h,
                          width: double.infinity,
                          child: Image.network(
                            'https://maps.googleapis.com/maps/api/staticmap?center=Bengaluru,India&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7CBengaluru,India&key=YOUR_API_KEY',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.map,
                                        size: 48.sp,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        'Map image not available',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
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

  Widget _buildContactForm() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send us a Message',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Your Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Subject field
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  prefixIcon: Icon(Icons.subject),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Message field
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Your Message',
                  prefixIcon: Icon(Icons.message),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.send),
                  label: const Text('Send Message'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),

            // Address
            _buildContactItem(
              context,
              Icons.location_on,
              'Address',
              '123 Travel Street, Koramangala\nBengaluru, Karnataka 560034\nIndia',
            ),
            SizedBox(height: 16.h),

            // Phone
            _buildContactItem(context, Icons.phone, 'Phone', '+91 98765 43210'),
            SizedBox(height: 16.h),

            // Email
            _buildContactItem(
              context,
              Icons.email,
              'Email',
              'info@triponbuddy.com',
            ),
            SizedBox(height: 16.h),

            // Working hours
            _buildContactItem(
              context,
              Icons.access_time,
              'Working Hours',
              'Monday - Friday: 9:00 AM - 6:00 PM\nSaturday: 10:00 AM - 4:00 PM\nSunday: Closed',
            ),
            SizedBox(height: 16.h),

            // Social media
            Text(
              'Follow Us',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                _buildSocialIcon(context, Icons.facebook, Colors.blue),
                SizedBox(width: 16.w),
                _buildSocialIcon(context, Icons.telegram, Colors.blue),
                SizedBox(width: 16.w),
                _buildSocialIcon(context, Icons.camera_alt, Colors.pink),
                SizedBox(width: 16.w),
                _buildSocialIcon(context, Icons.chat_bubble, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String title,
    String content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Padding(
          padding: EdgeInsets.only(left: 28.w),
          child: Text(content, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(BuildContext context, IconData icon, Color color) {
    // Extract RGB values safely
    int red = 0;
    int green = 0;
    int blue = 0;

    // Handle different color types
    if (color == Colors.blue) {
      red = 33;
      green = 150;
      blue = 243; // Approximate RGB for Colors.blue
    } else if (color == Colors.red) {
      red = 244;
      green = 67;
      blue = 54; // Approximate RGB for Colors.red
    } else if (color == Colors.green) {
      red = 76;
      green = 175;
      blue = 80; // Approximate RGB for Colors.green
    } else {
      // Default fallback
      red = 100;
      green = 100;
      blue = 100;
    }

    return InkWell(
      onTap: () {
        // In a real app, this would open the social media page
      },
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Color.fromRGBO(red, green, blue, 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24.sp),
      ),
    );
  }
}
