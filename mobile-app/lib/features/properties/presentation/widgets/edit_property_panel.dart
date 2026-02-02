import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';
import 'package:mdb_copilot/features/properties/presentation/cubit/property_cubit.dart';
import 'package:mdb_copilot/features/properties/presentation/cubit/property_state.dart';
import 'package:mdb_copilot/features/properties/presentation/widgets/property_form_fields.dart';

/// Reusable edit-property form body (no Scaffold).
/// Used both inside EditPropertyPage (mobile) and the desktop side panel.
class EditPropertyPanel extends StatefulWidget {
  const EditPropertyPanel({
    required this.property,
    this.onUpdated,
    super.key,
  });

  final PropertyModel property;

  /// Called after a property is successfully updated.
  final VoidCallback? onUpdated;

  @override
  State<EditPropertyPanel> createState() => _EditPropertyPanelState();
}

class _EditPropertyPanelState extends State<EditPropertyPanel> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _addressController;
  late final TextEditingController _surfaceController;
  late final TextEditingController _priceController;
  late final TextEditingController _agentNameController;
  late final TextEditingController _agentAgencyController;
  late final TextEditingController _agentPhoneController;
  late final TextEditingController _notesController;
  late PropertyType _propertyType;
  late SaleUrgency _saleUrgency;

  @override
  void initState() {
    super.initState();
    final p = widget.property;
    _addressController = TextEditingController(text: p.address);
    _surfaceController =
        TextEditingController(text: p.surface.toString());
    _priceController =
        TextEditingController(text: (p.price ~/ 100).toString());
    _agentNameController =
        TextEditingController(text: p.agentName ?? '');
    _agentAgencyController =
        TextEditingController(text: p.agentAgency ?? '');
    _agentPhoneController =
        TextEditingController(text: p.agentPhone ?? '');
    _notesController = TextEditingController(text: p.notes ?? '');
    _propertyType = p.propertyType;
    _saleUrgency = p.saleUrgency;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _surfaceController.dispose();
    _priceController.dispose();
    _agentNameController.dispose();
    _agentAgencyController.dispose();
    _agentPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final priceEuros = int.tryParse(_priceController.text) ?? 0;

    final updated = widget.property.copyWith(
      address: _addressController.text.trim(),
      surface: int.tryParse(_surfaceController.text) ?? 0,
      price: priceEuros * 100,
      propertyType: _propertyType,
      agentName: _agentNameController.text.trim().isNotEmpty
          ? () => _agentNameController.text.trim()
          : () => null,
      agentAgency: _agentAgencyController.text.trim().isNotEmpty
          ? () => _agentAgencyController.text.trim()
          : () => null,
      agentPhone: _agentPhoneController.text.trim().isNotEmpty
          ? () => _agentPhoneController.text.trim()
          : () => null,
      saleUrgency: _saleUrgency,
      notes: _notesController.text.trim().isNotEmpty
          ? () => _notesController.text.trim()
          : () => null,
    );

    unawaited(context.read<PropertyCubit>().updateProperty(updated));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyCubit, PropertyState>(
      listener: (context, state) {
        if (state is PropertyUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fiche modifiée avec succès.'),
            ),
          );
          widget.onUpdated?.call();
        } else if (state is PropertyError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(MdbTokens.space16),
          children: [
            PropertyFormFields(
              addressController: _addressController,
              surfaceController: _surfaceController,
              priceController: _priceController,
              agentNameController: _agentNameController,
              agentAgencyController: _agentAgencyController,
              agentPhoneController: _agentPhoneController,
              notesController: _notesController,
              propertyType: _propertyType,
              saleUrgency: _saleUrgency,
              onPropertyTypeChanged: (v) {
                if (v != null) setState(() => _propertyType = v);
              },
              onSaleUrgencyChanged: (v) {
                if (v != null) setState(() => _saleUrgency = v);
              },
            ),
            const SizedBox(height: MdbTokens.space32),
            BlocBuilder<PropertyCubit, PropertyState>(
              builder: (context, state) {
                final isLoading = state is PropertyLoading;
                return FilledButton(
                  onPressed: isLoading ? null : _onSubmit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: MdbTokens.space12,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Sauvegarder',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
