
// Models
class Exercise {
  final String id;
  final String name;
  final String? notes;
  final String? muscleGroup;
  bool isFavorite;
  
  Exercise({
    required this.id,
    required this.name,
    this.notes,
    this.muscleGroup,
    this.isFavorite = false,
  });
}

class Set {
  final String id;
  double weight;
  int reps;
  bool isCompleted;
  
  Set({
    required this.id,
    this.weight = 0,
    this.reps = 0,
    this.isCompleted = false,
  });
}

class ExerciseSet {
  final String id;
  final Exercise exercise;
  final List<Set> sets;
  
  ExerciseSet({
    required this.id,
    required this.exercise,
    required this.sets,
  });
}

class Workout {
  final String id;
  final String name;
  final DateTime date;
  final List<ExerciseSet> exerciseSets;
  bool? isTimerRunning ;
  String? notes;
  Duration duration;
  
  Workout({
    required this.id,
    required this.name,
    required this.date,
    required this.exerciseSets,
    this.isTimerRunning,
    this.notes,
    required this.duration,
  });
}


final List<Exercise> datasetExercises = [
  Exercise(id: '1', name: 'Bench Press', muscleGroup: 'Chest'),
  Exercise(id: '2', name: 'Squat', muscleGroup: 'Legs'),
  Exercise(id: '3', name: 'Deadlift', muscleGroup: 'Back'),
  Exercise(id: '4', name: 'Pull Ups', muscleGroup: 'Back'),
  Exercise(id: '5', name: 'Shoulder Press', muscleGroup: 'Shoulders'),
  Exercise(id: '6', name: 'Bicep Curls', muscleGroup: 'Arms'),
];
