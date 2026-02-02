import 'package:flutter/material.dart';
import 'package:mdb_copilot/core/utils/currency_formatter.dart';
import 'package:mdb_copilot/core/utils/enum_formatter.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';

class PropertyInfoSection extends StatelessWidget {
  const PropertyInfoSection({required this.property, super.key});

  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations du bien',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _InfoRow(
          label: 'Type',
          value: formatPropertyType(property.propertyType),
        ),
        _InfoRow(label: 'Surface', value: '${property.surface} m²'),
        _InfoRow(label: 'Prix', value: formatPrice(property.price)),
        _InfoRow(
          label: 'Urgence',
          value: formatSaleUrgency(property.saleUrgency),
          valueColor: saleUrgencyColor(property.saleUrgency),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
