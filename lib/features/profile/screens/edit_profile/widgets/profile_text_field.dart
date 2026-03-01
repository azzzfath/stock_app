import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const ProfileTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(

        controller: controller,

        style: const TextStyle(fontWeight: FontWeight.normal),

        decoration: InputDecoration(

          labelText: label,
          labelStyle: TextStyle(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),

          prefixIcon: Icon(icon, color: theme.colorScheme.primary),

          filled: true,
          fillColor: theme.colorScheme.surface,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
          ),

          // Padding dalam disesuaikan agar tingginya mirip dengan ListTile
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}