// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karnova/utils/theme.dart';
import 'package:karnova/widgets/animated_content.dart';
import 'package:karnova/widgets/custom_bottom_navbar.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? searchData;
  
  const SearchResultsScreen({
    super.key,
    this.searchData,
  });

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  bool _isLoading = true;
  final List<Map<String, dynamic>> _results = [];
  
  @override
  void initState() {
    super.initState();
    _loadResults();
  }
  
  Future<void> _loadResults() async {
    // Simulate loading time
    await Future.delayed(const Duration(seconds: 2));
    
    // Generate mock results
    final results = [
      {
        'type': 'Flight',
        'company': 'Garuda Indonesia',
        'logo': 'https://upload.wikimedia.org/wikipedia/en/thumb/9/9b/Garuda_Indonesia_Logo.svg/250px-Garuda_Indonesia_Logo.svg.png',
        'departure': '06:40',
        'arrival': '09:15',
        'duration': '2h 35m',
        'price': 1250000,
        'source': widget.searchData?['source'] ?? 'Belgaum Karnataka India',
        'destination': widget.searchData?['destination'] ?? 'Bali',
        'sourceCode': 'CGK',
        'destinationCode': 'DPS',
        'date': widget.searchData?['startDate'] ?? DateTime.now().add(const Duration(days: 7)),
      },
      {
        'type': 'Flight',
        'company': 'Lion Air',
        'logo': 'https://upload.wikimedia.org/wikipedia/en/thumb/8/8f/Lion_Air_logo.svg/250px-Lion_Air_logo.svg.png',
        'departure': '08:15',
        'arrival': '10:45',
        'duration': '2h 30m',
        'price': 950000,
        'source': widget.searchData?['source'] ?? 'Belgaum Karnataka India',
        'destination': widget.searchData?['destination'] ?? 'Bali',
        'sourceCode': 'CGK',
        'destinationCode': 'DPS',
        'date': widget.searchData?['startDate'] ?? DateTime.now().add(const Duration(days: 7)),
      },
      {
        'type': 'Train',
        'company': 'Kereta Api Indonesia',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Logo_PT_Kereta_Api_Indonesia_%28Persero%29_2020.svg/250px-Logo_PT_Kereta_Api_Indonesia_%28Persero%29_2020.svg.png',
        'departure': '07:30',
        'arrival': '13:45',
        'duration': '6h 15m',
        'price': 350000,
        'source': widget.searchData?['source'] ?? 'Belgaum Karnataka India',
        'destination': widget.searchData?['destination'] ?? 'Yogyakarta',
        'sourceCode': 'GMR',
        'destinationCode': 'YK',
        'date': widget.searchData?['startDate'] ?? DateTime.now().add(const Duration(days: 7)),
      },
      {
        'type': 'Bus',
        'company': 'Sinar Jaya',
        'logo': '',
        'departure': '19:00',
        'arrival': '05:30',
        'duration': '10h 30m',
        'price': 180000,
        'source': widget.searchData?['source'] ?? 'Belgaum Karnataka India',
        'destination': widget.searchData?['destination'] ?? 'Bandung',
        'sourceCode': 'JKT',
        'destinationCode': 'BDG',
        'date': widget.searchData?['startDate'] ?? DateTime.now().add(const Duration(days: 7)),
      },
    ];
    
    // Filter results based on selected transport modes
    final transportModes = widget.searchData?['transportModes'] as List<String>? ?? [];
    
    if (transportModes.isNotEmpty) {
      results.removeWhere((result) => !transportModes.contains(result['type']));
    }
    
    setState(() {
      _results.addAll(results);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavbar(currentRoute: '/results'),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppTheme.textPrimaryColor,
                      size: 20.sp,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  Text(
                    'Search Results',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
            
            // Search summary
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.searchData?['source'] ?? 'Belgaum Karnataka India'} → ${widget.searchData?['destination'] ?? 'Destination'}',
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            widget.searchData?['startDate'] != null
                                ? '${widget.searchData!['startDate'].day}/${widget.searchData!['startDate'].month}/${widget.searchData!['startDate'].year}'
                                : 'Date not specified',
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: AppTheme.primaryColor,
                        size: 20.sp,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            
            // Results
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _results.isEmpty
                      ? _buildEmptyState()
                      : _buildResultsList(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.primaryColor),
          SizedBox(height: 16.h),
          Text(
            'Searching for the best options...',
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No results found',
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search criteria',
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Modify Search',
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildResultsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final result = _results[index];
        return AnimatedContent(
          delay: Duration(milliseconds: 100 * index),
          child: _buildResultCard(result),
        );
      },
    );
  }
  
  Widget _buildResultCard(Map<String, dynamic> result) {
    final date = result['date'] as DateTime;
    final formattedDate = '${date.day}/${date.month}/${date.year}';
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: _getHeaderColor(result['type']).withAlpha(20),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                // Company logo
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: result['logo'].isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            result['logo'],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              _getTransportIcon(result['type']),
                              color: _getHeaderColor(result['type']),
                              size: 24.sp,
                            ),
                          ),
                        )
                      : Icon(
                          _getTransportIcon(result['type']),
                          color: _getHeaderColor(result['type']),
                          size: 24.sp,
                        ),
                ),
                SizedBox(width: 12.w),
                
                // Company and type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result['company'],
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${result['type']} • $formattedDate',
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rp ${(result['price'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      'per person',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Route
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Departure
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result['sourceCode'],
                          style: GoogleFonts.roboto(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        Text(
                          result['departure'],
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    
                    // Route line
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            result['duration'],
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              color: AppTheme.textSecondaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4.h),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Divider(
                                color: Colors.grey[300],
                                thickness: 1,
                              ),
                              Icon(
                                _getTransportIcon(result['type']),
                                color: _getHeaderColor(result['type']),
                                size: 16.sp,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Arrival
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          result['destinationCode'],
                          style: GoogleFonts.roboto(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        Text(
                          result['arrival'],
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Show details
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: BorderSide(color: AppTheme.primaryColor),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Details',
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/ticket', extra: result);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Select',
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
  
  Color _getHeaderColor(String type) {
    switch (type) {
      case 'Flight':
        return Colors.blue;
      case 'Train':
        return Colors.orange;
      case 'Bus':
        return Colors.green;
      default:
        return AppTheme.primaryColor;
    }
  }
  
  IconData _getTransportIcon(String type) {
    switch (type) {
      case 'Flight':
        return Icons.flight;
      case 'Train':
        return Icons.train;
      case 'Bus':
        return Icons.directions_bus;
      default:
        return Icons.directions_car;
    }
  }
}
