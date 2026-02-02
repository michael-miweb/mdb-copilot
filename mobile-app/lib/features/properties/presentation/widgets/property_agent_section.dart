import 'package:flutter/material.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';

class PropertyAgentSection extends StatelessWidget {
  const PropertyAgentSection({required this.property, super.key});

  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hasAgent = property.agentName != null ||
        property.agentAgency != null ||
        property.agentPhone != null;

    if (!hasAgent) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agent immobilier',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (property.agentName != null)
          _AgentRow(icon: Icons.person, text: property.agentName!),
        if (property.agentAgency != null)
          _AgentRow(icon: Icons.business, text: property.agentAgency!),
        if (property.agentPhone != null)
          _AgentRow(icon: Icons.phone, text: property.agentPhone!),
      ],
    );
  }
}

class _AgentRow extends StatelessWidget {
  const _AgentRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
