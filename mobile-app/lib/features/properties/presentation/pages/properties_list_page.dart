import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';
import 'package:mdb_copilot/features/properties/presentation/cubit/property_cubit.dart';
import 'package:mdb_copilot/features/properties/presentation/cubit/property_state.dart';
import 'package:mdb_copilot/features/properties/presentation/widgets/property_card.dart';
import 'package:mdb_copilot/features/properties/presentation/widgets/property_form_stepper.dart';

/// Desktop breakpoint matching AppShell (NavigationRail at ≥ 600 dp).
const _kDesktopBreakpoint = 600.0;

class PropertiesListPage extends StatefulWidget {
  const PropertiesListPage({super.key});

  @override
  State<PropertiesListPage> createState() => _PropertiesListPageState();
}

class _PropertiesListPageState extends State<PropertiesListPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<PropertyCubit>();
    unawaited(cubit.loadProperties());
    cubit.watchProperties();
  }

  bool _isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= _kDesktopBreakpoint;

  void _openCreatePanel() {
    if (_isDesktop(context)) {
      _showPropertyDialog(
        title: 'Nouvelle fiche',
        child: PropertyFormStepper(
          onDone: () => Navigator.of(context).pop(),
        ),
      );
    } else {
      context.go('/properties/create');
    }
  }

  void _openEditPanel(PropertyModel property) {
    if (_isDesktop(context)) {
      _showPropertyDialog(
        title: 'Modifier la fiche',
        child: PropertyFormStepper(
          property: property,
          onDone: () => Navigator.of(context).pop(),
        ),
      );
    } else {
      context.go('/properties/${property.id}');
    }
  }

  void _showPropertyDialog({
    required String title,
    required Widget child,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return Dialog(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 560,
            height: 720,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0.5, thickness: 0.5),
                const Expanded(
                  child: Center(
                    child: Text('PLACEHOLDER CONTENT'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes fiches'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreatePanel,
        child: const Icon(Icons.add),
      ),
      body: _buildListBody(),
    );
  }

  Widget _buildListBody() {
    return BlocBuilder<PropertyCubit, PropertyState>(
      builder: (context, state) {
        if (state is PropertyLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PropertyError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () =>
                      context.read<PropertyCubit>().loadProperties(),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }
        if (state is PropertyLoaded) {
          if (state.properties.isEmpty) {
            return const Center(
              child: Text('Aucune fiche pour le moment.'),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                context.read<PropertyCubit>().loadProperties(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.properties.length,
              itemBuilder: (context, index) {
                final property = state.properties[index];
                return PropertyCard(
                  property: property,
                  onTap: () => _openEditPanel(property),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
