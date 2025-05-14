import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WorkoutChart extends StatelessWidget {
  final Map<String, Map<String, int>> data;

  const WorkoutChart({
    Key? key,
    required this.data, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxY = _calculateMaxY(data);

    return Column(
      children: [
        const Text(
          'Workouts per week',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Removed cardio indicator
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Indicator(color: Color.fromARGB(255, 77, 23, 153), text: "Strength Workouts"),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barGroups: List.generate(data.length, (index) {
                String week = data.keys.elementAt(index);
                var workouts = data[week]!;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: workouts['strength']!.toDouble(),
                      color: const Color.fromARGB(255, 77, 23, 153),
                      width: 30, // Increased width for single bar
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                );
              }),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      int index = value.toInt();
                      if (index < data.length) {
                        String week = data.keys.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            week,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      if (value % 5 == 0) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                    interval: 1,
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  double _calculateMaxY(Map<String, Map<String, int>> data) {
    final maxStrength = data.values
        .map((d) => d['strength']!)
        .fold<int>(0, (prev, curr) => curr > prev ? curr : prev);
    return (maxStrength + 5).toDouble();
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const Indicator({Key? key, required this.color, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}


Map<String, Map<String, int>> groupDataByWeek(List<String> timestamps, List<Map<String, int>> workouts) {
  Map<String, Map<String, int>> groupedData = {};
  for (int i = 0; i < timestamps.length; i++) {
    String timestamp = timestamps[i];
    DateTime date = DateTime.parse(timestamp);
    String week = getWeek(date);

    if (!groupedData.containsKey(week)) {
      groupedData[week] = {'strength': 0};
    }

    groupedData[week]!['strength'] = groupedData[week]!['strength']! + workouts[i]['strength']!;
  }
  return groupedData;
}

String getWeek(DateTime date) {
  int startDay = 1;
  int weekNumber = ((date.difference(DateTime(date.year, date.month, startDay)).inDays) / 7).floor() + 1;
  return 'Week $weekNumber';
}
