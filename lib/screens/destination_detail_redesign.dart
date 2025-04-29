// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/models/destination.dart';
import 'package:karnova/services/api_service.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';

// Provider for destination details
final destinationDetailProvider = FutureProvider.family<Destination, String>((
  ref,
  id,
) async {
  try {
    final apiService = ref.read(apiServiceProvider);
    return await apiService.getDestinationById(id);
  } catch (e) {
    throw Exception('Failed to load destination: $e');
  }
});

class DestinationDetailScreen extends ConsumerStatefulWidget {
  final String destinationId;

  const DestinationDetailScreen({super.key, required this.destinationId});

  @override
  ConsumerState<DestinationDetailScreen> createState() =>
      _DestinationDetailScreenState();
}

class _DestinationDetailScreenState
    extends ConsumerState<DestinationDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final destinationAsync = ref.watch(
      destinationDetailProvider(widget.destinationId),
    );

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/detail'),
      body: destinationAsync.when(
        data: (destination) => _buildContent(destination),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) =>
                Center(child: Text('Error loading destination: $error')),
      ),
    );
  }

  Widget _buildContent(Destination destination) {
    return Stack(
      children: [
        // Background image with gradient overlay
        Container(
          height: 300.h,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(destination.image),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withAlpha(150)],
              ),
            ),
          ),
        ),

        // Main content
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and trip members
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(50),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(50),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '5 ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            'trip members',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Trip details section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Destination title
                          Text(
                            'Trip to ${destination.name.toLowerCase()} ${destination.region.toLowerCase()}',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // Trip dates
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 18.sp,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'September 11 - September 18',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Tab bar
                          TabBar(
                            controller: _tabController,
                            indicatorColor: Colors.red,
                            indicatorWeight: 3,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            tabs: const [
                              Tab(text: 'Overview'),
                              Tab(text: 'Trip plan'),
                              Tab(text: 'Budget'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Tab content
                    SizedBox(
                      height: 400.h,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Overview tab
                          _buildOverviewTab(destination),

                          // Trip plan tab
                          _buildTripPlanTab(destination),

                          // Budget tab
                          _buildBudgetTab(destination),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(Destination destination) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),

          // Flight info
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.flight, color: Colors.blue[400], size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                'Your flight is Garuda Indonesia',
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Trip description
          Text(
            'You will take part in a one-week trip service with full service lodging, transportation and logistics availability that will fulfill your trip, of course, guided by a getprofessional tour guide.',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),

          // Trip section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trip',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          Text(
            'There are 14 tourist destinations in the klaten area and you will visit them for one week.',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),

          // Destination cards
          SizedBox(
            height: 180.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildDestinationCard(
                  'Kebun pink',
                  '11 September 2022',
                  'https://images.unsplash.com/photo-1570168007204-dfb528c6958f',
                ),
                _buildDestinationCard(
                  'Kebun teh',
                  '12 September 2022',
                  'https://images.unsplash.com/photo-1566375638485-1c181e0c3720',
                ),
                _buildDestinationCard(
                  'Parangtritis',
                  '13 September 2022',
                  'https://images.unsplash.com/photo-1537996194471-e657df975ab4',
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Travelers section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Traveler (5)',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Traveler avatars
          Row(
            children: List.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: CircleAvatar(
                  radius: 24.r,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=${index + 1}',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripPlanTab(Destination destination) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day 1
          _buildDaySection('Day 1', 'Thursday, 11 Sept 2022', [
            _buildTripActivity(
              'Kebun pink',
              'Klaten central java',
              'Tour around on horseback and get to know the culture of the local people in a traditional way.',
              'https://images.unsplash.com/photo-1570168007204-dfb528c6958f',
            ),
            _buildTripActivity(
              'Siwalan bogor',
              'Klaten central java',
              'A tour of the palm plantation, of course, by trying the taste of the palm fruit that is directly picked from the tree.',
              'https://images.unsplash.com/photo-1566375638485-1c181e0c3720',
            ),
          ]),

          SizedBox(height: 24.h),

          // Day 2
          _buildDaySection('Day 2', 'Thursday, 12 Sept 2022', [
            _buildTripActivity(
              'Candinan',
              'Klaten central java',
              'Tourism is a tour of the relics of the Hindu-Buddhist religious temples in the Klaten area.',
              'https://images.unsplash.com/photo-1537996194471-e657df975ab4',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildBudgetTab(Destination destination) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Budget summary
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Budget',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${(destination.price * 5).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Spent: ₹${(destination.price * 3.5).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Remaining: ₹${(destination.price * 1.5).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Expense categories
          Text(
            'Expense Categories',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),

          _buildExpenseCategory(
            'Transportation',
            '₹${(destination.price * 1.2).toStringAsFixed(2)}',
            0.3,
            Colors.blue,
          ),
          SizedBox(height: 12.h),
          _buildExpenseCategory(
            'Accommodation',
            '₹${(destination.price * 1.5).toStringAsFixed(2)}',
            0.4,
            Colors.orange,
          ),
          SizedBox(height: 12.h),
          _buildExpenseCategory(
            'Food & Drinks',
            '₹${(destination.price * 0.8).toStringAsFixed(2)}',
            0.2,
            Colors.green,
          ),
          SizedBox(height: 12.h),
          _buildExpenseCategory(
            'Activities',
            '₹${(destination.price * 0.5).toStringAsFixed(2)}',
            0.1,
            Colors.purple,
          ),
          SizedBox(height: 12.h),
          _buildExpenseCategory(
            'Shopping',
            '₹${(destination.price * 0.3).toStringAsFixed(2)}',
            0.05,
            Colors.red,
          ),

          SizedBox(height: 24.h),

          // Add expense button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Add Expense',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(String name, String date, String imageUrl) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            child: Image.network(
              imageUrl,
              height: 100.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Details
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  date,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySection(String day, String date, List<Widget> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  date,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.grey[600]),
                onPressed: () {},
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...activities,
      ],
    );
  }

  Widget _buildTripActivity(
    String name,
    String location,
    String description,
    String imageUrl,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imageUrl,
              width: 60.w,
              height: 60.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),

          // Activity details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  location,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 8.h),
                Text(
                  description,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCategory(
    String category,
    String amount,
    double progress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
            Text(
              amount,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8.h,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ],
    );
  }
}
