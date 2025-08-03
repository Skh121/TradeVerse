import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tradeverse/features/goal/presentation/view_model/goal_state.dart';
import 'package:tradeverse/features/goal/presentation/view_model/goal_view_model.dart';

class GoalSection extends StatelessWidget {
  const GoalSection({super.key});

  // Reverting to the original cardBackgroundColor
  static const Color cardBackgroundColor = Color(0xFFf9f9f8);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalViewModel, GoalState>(
      // Changed from GoalViewModel to GoalViewModel
      builder: (context, state) {
        // Handle loading state
        if (state is GoalLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        // Handle error state
        else if (state is GoalError) {
          return Center(
            child: Text('❌ ${state.message}'),
          ); // Access message from GoalError state
        }
        // Handle loaded state
        else if (state is GoalLoaded) {
          if (state.goals.isEmpty) {
            return const Center(
              child: Text(
                'No goals found.',
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          final mainGoal =
              state.goals.first; // Still showing the first goal as the main one

          // progressValueForIndicator needs to be between 0.0 and 1.0, so divide by 100
          final double progressValueForIndicator = mainGoal.progress / 100.0;

          // Determine progress color based on the raw percentage (mainGoal.progress)
          Color progressColor;
          if (mainGoal.progress < 30.0) {
            progressColor = Colors.deepOrange; // Low progress
          } else if (mainGoal.progress < 70.0) {
            progressColor = Colors.blue; // Medium progress
          } else {
            progressColor = Colors.green; // High progress
          }

          // Format dates
          final DateFormat formatter = DateFormat('MMM dd, yyyy');
          final String formattedStartDate = formatter.format(
            mainGoal.startDate,
          );
          final String formattedEndDate = formatter.format(mainGoal.endDate);

          // Determine the goal type text
          final String goalTypeText = mainGoal.type;

          // Determine target value display based on goal type
          String formattedTargetValue;
          if (mainGoal.type == 'pnl') {
            formattedTargetValue =
                '\$${mainGoal.targetValue.toStringAsFixed(0)}';
          } else if (mainGoal.type == 'win_rate') {
            formattedTargetValue =
                '${mainGoal.targetValue.toStringAsFixed(0)}%';
          } else {
            formattedTargetValue = mainGoal.targetValue.toStringAsFixed(
              0,
            ); // Fallback
          }

          return Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              color: cardBackgroundColor,
              // Original code didn't have borderRadius, keeping it flat
              // borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8), // Original padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Use goalTypeText and period from GoalEntity
                Text(
                  "$goalTypeText Goal (${mainGoal.period})",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ), // Assuming black text for original theme
                ),
                const SizedBox(height: 4),
                // Dates from GoalEntity
                Text(
                  "$formattedStartDate \u2192 $formattedEndDate",
                  style: const TextStyle(
                    fontSize: 14,
                    color:
                        Colors
                            .grey, // Original code's text color was not specified for this, assuming grey
                  ),
                ),
                const SizedBox(height: 10),
                // Target value from GoalEntity
                Row(
                  children: [
                    const Icon(
                      Icons
                          .flag, // Using a flag icon to represent a goal/target
                      color: Color(
                        0xFFE91E63,
                      ), // Pinkish color from the image for the icon
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Target: $formattedTargetValue", // Use formattedTargetValue
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black, // Original text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // LinearProgressIndicator using the parsed progressValueForIndicator and dynamic color
                LinearProgressIndicator(
                  value: progressValueForIndicator.clamp(
                    0.0,
                    1.0,
                  ), // Clamp for safety
                  color: progressColor, // Dynamic color based on progress
                  backgroundColor:
                      Colors.grey[300], // Light grey background for the bar
                  minHeight: 7, // Original minHeight
                  // Original code didn't have borderRadius, keeping it flat
                  // borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                // Progress percentage text from GoalEntity, using mainGoal.progress directly
                Text(
                  "Progress: ${mainGoal.progress.toStringAsFixed(1)}%",
                  style: const TextStyle(
                    color: Colors.grey, // Original text style for progress
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }
        // Fallback for any other unexpected states (e.g., GoalInitial)
        return const SizedBox.shrink(); // Or a default empty state
      },
    );
  }
}
