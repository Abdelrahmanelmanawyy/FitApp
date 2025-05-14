import 'package:fit_app/models/distane_model.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final DistanceModel session;

  const HistoryCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.directions_walk, color: Colors.blue),
        title: Text("${session.distance.toStringAsFixed(2)} meters"),
        subtitle: Text(session.timestamp),
      ),
    );
  }
}
