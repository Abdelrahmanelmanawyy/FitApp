// widgets/rename_workout_dialog.dart
import 'package:flutter/material.dart';

class RenameWorkoutDialog extends StatefulWidget {
  final String initialName;
  final Function(String) onRename;

  const RenameWorkoutDialog({
    Key? key,
    required this.initialName,
    required this.onRename,
  }) : super(key: key);

  @override
  _RenameWorkoutDialogState createState() => _RenameWorkoutDialogState();
}

class _RenameWorkoutDialogState extends State<RenameWorkoutDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
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
      title: const Text('Rename Workout'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Workout Name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onRename(_controller.text);
              Navigator.pop(context);
            }
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}