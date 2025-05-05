import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_app/models/distane_model.dart';
import 'package:fit_app/models/user_model.dart';
import 'package:fit_app/models/workout_models.dart';



// ignore: camel_case_types
class FirestoreService_user {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserData(UserData data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    await _db.collection('users').doc(uid).set(data.toMap());
  }

Future<UserData?> getUserData() async {
  final uid = _auth.currentUser?.uid;
  if (uid == null) return null;

  final doc = await _db.collection('users').doc(uid).get();
  if (!doc.exists) return null;

  print(doc.data()); // Log the data for debugging
  return UserData.fromMap(doc.data()!);
}

}




class FirestoreService_workout {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save workout data for the logged-in user
  Future<void> saveWorkout(Workout workout) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    await _db.collection('users').doc(uid).collection('workouts').add({
      'name': workout.name,
      'date': workout.date.toIso8601String(),
      'duration': workout.duration.inSeconds,
      'notes': workout.notes,
      'exercises': workout.exerciseSets.map((e) => {
        'id': e.id,
        'exercise': {
          'id': e.exercise.id,
          'name': e.exercise.name,
          'notes': e.exercise.notes,
          'muscleGroup': e.exercise.muscleGroup,
        },
        'sets': e.sets.map((s) => {
          'id': s.id,
          'reps': s.reps,
          'weight': s.weight,
          'isCompleted': s.isCompleted,
        }).toList(),
      }).toList(),
    });
  }

  // Retrieve workouts for the logged-in user
  Stream<List<Workout>> getWorkouts() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return Stream.value([]); // Return an empty list if no user is logged in
    }

    return _db
        .collection('users')
        .doc(uid)
        .collection('workouts')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          final data = doc.data();
          return Workout(
            id: doc.id,
            name: data['name'] ?? 'Unnamed Workout',
            date: data['date'] != null ? DateTime.parse(data['date']) : DateTime.now(),
            duration: Duration(seconds: data['duration'] ?? 0),
            notes: data['notes'] ?? '',
            exerciseSets: (data['exercises'] as List<dynamic>).map((exerciseData) {
              final exerciseInfo = exerciseData['exercise'];
              return ExerciseSet(
                id: exerciseData['id'],
                exercise: Exercise(
                  id: exerciseInfo['id'],
                  name: exerciseInfo['name'],
                  notes: exerciseInfo['notes'],
                  muscleGroup: exerciseInfo['muscleGroup'],
                ),
                sets: (exerciseData['sets'] as List<dynamic>).map((setData) {
                  return Set(
                    id: setData['id'],
                    reps: setData['reps'],
                    weight: setData['weight'],
                    isCompleted: setData['isCompleted'],
                  );
                }).toList(),
              );
            }).toList(),
          );
        } catch (e) {
          print('Error parsing workout ${doc.id}: $e');
          return null;
        }
      }).whereType<Workout>().toList(); // Filters out nulls from failed parses
    });
  }

  // Get muscle group frequency for the logged-in user
  Stream<Map<String, int>> getMuscleGroupFrequency({DateTime? filterMonth}) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return Stream.value({}); // Return an empty map if no user is logged in
    }

    return getWorkouts().map((workouts) {
      final Map<String, int> muscleGroupCounts = {};

      for (final workout in workouts) {
        // If filter is provided, skip other months
        if (filterMonth != null &&
            (workout.date.month != filterMonth.month || workout.date.year != filterMonth.year)) {
          continue;
        }

        for (final exerciseSet in workout.exerciseSets) {
          final muscleGroup = exerciseSet.exercise.muscleGroup;
          if (muscleGroup != null && muscleGroup.isNotEmpty) {
            muscleGroupCounts[muscleGroup] = (muscleGroupCounts[muscleGroup] ?? 0) + 1;
          }
        }
      }

      return muscleGroupCounts;
    });
  }
}





// ignore: camel_case_types
class FirestoreService_Distance {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save distance session for the logged-in user
  Future<void> saveSession(DistanceModel distanceModel) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('distances')
          .add(distanceModel.toMap());
    } catch (e) {
      print('Error saving distance to Firestore: $e');
    }
  }

  // Load distance sessions for the logged-in user
  Future<List<DistanceModel>> loadSessions() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception("User not logged in");
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('distances')
          .get();
      return snapshot.docs.map((doc) {
        return DistanceModel.fromMap(doc.data());
      }).toList();
    } catch (e) {
      print('Error loading sessions: $e');
      return [];
    }
  }

  // Delete a distance session for the logged-in user
  Future<void> deleteSession(String docId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception("User not logged in");
    }

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('distances')
          .doc(docId)
          .delete();
    } catch (e) {
      print('Error deleting session: $e');
    }
  }
}
