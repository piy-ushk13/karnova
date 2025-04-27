// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:karnova/routes/app_router.dart';
import 'package:karnova/utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize ScreenUtil for responsive design
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Base design size (iPhone X)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'TripOnBuddy',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.lightTheme, // Use light theme for both
          themeMode: ThemeMode.light, // Always use light theme
          routerConfig: appRouter,
        );
      },
    );
  }
}
