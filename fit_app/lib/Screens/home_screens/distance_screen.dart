import 'dart:async';
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
  final FirestoreService_Distance _firestoreService = FirestoreService_Distance();
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isDisposed = false;
  late Stream<List<DistanceModel>> _historyStream;

  String get _formattedTime {
    final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();
    _historyStream = _firestoreService.streamSessions();
  }

  void _startTimer() {
    _elapsedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isDisposed) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _elapsedSeconds = 0;
  }

  Future<void> _startSession() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    final position = await Geolocator.getCurrentPosition();
    if (mounted && !_isDisposed) {
      setState(() {
        _startPosition = position;
        _isTracking = true;
        _distanceInMeters = 0.0;
      });
      _startTimer();
    }
  }

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

    if (mounted && !_isDisposed) {
      setState(() {
        _isTracking = false;
      });
      _stopTimer();
    }
  }

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
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<DistanceModel>>(
        stream: _historyStream,
        builder: (context, snapshot) {
          final sessions = snapshot.data ?? [];

          return Column(
            children: [
              DistanceAppBarWidget(donemeter: _distanceInMeters),
              DistanceDisplay(distance: _distanceInMeters),
              Text(
                _formattedTime,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TrackingControl(
                tracking: _isTracking,
                onStart: _startSession,
                onStop: _endSession,
              ),
              const SizedBox(height: 20),
              const Text(
                'History',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${sessions.length}',
                style: const TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (snapshot.hasError)
                const Expanded(child: Center(child: Text("Error loading history")))
              else if (sessions.isEmpty)
                const Expanded(child: Center(child: Text("No history available")))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const Icon(Icons.directions_walk, color: Colors.blue),
                          title: Text("${session.distance.toStringAsFixed(2)} meters"),
                          subtitle: Text(session.timestamp),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
