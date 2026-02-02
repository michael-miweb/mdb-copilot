import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_state.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';
import 'package:mdb_copilot/features/properties/presentation/cubit/property_cubit.dart';
import 'package:mdb_copilot/features/properties/presentation/cubit/property_state.dart';
import 'package:mdb_copilot/features/properties/presentation/widgets/property_form_fields.dart';

/// M3 horizontal stepper form for creating/editing a property.
///
/// Used inside the desktop dialog. Mobile full-page forms continue to use
/// `CreatePropertyPanel` / `EditPropertyPanel` directly.
class PropertyFormStepper extends StatefulWidget {
  const PropertyFormStepper({
    this.property,
    this.onDone,
    super.key,
  });

  /// If null → create mode. Otherwise → edit mode.
  final PropertyModel? property;

  /// Called after a successful create or update.
  final VoidCallback? onDone;

  bool get isEditing => property != null;

  @override
  State<PropertyFormStepper> createState() => _PropertyFormStepperState();
}

class _PropertyFormStepperState extends State<PropertyFormStepper> {
  int _currentStep = 0;
  final List<GlobalKey<FormState>> _stepFormKeys =
      List.generate(3, (_) => GlobalKey<FormState>());

  // Controllers
  late final TextEditingController _addressCtl;
  late final TextEditingController _surfaceCtl;
  late final TextEditingController _priceCtl;
  late final TextEditingController _agentNameCtl;
  late final TextEditingController _agentAgencyCtl;
  late final TextEditingController _agentPhoneCtl;
  late final TextEditingController _notesCtl;
  late PropertyType _propertyType;
  late SaleUrgency _saleUrgency;

  static const List<({IconData icon, String label})> _steps = [
    (icon: Icons.home_outlined, label: 'Le bien'),
    (icon: Icons.person_outline, label: 'Agent'),
    (icon: Icons.tune_outlined, label: 'Détails'),
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.property;
    _addressCtl = TextEditingController(text: p?.address ?? '');
    _surfaceCtl = TextEditingController(
      text: p != null ? p.surface.toString() : '',
    );
    _priceCtl = TextEditingController(
      text: p != null ? (p.price ~/ 100).toString() : '',
    );
    _agentNameCtl = TextEditingController(text: p?.agentName ?? '');
    _agentAgencyCtl = TextEditingController(text: p?.agentAgency ?? '');
    _agentPhoneCtl = TextEditingController(text: p?.agentPhone ?? '');
    _notesCtl = TextEditingController(text: p?.notes ?? '');
    _propertyType = p?.propertyType ?? PropertyType.appartement;
    _saleUrgency = p?.saleUrgency ?? SaleUrgency.notSpecified;
  }

  @override
  void dispose() {
    _addressCtl.dispose();
    _surfaceCtl.dispose();
    _priceCtl.dispose();
    _agentNameCtl.dispose();
    _agentAgencyCtl.dispose();
    _agentPhoneCtl.dispose();
    _notesCtl.dispose();
    super.dispose();
  }

  // ── Navigation ──────────────────────────────────────────────────────────

  bool _validateCurrentStep() =>
      _stepFormKeys[_currentStep].currentState?.validate() ?? false;

  void _next() {
    if (!_validateCurrentStep()) return;
    setState(() => _currentStep++);
  }

  void _back() => setState(() => _currentStep--);

  // ── Submit ──────────────────────────────────────────────────────────────

  void _onSubmit() {
    // Validate all steps (IndexedStack keeps them alive).
    for (var i = 0; i < _stepFormKeys.length; i++) {
      if (!(_stepFormKeys[i].currentState?.validate() ?? false)) {
        setState(() => _currentStep = i);
        return;
      }
    }
    if (widget.isEditing) {
      _submitUpdate();
    } else {
      _submitCreate();
    }
  }

  void _submitCreate() {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) return;

    final priceEuros = int.tryParse(_priceCtl.text) ?? 0;
    final now = DateTime.now();

