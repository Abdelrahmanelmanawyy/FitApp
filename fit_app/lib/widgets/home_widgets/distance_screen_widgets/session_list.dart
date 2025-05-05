import 'package:flutter/material.dart';

class SessionList extends StatelessWidget {
  final List<String> sessions;

  final ValueChanged<String> onDelete;

  const SessionList({
    Key? key,
    required this.sessions,
   
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.directions_walk),
          title: Text(sessions[index]),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: Colors.white,
                title: const Text('Delete Session'),
                content: const Text('Are you sure you want to delete this session?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {

                      Navigator.pop(context);
                    },
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
