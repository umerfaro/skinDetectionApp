import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Exit App'),
      content: const Text('Are you sure you want to exit?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => SystemNavigator.pop(),
          child: const Text('Exit'),
        ),
      ],
    );
  }
}