    final property = PropertyModel(
      id: '',
      userId: authState.user.id.toString(),
      address: _addressCtl.text.trim(),
      surface: int.parse(_surfaceCtl.text),
      price: priceEuros * 100,
      propertyType: _propertyType,
      agentName: _agentNameCtl.text.trim().isNotEmpty
          ? _agentNameCtl.text.trim()
          : null,
      agentAgency: _agentAgencyCtl.text.trim().isNotEmpty
          ? _agentAgencyCtl.text.trim()
          : null,
      agentPhone: _agentPhoneCtl.text.trim().isNotEmpty
          ? _agentPhoneCtl.text.trim()
          : null,
      saleUrgency: _saleUrgency,
      notes: _notesCtl.text.trim().isNotEmpty ? _notesCtl.text.trim() : null,
      createdAt: now,
      updatedAt: now,
    );

    unawaited(context.read<PropertyCubit>().createProperty(property));
  }

  void _submitUpdate() {
    final priceEuros = int.tryParse(_priceCtl.text) ?? 0;

    final updated = widget.property!.copyWith(
      address: _addressCtl.text.trim(),
      surface: int.tryParse(_surfaceCtl.text) ?? 0,
      price: priceEuros * 100,
      propertyType: _propertyType,
      agentName: _agentNameCtl.text.trim().isNotEmpty
          ? () => _agentNameCtl.text.trim()
          : () => null,
      agentAgency: _agentAgencyCtl.text.trim().isNotEmpty
          ? () => _agentAgencyCtl.text.trim()
          : () => null,
      agentPhone: _agentPhoneCtl.text.trim().isNotEmpty
          ? () => _agentPhoneCtl.text.trim()
          : () => null,
      saleUrgency: _saleUrgency,
      notes: _notesCtl.text.trim().isNotEmpty
          ? () => _notesCtl.text.trim()
          : () => null,
    );

    unawaited(context.read<PropertyCubit>().updateProperty(updated));
  }

  // ── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<PropertyCubit, PropertyState>(
      listener: (context, state) {
        if (state is PropertyCreated || state is PropertyUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.isEditing
                    ? 'Fiche modifiée avec succès.'
                    : 'Fiche créée avec succès.',
              ),
            ),
          );
          widget.onDone?.call();
        } else if (state is PropertyError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Column(
        children: [
          _buildStepIndicator(context),
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: colorScheme.outlineVariant,
          ),
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                _buildStepBien(),
                _buildStepAgent(),
                _buildStepDetails(),
              ],
            ),
          ),
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: colorScheme.outlineVariant,
          ),
          _buildActionBar(context),
        ],
      ),
    );
  }

  // ── Step indicator ──────────────────────────────────────────────────────

  Widget _buildStepIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MdbTokens.space32,
        vertical: MdbTokens.space16,
      ),
      child: Row(
        children: [
          for (int i = 0; i < _steps.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Padding(
                  // Push line up to align with circle center.
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    height: 2,
                    color: i <= _currentStep
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepCircle(
                  index: i,
                  isCompleted: i < _currentStep,
                  isActive: i == _currentStep,
                ),
                const SizedBox(height: MdbTokens.space4),
                Text(
                  _steps[i].label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: i <= _currentStep
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight:
                        i == _currentStep ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── Step 0 — Informations du bien ───────────────────────────────────────

  Widget _buildStepBien() {
    return Form(
      key: _stepFormKeys[0],
      child: ListView(
        padding: const EdgeInsets.all(MdbTokens.space24),
        children: [
          TextFormField(
            controller: _addressCtl,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            style: PropertyFormFields.inputTextStyle(context),
            decoration: PropertyFormFields.inputDecoration(
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
                  controller: _surfaceCtl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  style: PropertyFormFields.inputTextStyle(context),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: PropertyFormFields.inputDecoration(
                    label: 'Surface (m²) *',
                    icon: Icons.square_foot,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Obligatoire.';
                    }
                    final n = int.tryParse(value);
                    if (n == null || n < 1) return 'Min. 1 m².';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: MdbTokens.space12),
              Expanded(
                child: TextFormField(
                  controller: _priceCtl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  style: PropertyFormFields.inputTextStyle(context),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: PropertyFormFields.inputDecoration(
                    label: 'Prix (€) *',
                    icon: Icons.euro,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Obligatoire.';
                    }
                    if (int.tryParse(value) == null) return 'Nombre invalide.';
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: MdbTokens.space12),
          DropdownButtonFormField<PropertyType>(
            initialValue: _propertyType,
            style: PropertyFormFields.inputTextStyle(context),
            decoration: PropertyFormFields.inputDecoration(
              label: 'Type de bien *',
              icon: Icons.category_outlined,
            ),
            items: PropertyFormFields.propertyTypeLabels.entries
                .map(
                  (e) =>
                      DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _propertyType = v);
            },
          ),
        ],
      ),
    );
  }

  // ── Step 1 — Informations agent ─────────────────────────────────────────

  Widget _buildStepAgent() {
    return Form(
      key: _stepFormKeys[1],
      child: ListView(
        padding: const EdgeInsets.all(MdbTokens.space24),
        children: [
          Text(
            'Ces informations sont optionnelles.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: MdbTokens.space16),
          TextFormField(
            controller: _agentNameCtl,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            style: PropertyFormFields.inputTextStyle(context),
            decoration: PropertyFormFields.inputDecoration(
              label: 'Nom agent',
              icon: Icons.badge_outlined,
            ),
            maxLength: 255,
          ),
          const SizedBox(height: MdbTokens.space12),
          TextFormField(
            controller: _agentAgencyCtl,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            style: PropertyFormFields.inputTextStyle(context),
            decoration: PropertyFormFields.inputDecoration(
              label: 'Agence',
              icon: Icons.business_outlined,
            ),
            maxLength: 255,
          ),
          const SizedBox(height: MdbTokens.space12),
          TextFormField(
            controller: _agentPhoneCtl,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            style: PropertyFormFields.inputTextStyle(context),
            decoration: PropertyFormFields.inputDecoration(
              label: 'Téléphone',
              icon: Icons.phone_outlined,
            ),
            maxLength: 50,
          ),
        ],
      ),
    );
  }

  // ── Step 2 — Détails complémentaires ────────────────────────────────────

  Widget _buildStepDetails() {
    return Form(
      key: _stepFormKeys[2],
      child: ListView(
        padding: const EdgeInsets.all(MdbTokens.space24),
        children: [
          DropdownButtonFormField<SaleUrgency>(
            initialValue: _saleUrgency,
            style: PropertyFormFields.inputTextStyle(context),
            decoration: PropertyFormFields.inputDecoration(
              label: 'Urgence de vente',
              icon: Icons.speed_outlined,
            ),
            items: PropertyFormFields.saleUrgencyLabels.entries
                .map(
                  (e) =>
                      DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _saleUrgency = v);
            },
          ),
          const SizedBox(height: MdbTokens.space12),
          TextFormField(
            controller: _notesCtl,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 4,
            maxLength: 10000,
            style: PropertyFormFields.inputTextStyle(context),
            decoration: PropertyFormFields.inputDecoration(
              label: 'Notes libres',
              icon: Icons.notes_outlined,
              alignHint: true,
            ),
          ),
        ],
      ),
    );
  }

  // ── Action bar ──────────────────────────────────────────────────────────

  Widget _buildActionBar(BuildContext context) {
    final isFirst = _currentStep == 0;
    final isLast = _currentStep == _steps.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MdbTokens.space24,
        vertical: MdbTokens.space12,
      ),
      child: Row(
        children: [
          // Step counter label
          Text(
            'Étape ${_currentStep + 1} sur ${_steps.length}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const Spacer(),
          if (!isFirst)
            TextButton(
              onPressed: _back,
              child: const Text('Retour'),
            ),
          const SizedBox(width: MdbTokens.space8),
          if (isLast)
            BlocBuilder<PropertyCubit, PropertyState>(
              builder: (context, state) {
                final isLoading = state is PropertyLoading;
                return FilledButton(
                  onPressed: isLoading ? null : _onSubmit,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          widget.isEditing ? 'Sauvegarder' : 'Créer la fiche',
                        ),
                );
              },
            )
          else
            FilledButton.tonal(
              onPressed: _next,
              child: const Text('Suivant'),
            ),
        ],
      ),
    );
  }
}

// ── Step circle indicator ─────────────────────────────────────────────────

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.index,
    required this.isCompleted,
    required this.isActive,
  });

  final int index;
  final bool isCompleted;
  final bool isActive;

  static const _size = 32.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isCompleted) {
      return Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, size: 18, color: colorScheme.onPrimary),
      );
    }

    if (isActive) {
      return Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    // Inactive
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant, width: 1.5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
