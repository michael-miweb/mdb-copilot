import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';
import 'package:mdb_copilot/features/properties/presentation/widgets/edit_property_panel.dart';

class EditPropertyPage extends StatelessWidget {
  const EditPropertyPage({required this.property, super.key});

  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier la fiche'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: EditPropertyPanel(
            property: property,
            onUpdated: () => context.pop(),
          ),
        ),
      ),
    );
  }
}
