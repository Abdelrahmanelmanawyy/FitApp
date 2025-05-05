
import 'package:fit_app/constants/color.dart';
import 'package:flutter/material.dart';

class TrackingControl extends StatelessWidget {
  final bool tracking;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final int sessionCount;

  const TrackingControl({
    Key? key,
    required this.tracking,
    required this.onStart,
    required this.onStop,
    required this.sessionCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        Text('Total Sessions: $sessionCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ElevatedButton(
  onPressed: tracking ? onStop : onStart,
  style: ElevatedButton.styleFrom(
    shape: const CircleBorder(),
    backgroundColor: AppColors.primaryColor,
    padding: const EdgeInsets.all(40), 
    elevation: 12
  ),
  child: Text(tracking ? "STOP": "GO!", style: TextStyle(
    fontSize: 30,
    color: Colors.white,
  ),)
),

      ],
    );
  }
}