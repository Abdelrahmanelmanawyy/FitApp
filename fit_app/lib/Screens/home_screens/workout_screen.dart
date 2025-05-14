
import 'package:fit_app/constants/color.dart';
import 'package:fit_app/firebase_services/firestore_service.dart';
import 'package:fit_app/models/workout_models.dart';
import 'package:fit_app/widgets/home_widgets/workout_screen_widgets/historycard.dart';
import 'package:fit_app/widgets/home_widgets/workout_screen_widgets/start_workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Workout", style: TextStyle(fontSize: 40)),
            const SizedBox(height: 16),

            const Text(
              'QUICK START',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            
            Container(
              decoration: BoxDecoration(
                gradient: AppGradients.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => StarterWorkout(
                            initialWorkout: Workout(
                              id: 'new',
                              name: 'New Workout',
                              date: DateTime.now(),
                              exerciseSets: [],
                              isTimerRunning: true,
                              duration: Duration.zero,
                            ),
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                  backgroundColor: Colors.transparent,
                ),
                child: const Text(
                  'START AN EMPTY WORKOUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'History',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            StreamBuilder<List<Workout>>(
              stream: FirestoreService_workout().getWorkouts(),
              builder: (context, snapshot) {
                final count = snapshot.hasData ? snapshot.data!.length : 0;

                return Text(
                  "$count",
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Workout>>(
                stream: FirestoreService_workout().getWorkouts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong.'));
                  }
                  if (snapshot.hasError) {
                    print('Stream error: ${snapshot.error}');
                    return const Center(child: Text('Something went wrong.'));
                  }

                  final workouts = snapshot.data!;
                  return ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];
                      final formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(workout.date.toLocal());

                      return WorkoutHistoryCard(
                        formattedDate: formattedDate,
                        workoutName: workout.name,
                        workoutDuration: workout.duration,
                        exerciseSets: workout.exerciseSets,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
