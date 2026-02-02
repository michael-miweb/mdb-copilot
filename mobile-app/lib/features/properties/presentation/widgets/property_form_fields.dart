import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';

class PropertyFormFields extends StatelessWidget {
  const PropertyFormFields({
    required this.addressController,
    required this.surfaceController,
    required this.priceController,
    required this.agentNameController,
    required this.agentAgencyController,
    required this.agentPhoneController,
    required this.notesController,
    required this.propertyType,
    required this.saleUrgency,
    required this.onPropertyTypeChanged,
    required this.onSaleUrgencyChanged,
    super.key,
  });

  final TextEditingController addressController;
  final TextEditingController surfaceController;
  final TextEditingController priceController;
  final TextEditingController agentNameController;
  final TextEditingController agentAgencyController;
  final TextEditingController agentPhoneController;
  final TextEditingController notesController;
  final PropertyType propertyType;
  final SaleUrgency saleUrgency;
  final ValueChanged<PropertyType?> onPropertyTypeChanged;
  final ValueChanged<SaleUrgency?> onSaleUrgencyChanged;

  static const Map<PropertyType, String> propertyTypeLabels = {
    PropertyType.appartement: 'Appartement',
    PropertyType.maison: 'Maison',
    PropertyType.terrain: 'Terrain',
    PropertyType.immeuble: 'Immeuble',
    PropertyType.commercial: 'Commercial',
  };

  static const Map<SaleUrgency, String> saleUrgencyLabels = {
    SaleUrgency.notSpecified: 'Non renseigné',
    SaleUrgency.low: 'Faible',
    SaleUrgency.medium: 'Moyen',
    SaleUrgency.high: 'Élevé',
  };

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    final propertyCard = _FormSection(
      icon: Icons.home_outlined,
      title: 'Informations du bien',
      children: [
        TextFormField(
          controller: addressController,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          style: inputTextStyle(context),
          decoration: inputDecoration(
            label: 'Adresse *',
            icon: Icons.location_on_outlined,
          ),
          maxLength: 500,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "L'adresse est obligatoire.";
            }
            return null;
          },
        ),
        const SizedBox(height: MdbTokens.space12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: surfaceController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                style: inputTextStyle(context),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: inputDecoration(
                  label: 'Surface (m²) *',
                  icon: Icons.square_foot,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Obligatoire.';
                  }
                  final n = int.tryParse(value);
                  if (n == null || n < 1) {
                    return 'Min. 1 m².';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: MdbTokens.space12),
            Expanded(
              child: TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                style: inputTextStyle(context),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: inputDecoration(
                  label: 'Prix (€) *',
                  icon: Icons.euro,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Obligatoire.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Nombre invalide.';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: MdbTokens.space12),
        DropdownButtonFormField<PropertyType>(
          initialValue: propertyType,
          style: inputTextStyle(context),
          decoration: inputDecoration(
            label: 'Type de bien *',
            icon: Icons.category_outlined,
          ),
          items: propertyTypeLabels.entries
              .map(
                (e) =>
                    DropdownMenuItem(value: e.key, child: Text(e.value)),
              )
              .toList(),
          onChanged: onPropertyTypeChanged,
        ),
      ],
    );

    final agentCard = _FormSection(
      icon: Icons.person_outline,
      title: 'Informations agent',
      subtitle: 'Optionnel',
      children: [
        TextFormField(
          controller: agentNameController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          style: inputTextStyle(context),
          decoration: inputDecoration(
            label: 'Nom agent',
            icon: Icons.badge_outlined,
          ),
          maxLength: 255,
        ),
        const SizedBox(height: MdbTokens.space12),
        TextFormField(
          controller: agentAgencyController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          style: inputTextStyle(context),
          decoration: inputDecoration(
            label: 'Agence',
            icon: Icons.business_outlined,
          ),
          maxLength: 255,
        ),
        const SizedBox(height: MdbTokens.space12),
        TextFormField(
          controller: agentPhoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          style: inputTextStyle(context),
          decoration: inputDecoration(
            label: 'Téléphone',
            icon: Icons.phone_outlined,
          ),
          maxLength: 50,
        ),
      ],
    );

    final detailsCard = _FormSection(
      icon: Icons.tune_outlined,
      title: 'Détails complémentaires',
      children: [
        DropdownButtonFormField<SaleUrgency>(
          initialValue: saleUrgency,
          style: inputTextStyle(context),
          decoration: inputDecoration(
            label: 'Urgence de vente',
            icon: Icons.speed_outlined,
          ),
          items: saleUrgencyLabels.entries
              .map(
                (e) =>
                    DropdownMenuItem(value: e.key, child: Text(e.value)),
              )
              .toList(),
          onChanged: onSaleUrgencyChanged,
        ),
        const SizedBox(height: MdbTokens.space12),
        TextFormField(
          controller: notesController,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 4,
          maxLength: 10000,
          style: inputTextStyle(context),
          decoration: inputDecoration(
            label: 'Notes libres',
            icon: Icons.notes_outlined,
            alignHint: true,
          ),
        ),
      ],
    );

    if (isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: propertyCard),
                const SizedBox(width: MdbTokens.space16),
                Expanded(child: agentCard),
              ],
            ),
          ),
          const SizedBox(height: MdbTokens.space16),
          detailsCard,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        propertyCard,
        const SizedBox(height: MdbTokens.space16),
        agentCard,
        const SizedBox(height: MdbTokens.space16),
        detailsCard,
      ],
    );
  }

  static TextStyle inputTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14);
  }

  static InputDecoration inputDecoration({
    required String label,
    required IconData icon,
    bool alignHint = false,
  }) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: MdbTokens.space12,
        vertical: MdbTokens.space8,
      ),
      prefixIcon: Icon(icon, size: 20),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ),
      alignLabelWithHint: alignHint,
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.icon,
    required this.title,
    required this.children,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: MdbTokens.elevationFlat,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MdbTokens.radiusLarge),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: .45),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(MdbTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 20),
                const SizedBox(width: MdbTokens.space8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(width: MdbTokens.space8),
                  Text(
                    '— $subtitle',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
            const Divider(height: MdbTokens.space24),
            ...children,
          ],
        ),
      ),
    );
  }
}
