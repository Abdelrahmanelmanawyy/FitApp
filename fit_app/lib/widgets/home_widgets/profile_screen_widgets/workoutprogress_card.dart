import 'package:fit_app/constants/color.dart';
import 'package:flutter/material.dart';

class WorkoutProgressCard extends StatelessWidget {
  final int exerciseNumber;
  final int exerciseGoal;

  const WorkoutProgressCard({
    super.key,
    required this.exerciseNumber,
    required this.exerciseGoal,
  });

  @override
  Widget build(BuildContext context) {
   
    final int safeGoal = exerciseGoal == 0 ? 1 : exerciseGoal;
    final double percentage = (exerciseNumber / safeGoal) * 100;
    final String percentageText = '${percentage.toStringAsFixed(0)}%';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Workout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$exerciseNumber of $exerciseGoal exercises done',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryColor, width: 4),
            ),
            child: Center(
              child: Text(
                percentageText,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
