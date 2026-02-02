import 'package:flutter/material.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_model.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_type_ui.dart';

class ContactFormFields extends StatelessWidget {
  const ContactFormFields({
    required this.firstNameController,
    required this.lastNameController,
    required this.companyController,
    required this.phoneController,
    required this.emailController,
    required this.notesController,
    required this.contactType,
    required this.onContactTypeChanged,
    super.key,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController companyController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController notesController;
  final ContactType contactType;
  final ValueChanged<ContactType?> onContactTypeChanged;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    final identity = _IdentitySection(
      firstNameController: firstNameController,
      lastNameController: lastNameController,
      companyController: companyController,
      contactType: contactType,
      onContactTypeChanged: onContactTypeChanged,
    );

    final coordinates = _CoordinatesSection(
      phoneController: phoneController,
      emailController: emailController,
    );

    final notes = _NotesSection(notesController: notesController);

    if (isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FocusTraversalGroup(child: identity),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: FocusTraversalGroup(child: coordinates),
              ),
            ],
          ),
          const SizedBox(height: 32),
          notes,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        identity,
        const SizedBox(height: 32),
        coordinates,
        const SizedBox(height: 32),
        notes,
      ],
    );
  }
}

// ─── Sections ────────────────────────────────────────────────

class _IdentitySection extends StatelessWidget {
  const _IdentitySection({
    required this.firstNameController,
    required this.lastNameController,
    required this.companyController,
    required this.contactType,
    required this.onContactTypeChanged,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController companyController;
  final ContactType contactType;
  final ValueChanged<ContactType?> onContactTypeChanged;

  @override
  Widget build(BuildContext context) {
    return _FormSectionGroup(
      icon: Icons.person_outline,
      title: 'Identité',
      children: [
        TextFormField(
          controller: firstNameController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Prénom *',
            prefixIcon: Icon(Icons.person_outlined),
          ),
          maxLength: 255,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le prénom est obligatoire.';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: lastNameController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Nom *',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
          maxLength: 255,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le nom est obligatoire.';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: companyController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Société',
            prefixIcon: Icon(Icons.business_outlined),
          ),
          maxLength: 255,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<ContactType>(
          initialValue: contactType,
          decoration: const InputDecoration(
            labelText: 'Type de contact *',
            prefixIcon: Icon(Icons.category_outlined),
          ),
          items: contactTypeLabels.entries
              .map(
                (e) =>
                    DropdownMenuItem(value: e.key, child: Text(e.value)),
              )
              .toList(),
          onChanged: onContactTypeChanged,
          validator: (value) {
            if (value == null) {
              return 'Le type est obligatoire.';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _CoordinatesSection extends StatelessWidget {
  const _CoordinatesSection({
    required this.phoneController,
    required this.emailController,
  });

  final TextEditingController phoneController;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return _FormSectionGroup(
      icon: Icons.contact_phone_outlined,
      title: 'Coordonnées',
      subtitle: 'Optionnel',
      children: [
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Téléphone',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
          maxLength: 50,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          maxLength: 255,
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Adresse email invalide.';
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection({required this.notesController});

  final TextEditingController notesController;

  @override
  Widget build(BuildContext context) {
    return _FormSectionGroup(
      icon: Icons.notes_outlined,
      title: 'Notes',
      children: [
        TextFormField(
          controller: notesController,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 4,
          maxLength: 10000,
          decoration: const InputDecoration(
            labelText: 'Notes libres',
            prefixIcon: Padding(
              padding: EdgeInsets.only(top: 12),
              child: Align(
                alignment: Alignment.topCenter,
                widthFactor: 1,
                heightFactor: 4,
                child: Icon(Icons.notes_outlined),
              ),
            ),
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}

// ─── Section header + fields (no card) ───────────────────────

class _FormSectionGroup extends StatelessWidget {
  const _FormSectionGroup({
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(width: 8),
              Text(
                '— $subtitle',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}
