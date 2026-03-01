import 'package:flutter/material.dart';

class ProfileChip extends StatelessWidget {
  final String label;

  const ProfileChip({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Chip(

      label: Text(label),
      backgroundColor: theme.colorScheme.surface,
      side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),

      labelStyle: TextStyle(
        color: theme.textTheme.bodyLarge?.color,
        fontWeight: FontWeight.w500,
      ),

    );

  }
}