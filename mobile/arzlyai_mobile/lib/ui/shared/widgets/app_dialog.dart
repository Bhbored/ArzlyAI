import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppDialog {
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final result = await showShadDialog<bool>(
      context: context,
      builder: (context) {
        return ShadDialog(
          title: Text(title),
          description: Text(message),
          actions: [
            ShadButton.ghost(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ShadButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
