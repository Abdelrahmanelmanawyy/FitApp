// widgets/exercise_card.dart
import 'package:fit_app/models/workout_models.dart';
import 'package:fit_app/widgets/home_widgets/workout_screen_widgets/exersice_option_sheet.dart';
import 'package:flutter/material.dart';


class ExerciseCard extends StatelessWidget {
  final ExerciseSet exerciseSet;
  final VoidCallback onAddSet;
  final Function(int) onRemoveSet;
  final Function(int, bool) onSetCompleted;
  final Function(int, double?, int?) onUpdateSet;

  const ExerciseCard({
    Key? key,
    required this.exerciseSet,
    required this.onAddSet,
    required this.onRemoveSet,
    required this.onSetCompleted,
    required this.onUpdateSet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  exerciseSet.exercise.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                  
                    IconButton(
                      icon: const Icon(Icons.more_horiz, size: 20),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => ExerciseOptionsSheet(
                           
                            onReplace: () {
                              Navigator.pop(context);
                              // Replace exercise
                            },
                            onDelete: () {
                              Navigator.pop(context);
                              // Delete exercise
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'SET',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'KG',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'REPS',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: exerciseSet.sets.length,
              itemBuilder: (context, index) {
                final set = exerciseSet.sets[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('${index + 1}'),
                      ),
                     
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue: set.weight > 0 ? set.weight.toString() : '',
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            double? parsedValue = double.tryParse(value);
                            onUpdateSet(index, parsedValue, null);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue: set.reps > 0 ? set.reps.toString() : '',
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            int? parsedValue = int.tryParse(value);
                            onUpdateSet(index, null, parsedValue);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Checkbox(
                          value: set.isCompleted,
                          onChanged: (value) {
                            if (value != null) {
                              onSetCompleted(index, value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('ADD SET'),
                  onPressed: onAddSet,
                ),
                if (exerciseSet.sets.length > 1)
                  TextButton.icon(
                    icon: const Icon(Icons.remove, size: 16),
                    label: const Text('REMOVE SET'),
                    onPressed: () => onRemoveSet(exerciseSet.sets.length - 1),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}