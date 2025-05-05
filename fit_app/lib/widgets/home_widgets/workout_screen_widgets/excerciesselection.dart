// widgets/exercise_selection_sheet.dart
import 'package:fit_app/models/workout_models.dart';
import 'package:flutter/material.dart';



class ExerciseSelectionSheet extends StatefulWidget {
  final List<Exercise> exercises;
  final Function(Exercise) onSelect;

  const ExerciseSelectionSheet({
    Key? key,
    required this.exercises,
    required this.onSelect,
  }) : super(key: key);

  @override
  _ExerciseSelectionSheetState createState() => _ExerciseSelectionSheetState();
}

class _ExerciseSelectionSheetState extends State<ExerciseSelectionSheet> {
  String searchQuery = '';
  
  List<Exercise> get filteredExercises {
    if (searchQuery.isEmpty) return widget.exercises;
    return widget.exercises
        .where((exercise) => exercise.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Exercise',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search exercises',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                return ListTile(
                  title: Text(exercise.name),
                  subtitle: exercise.muscleGroup != null
                      ? Text(exercise.muscleGroup!)
                      : null,
                  trailing: exercise.isFavorite
                      ? const Icon(Icons.star, color: Colors.amber)
                      : null,
                  onTap: () => widget.onSelect(exercise),
                );
              },
            ),
          ),
         
        ],
      ),
    );
  }
}