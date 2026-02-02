import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_model.dart';
import 'package:mdb_copilot/features/contacts/presentation/cubit/contact_cubit.dart';
import 'package:mdb_copilot/features/contacts/presentation/cubit/contact_state.dart';
import 'package:mdb_copilot/features/contacts/presentation/widgets/contact_card.dart';

class ContactsListPage extends StatefulWidget {
  const ContactsListPage({super.key});

  @override
  State<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  ContactType? _selectedType;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ContactCubit>();
    unawaited(cubit.loadContacts());
    cubit.watchContacts();
  }

  void _onFilterChanged(ContactType? type) {
    setState(() => _selectedType = type);
    final cubit = context.read<ContactCubit>();
    if (type == null) {
      unawaited(cubit.loadContacts());
    } else {
      unawaited(cubit.loadContactsByType(type));
    }
  }

  static const Map<ContactType, String> _typeLabels = {
    ContactType.agentImmobilier: 'Agent immobilier',
    ContactType.artisan: 'Artisan',
    ContactType.notaire: 'Notaire',
    ContactType.courtier: 'Courtier',
    ContactType.autre: 'Autre',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes contacts'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/contacts/create'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(child: _buildListBody()),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Tous'),
            selected: _selectedType == null,
            onSelected: (_) => _onFilterChanged(null),
          ),
          const SizedBox(width: 8),
          ..._typeLabels.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(entry.value),
                selected: _selectedType == entry.key,
                onSelected: (_) => _onFilterChanged(entry.key),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListBody() {
    return BlocBuilder<ContactCubit, ContactState>(
      builder: (context, state) {
        if (state is ContactLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ContactError) {
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
                      context.read<ContactCubit>().loadContacts(),
                  child: const Text('R\u00e9essayer'),
                ),
              ],
            ),
          );
        }
        if (state is ContactLoaded) {
          if (state.contacts.isEmpty) {
            return const Center(
              child: Text('Aucun contact pour le moment.'),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                context.read<ContactCubit>().loadContacts(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                final contact = state.contacts[index];
                return ContactCard(
                  contact: contact,
                  onTap: () => context.go('/contacts/${contact.id}'),
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
