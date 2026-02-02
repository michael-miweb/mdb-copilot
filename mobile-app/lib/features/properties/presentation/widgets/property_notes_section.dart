import 'package:flutter/material.dart';

class PropertyNotesSection extends StatelessWidget {
  const PropertyNotesSection({required this.notes, super.key});

  final String? notes;

  @override
  Widget build(BuildContext context) {
    if (notes == null || notes!.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          notes!,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
