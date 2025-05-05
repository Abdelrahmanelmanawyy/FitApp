// TODO Implement this library.

import 'package:flutter/material.dart';

class DistanceDisplay extends StatelessWidget {
  final double distance;
  final Duration elapsed;
  const DistanceDisplay({Key? key, required this.distance, required this.elapsed}) : super(key: key);

  String _formatDuration(Duration d) => d.toString().split('.').first.padLeft(8, '0');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${distance.toStringAsFixed(2)} m', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Time: ${_formatDuration(elapsed)}', style: const TextStyle(fontSize: 24)),
      ],
    );
  }
}