import 'package:flutter/material.dart';
import 'dart:math' as math;

class MuscleTrainingChart extends StatelessWidget {
  final Map<String, int> muscleData;
  final String month;
  final double size;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const MuscleTrainingChart({
    required this.muscleData,
    required this.month,
    this.size = 200,
    this.onPrevious,
    this.onNext,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define colors for different muscle groups
    final Map<String, Color> muscleColors = {
      'Legs': Colors.blue,
      'Back': Colors.green,
      'Shoulders': Colors.orange,
      'Chest': Colors.amber,
      'Arms': Colors.purple,
    };

    // Calculate total workouts for percentage
    int totalWorkouts = muscleData.values.fold(0, (sum, count) => sum + count);

    // Check if there's any data to display
    bool hasData = totalWorkouts > 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: onPrevious,
            ),
            Text(
              month,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: onNext,
            ),
          ],
        ),
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (hasData)
                CustomPaint(
                  size: Size(size, size),
                  painter: MuscleProgressPainter(
                    muscleData: muscleData,
                    muscleColors: muscleColors,
                    strokeWidth: 15,
                  ),
                )
              else
                CustomPaint(
                  size: Size(size, size),
                  painter: EmptyProgressPainter(
                    strokeWidth: 15,
                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Muscle',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'Trained',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!hasData)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'No data',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (hasData)
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: muscleData.entries
                .where((entry) => entry.value > 0)
                .map((entry) {
              final muscleGroup = entry.key;
              final count = entry.value;
              final percentage =
                  ((count / totalWorkouts) * 100).toStringAsFixed(1);

              return Tooltip(
                message: '$count workouts ($percentage%) in $month',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: muscleColors[muscleGroup] ?? Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('$muscleGroup ($percentage%)'),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class MuscleProgressPainter extends CustomPainter {
  final Map<String, int> muscleData;
  final Map<String, Color> muscleColors;
  final double strokeWidth;

  MuscleProgressPainter({
    required this.muscleData,
    required this.muscleColors,
    this.strokeWidth = 15,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    int totalWorkouts =
        muscleData.values.fold(0, (sum, count) => sum + count);

    if (totalWorkouts == 0) return;

    double startAngle = -math.pi / 2;

    final sortedEntries = muscleData.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (var entry in sortedEntries) {
      final muscleGroup = entry.key;
      final count = entry.value;

      final paint = Paint()
        ..color = muscleColors[muscleGroup] ?? Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * (count / totalWorkouts);

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class EmptyProgressPainter extends CustomPainter {
  final double strokeWidth;

  EmptyProgressPainter({
    this.strokeWidth = 15,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      (size.width - strokeWidth) / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
