// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:karnova/widgets/contacts_list.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';

class ContactsManagementScreen extends ConsumerWidget {
  const ContactsManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use a light theme to ensure text is visible
    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF4E79FF), // Light blue primary color
          secondary: const Color(0xFFFF5A5F), // Coral accent color
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4E79FF),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Contacts'), elevation: 0),
        bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/profile'),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage Your Contacts',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Add family and friends to easily select them when planning trips',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Contacts list
              const Expanded(child: ContactsList()),
            ],
          ),
        ),
      ),
    );
  }
}
