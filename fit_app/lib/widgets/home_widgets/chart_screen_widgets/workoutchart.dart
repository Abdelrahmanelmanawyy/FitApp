import 'package:flutter/material.dart';

class WorkoutChart extends StatelessWidget {
  final int strength;
  final int cardio;
  final double? width;

  const WorkoutChart({
    Key? key,
    required this.strength,
    required this.cardio,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int maxValue = (([strength, cardio].reduce((a, b) => a > b ? a : b) ~/ 5) + 1) * 5;

    return Container(
      width: width ?? MediaQuery.of(context).size.width * 0.95,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Workouts per week',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Container(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-axis
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    int value = ((4 - index) * maxValue ~/ 4);
                    return SizedBox(
                      height: 40,
                      child: Text(
                        '$value',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  }),
                ),
                SizedBox(width: 8),

                // Strength and Cardio Bars
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 20,
                              height: (strength / maxValue) * 160,
                              color: Color(0xFF0E3D5A),
                            ),
                            SizedBox(width: 6),
                            Container(
                              width: 20,
                              height: (cardio / maxValue) * 160,
                              color: Color(0xFF00ACC1),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'This Month',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
