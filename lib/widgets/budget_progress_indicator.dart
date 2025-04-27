// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BudgetProgressIndicator extends StatelessWidget {
  final int totalBudget;
  final int spentAmount;

  const BudgetProgressIndicator({
    super.key,
    required this.totalBudget,
    required this.spentAmount,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (spentAmount / totalBudget).clamp(0.0, 1.0);
    final remaining = totalBudget - spentAmount;
    
    // Determine color based on percentage
    Color progressColor;
    if (percentage < 0.5) {
      progressColor = Colors.green;
    } else if (percentage < 0.8) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Circular progress indicator
            SizedBox(
              width: 100.w,
              height: 100.w,
              child: Stack(
                children: [
                  CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 10.w,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${(percentage * 100).toInt()}%',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Used',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            
            // Budget details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Budget Overview',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildBudgetRow(
                    context,
                    'Total Budget:',
                    '₹$totalBudget',
                    Colors.black,
                  ),
                  SizedBox(height: 4.h),
                  _buildBudgetRow(
                    context,
                    'Spent:',
                    '₹$spentAmount',
                    progressColor,
                  ),
                  SizedBox(height: 4.h),
                  _buildBudgetRow(
                    context,
                    'Remaining:',
                    '₹$remaining',
                    Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBudgetRow(BuildContext context, String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
