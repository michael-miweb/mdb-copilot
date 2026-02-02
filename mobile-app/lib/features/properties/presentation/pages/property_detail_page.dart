import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/core/utils/enum_formatter.dart';
import 'package:mdb_copilot/core/widgets/confirmation_dialog.dart';
import 'package:mdb_copilot/features/properties/presentation/cubit/property_cubit.dart';
import 'package:mdb_copilot/features/properties/presentation/cubit/property_state.dart';
import 'package:mdb_copilot/features/properties/presentation/widgets/property_agent_section.dart';
import 'package:mdb_copilot/features/properties/presentation/widgets/property_info_section.dart';
import 'package:mdb_copilot/features/properties/presentation/widgets/property_notes_section.dart';

class PropertyDetailPage extends StatefulWidget {
  const PropertyDetailPage({required this.propertyId, super.key});

  final String propertyId;

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  @override
  void initState() {
    super.initState();
    unawaited(
      context.read<PropertyCubit>().loadPropertyById(widget.propertyId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyCubit, PropertyState>(
      listener: (context, state) {
        if (state is PropertyDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fiche supprimée.'),
            ),
          );
          context.go('/properties');
        } else if (state is PropertyUpdated &&
            state.property.id == widget.propertyId) {
          unawaited(
            context
                .read<PropertyCubit>()
                .loadPropertyById(widget.propertyId),
          );
        }
      },
      child: BlocBuilder<PropertyCubit, PropertyState>(
        builder: (context, state) {
          if (state is PropertyLoading) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is PropertyError) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context
                          .read<PropertyCubit>()
                          .loadPropertyById(widget.propertyId),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is PropertyDetailLoaded) {
            final property = state.property;
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  formatPropertyType(property.propertyType),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Modifier',
                    onPressed: () => context.push(
                      '/properties/${property.id}/edit',
                      extra: property,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Supprimer',
                    onPressed: () async {
                      final confirmed =
                          await showConfirmationDialog(
                        context: context,
                        title: 'Supprimer la fiche',
                        message: 'Voulez-vous vraiment '
                            'supprimer cette fiche ?',
                        confirmText: 'Supprimer',
                      );
                      if ((confirmed ?? false) &&
                          context.mounted) {
                        unawaited(
                          context
                              .read<PropertyCubit>()
                              .deleteProperty(property.id),
                        );
                      }
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.address,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    PropertyInfoSection(property: property),
                    const SizedBox(height: 24),
                    PropertyAgentSection(property: property),
                    const SizedBox(height: 24),
                    PropertyNotesSection(
                      notes: property.notes,
                    ),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(),
            body: const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
