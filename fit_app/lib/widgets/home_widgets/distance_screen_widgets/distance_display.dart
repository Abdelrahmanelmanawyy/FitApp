// TODO Implement this library.

import 'package:flutter/material.dart';

class DistanceDisplay extends StatelessWidget {
  final double distance;

  const DistanceDisplay({Key? key, required this.distance, }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${distance.toStringAsFixed(2)} m', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
       
      ],
    );
  }
}