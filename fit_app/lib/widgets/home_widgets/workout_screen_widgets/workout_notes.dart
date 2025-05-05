// widgets/workout_notes_dialog.dart
import 'package:flutter/material.dart';

class WorkoutNotesDialog extends StatefulWidget {
  final String? initialNotes;
  final Function(String?) onSave;

  const WorkoutNotesDialog({
    Key? key,
    this.initialNotes,
    required this.onSave,
  }) : super(key: key);

  @override
  _WorkoutNotesDialogState createState() => _WorkoutNotesDialogState();
}

class _WorkoutNotesDialogState extends State<WorkoutNotesDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNotes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Workout Notes'),
      content: TextField(
        controller: _controller,
        maxLines: 5,
        decoration: const InputDecoration(
          hintText: 'Add notes about this workout',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            widget.onSave(_controller.text.isEmpty ? null : _controller.text);
            Navigator.pop(context);
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}