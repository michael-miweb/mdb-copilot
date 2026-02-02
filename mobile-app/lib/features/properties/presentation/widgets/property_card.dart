import 'package:flutter/material.dart';
import 'package:mdb_copilot/core/utils/currency_formatter.dart';
import 'package:mdb_copilot/core/utils/enum_formatter.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    required this.property,
    required this.onTap,
    super.key,
  });

  final PropertyModel property;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                property.address,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    formatPrice(property.price),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  if (property.saleUrgency != SaleUrgency.notSpecified)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: saleUrgencyColor(property.saleUrgency)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        formatSaleUrgency(property.saleUrgency),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: saleUrgencyColor(property.saleUrgency),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                formatPropertyType(property.propertyType),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
