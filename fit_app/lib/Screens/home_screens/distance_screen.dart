import 'package:fit_app/firebase_services/firestore_service.dart';
import 'package:fit_app/models/distane_model.dart';
import 'package:fit_app/widgets/home_widgets/distance_screen_widgets/distance_appbar.dart';
import 'package:fit_app/widgets/home_widgets/distance_screen_widgets/distance_display.dart';
import 'package:fit_app/widgets/home_widgets/distance_screen_widgets/tracking_control.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class DistanceScreen extends StatefulWidget {
  const DistanceScreen({super.key});

  @override
  State<DistanceScreen> createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  Position? _startPosition;
  Position? _endPosition;
  double _distanceInMeters = 0.0;
  bool _isTracking = false;
  int _sessionCount = 0;

  final FirestoreService_Distance _firestoreService = FirestoreService_Distance();
  final Stopwatch _stopwatch = Stopwatch();

  // Start session and start stopwatch
  Future<void> _startSession() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    final position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _startPosition = position;
        _isTracking = true;
        _distanceInMeters = 0.0;
        _stopwatch.start();  // Start the stopwatch
      });
    }
  }

  // End session, save the data, and reset the stopwatch
  Future<void> _endSession() async {
    if (!_isTracking) return;

    final position = await Geolocator.getCurrentPosition();
    _endPosition = position;

    if (_startPosition != null && _endPosition != null) {
      _distanceInMeters = Geolocator.distanceBetween(
        _startPosition!.latitude,
        _startPosition!.longitude,
        _endPosition!.latitude,
        _endPosition!.longitude,
      );

      final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      await _firestoreService.saveSession(
        DistanceModel(
          distance: _distanceInMeters,
          timestamp: timestamp,
        ),
      );
    }

    if (mounted) {
      setState(() {
        _sessionCount++;  // Increment session count
        _isTracking = false;  // Stop tracking
        _stopwatch.stop();  // Stop the stopwatch
        _stopwatch.reset();  // Reset the stopwatch
      });
    }
  }

  // Handle permission request for location access
  Future<bool> _handlePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always && permission != LocationPermission.whileInUse) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTime = _stopwatch.elapsed;  // Get the elapsed time

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          DistanceAppBarWidget(donemeter: _distanceInMeters),
          DistanceDisplay(
            distance: _distanceInMeters,
            elapsed: elapsedTime,  // Pass the elapsed time to DistanceDisplay
          ),
          const SizedBox(height: 20),
          TrackingControl(
            tracking: _isTracking,
            onStart: _startSession,
            onStop: _endSession,
            sessionCount: _sessionCount,  // Pass the actual session count
          ),
        ],
      ),
    );
  }
}
