// widgets/exercise_options_sheet.dart
import 'package:flutter/material.dart';

class ExerciseOptionsSheet extends StatelessWidget {

  final VoidCallback onReplace;
  final VoidCallback onDelete;

  const ExerciseOptionsSheet({
    Key? key,

    required this.onReplace,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Replace'),
            onTap: onReplace,
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}