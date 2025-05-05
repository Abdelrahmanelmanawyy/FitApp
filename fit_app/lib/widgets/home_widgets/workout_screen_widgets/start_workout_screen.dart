import 'dart:async';

import 'package:fit_app/firebase_services/firestore_service.dart';
import 'package:fit_app/models/workout_models.dart';
import 'package:fit_app/widgets/home_widgets/workout_screen_widgets/excerciesselection.dart';
import 'package:fit_app/widgets/home_widgets/workout_screen_widgets/exersicecard.dart';
import 'package:fit_app/widgets/home_widgets/workout_screen_widgets/rename_workout.dart';
import 'package:fit_app/widgets/home_widgets/workout_screen_widgets/workout_notes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class StarterWorkout extends StatefulWidget {
  final Workout initialWorkout;

  const StarterWorkout({
    Key? key,
    required this.initialWorkout,
  }) : super(key: key);

  @override
  _StarterWorkoutState createState() => _StarterWorkoutState();
}

class _StarterWorkoutState extends State<StarterWorkout> {
  late Workout workout;
  bool isTimerRunning = false
  ;
  Duration elapsedTime =  Duration(minutes: 0, seconds: 0); 
  Timer? _timer;
  DateTime? _startTime;

  
  @override
  void initState() {
    super.initState();
    workout = widget.initialWorkout;
    startWorkout();
  }

 void startWorkout() {
  if (!isTimerRunning) {
    _startTime = DateTime.now();
  }

  _timer = Timer.periodic(const Duration(seconds: 1), (_) {
    setState(() {
      final now = DateTime.now();
      if (_startTime != null) {
        elapsedTime += now.difference(_startTime!);
        _startTime = now;
      }
    });
  });

  setState(() {
    isTimerRunning = true;
  });
}
  
 void pauseWorkout() {
  _timer?.cancel();
  _timer = null;
  _startTime = null;
  setState(() {
    isTimerRunning = false;
  });
}
  
 void completeWorkout() async {
  setState(() {
    workout.duration = elapsedTime;
    isTimerRunning = false;
  });

  await FirestoreService_workout().saveWorkout(workout);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Workout Completed'),
      content: Text('Duration: ${formatDuration(elapsedTime)}'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); 
            Navigator.pop(context); 
          },
          child: const Text('OK'),
        )
      ],
    ),
  );
}
  
  void addExercise() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ExerciseSelectionSheet(
        exercises: datasetExercises, 
        onSelect: (exercise) {
          setState(() {
            workout.exerciseSets.add(
              ExerciseSet(
                id: DateTime.now().toString(),
                exercise: exercise,
                sets: [
                  Set(id: DateTime.now().toString()),
                ],
              ),
            );
          });
          Navigator.pop(context);
        },
      ),
    );
  }
  
  void addSet(ExerciseSet exerciseSet) {
    setState(() {
      exerciseSet.sets.add(Set(id: DateTime.now().toString()));
    });
  }
  
  void removeSet(ExerciseSet exerciseSet, int index) {
    setState(() {
      exerciseSet.sets.removeAt(index);
    });
  }
  
  void setCompleted(ExerciseSet exerciseSet, int index, bool value) {
    setState(() {
      exerciseSet.sets[index].isCompleted = value;
    });
  }
  
  void updateSetValue(ExerciseSet exerciseSet, int index, {double? weight, int? reps}) {
    setState(() {
      if (weight != null) exerciseSet.sets[index].weight = weight;
      if (reps != null) exerciseSet.sets[index].reps = reps;
    });
  }
  @override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
  
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(workout.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.note_add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => WorkoutNotesDialog(
                  initialNotes: workout.notes,
                  onSave: (notes) {
                    setState(() {
                      workout.notes = notes;
                    });
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                      context: context,
                      builder: (context) => RenameWorkoutDialog(
                        initialName: workout.name,
                        onRename: (newName) {
                          setState(() {
                            workout = Workout(
                              id: workout.id,
                              name: newName,
                              date: workout.date,
                              exerciseSets: workout.exerciseSets,
                              notes: workout.notes,
                              duration: workout.duration,
                              isTimerRunning: true
                            );
                          });
                        },
                      ),
                    );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Workout timer and controls
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEE, MMM d').format(workout.date),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      formatDuration(elapsedTime),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    isTimerRunning
                        ? IconButton(
                            icon: const Icon(Icons.pause),
                            onPressed: pauseWorkout,
                          )
                        : IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: startWorkout,
                          ),
                  ],
                ),
              ],
            ),
          ),
          // Exercise list
          Expanded(
            child: ListView.builder(
              itemCount: workout.exerciseSets.length,
              itemBuilder: (context, index) {
                final exerciseSet = workout.exerciseSets[index];
                return ExerciseCard(
                  exerciseSet: exerciseSet,
                  onAddSet: () => addSet(exerciseSet),
                  onRemoveSet: (setIndex) => removeSet(exerciseSet, setIndex),
                  onSetCompleted: (setIndex, value) => setCompleted(exerciseSet, setIndex, value),
                  onUpdateSet: (setIndex, weight, reps) => updateSetValue(
                    exerciseSet, 
                    setIndex, 
                    weight: weight, 
                    reps: reps
                  ),
                );
              },
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                
                label: const Text('Add Exercise'),
                onPressed: addExercise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton(
                onPressed: completeWorkout,
                child: const Text('Finish Workout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
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

