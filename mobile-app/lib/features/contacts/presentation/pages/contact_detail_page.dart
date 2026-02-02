import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/core/db/app_database.dart';
import 'package:mdb_copilot/core/widgets/confirmation_dialog.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_model.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_type_ui.dart';
import 'package:mdb_copilot/features/contacts/presentation/cubit/contact_cubit.dart';
import 'package:mdb_copilot/features/contacts/presentation/cubit/contact_state.dart';

class ContactDetailPage extends StatefulWidget {
  const ContactDetailPage({required this.contactId, super.key});

  final String contactId;

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  List<PropertiesTableData> _linkedProperties = [];

  @override
  void initState() {
    super.initState();
    unawaited(
      context.read<ContactCubit>().loadContactById(widget.contactId),
    );
    _loadLinkedProperties();
  }

  Future<void> _loadLinkedProperties() async {
    final db = context.read<AppDatabase>();
    final rows = await (db.select(db.propertiesTable)
          ..where(
            (t) =>
                t.contactId.equals(widget.contactId) & t.deletedAt.isNull(),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    if (mounted) {
      setState(() => _linkedProperties = rows);
    }
  }

  Future<void> _onDelete(ContactModel contact) async {
    final count = _linkedProperties.length;
    final message = count > 0
        ? 'Ce contact est associé à $count fiche${count > 1 ? 's' : ''}'
            ' annonce${count > 1 ? 's' : ''}.\n\n'
            'Voulez-vous vraiment le supprimer ?'
        : 'Voulez-vous vraiment supprimer ce contact ?';

    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Supprimer le contact',
      message: message,
      confirmText: 'Supprimer',
    );
    if ((confirmed ?? false) && context.mounted) {
      unawaited(
        context.read<ContactCubit>().deleteContact(contact.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactCubit, ContactState>(
      listener: (context, state) {
        if (state is ContactDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contact supprim\u00e9.'),
            ),
          );
          context.go('/contacts');
        } else if (state is ContactUpdated &&
            state.contact.id == widget.contactId) {
          unawaited(
            context
                .read<ContactCubit>()
                .loadContactById(widget.contactId),
          );
        }
      },
      child: BlocBuilder<ContactCubit, ContactState>(
        builder: (context, state) {
          if (state is ContactLoading) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is ContactError) {
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
                          .read<ContactCubit>()
                          .loadContactById(widget.contactId),
                      child: const Text('R\u00e9essayer'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is ContactDetailLoaded) {
            final contact = state.contact;
            return Scaffold(
              appBar: AppBar(
                title: Text(contact.fullName),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Modifier',
                    onPressed: () => context.push(
                      '/contacts/${contact.id}/edit',
                      extra: contact,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Supprimer',
                    onPressed: () => _onDelete(contact),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTypeBadge(context, contact.contactType),
                    const SizedBox(height: 16),
                    if (contact.company != null &&
                        contact.company!.isNotEmpty) ...[
                      _buildInfoRow(
                        context,
                        icon: Icons.business_outlined,
                        label: 'Soci\u00e9t\u00e9',
                        value: contact.company!,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (contact.phone != null &&
                        contact.phone!.isNotEmpty) ...[
                      _buildInfoRow(
                        context,
                        icon: Icons.phone_outlined,
                        label: 'T\u00e9l\u00e9phone',
                        value: contact.phone!,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (contact.email != null &&
                        contact.email!.isNotEmpty) ...[
                      _buildInfoRow(
                        context,
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: contact.email!,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (contact.notes != null &&
                        contact.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildNotesSection(context, contact.notes!),
                    ],
                    if (contact.contactType ==
                            ContactType.agentImmobilier &&
                        _linkedProperties.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildLinkedPropertiesSection(context),
                    ],
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

  Widget _buildTypeBadge(BuildContext context, ContactType type) {
    final color = contactTypeColors[type] ?? Colors.grey;
    final label = contactTypeLabels[type] ?? 'Autre';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(value, style: theme.textTheme.bodyLarge),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context, String notes) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.notes_outlined,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Notes',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(notes, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildLinkedPropertiesSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.home_work_outlined,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Fiches annonces li\u00e9es'
              ' (${_linkedProperties.length})',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...List.generate(_linkedProperties.length, (index) {
          final prop = _linkedProperties[index];
          return ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.home_outlined, size: 20),
            title: Text(
              prop.address,
              style: theme.textTheme.bodyMedium,
            ),
            onTap: () => context.push('/properties/${prop.id}'),
          );
        }),
      ],
    );
  }
}
