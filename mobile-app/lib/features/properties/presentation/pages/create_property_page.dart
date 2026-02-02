import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/features/properties/presentation/widgets/create_property_panel.dart';

class CreatePropertyPage extends StatelessWidget {
  const CreatePropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle fiche'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: CreatePropertyPanel(
            onCreated: () => context.pop(),
          ),
        ),
      ),
    );
  }
}
