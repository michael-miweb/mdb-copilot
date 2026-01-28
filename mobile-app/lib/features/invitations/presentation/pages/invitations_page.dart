import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/features/invitations/data/models/invitation_model.dart';
import 'package:mdb_copilot/features/invitations/presentation/cubit/invitation_cubit.dart';
import 'package:mdb_copilot/features/invitations/presentation/cubit/invitation_state.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});

  @override
  State<InvitationsPage> createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<InvitationCubit>().loadInvitations());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvitationCubit, InvitationState>(
      listener: (context, state) {
        if (state is InvitationRevoked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invitation révoquée.')),
          );
        } else if (state is InvitationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Invitations'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.go('/invitations/send'),
            child: const Icon(Icons.add),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(InvitationState state) {
    if (state is InvitationLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is InvitationsLoaded) {
      if (state.invitations.isEmpty) {
        return const Center(
          child: Text('Aucune invitation envoyée.'),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.invitations.length,
        itemBuilder: (context, index) {
          final invitation = state.invitations[index];
          return _InvitationCard(invitation: invitation);
        },
      );
    }

    return const SizedBox.shrink();
  }
}

class _InvitationCard extends StatelessWidget {
  const _InvitationCard({required this.invitation});

  final InvitationModel invitation;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (invitation.status) {
      'accepted' => Colors.green,
      'expired' => Colors.red,
      _ => Colors.orange,
    };

    final statusLabel = switch (invitation.status) {
      'accepted' => 'Acceptée',
      'expired' => 'Expirée',
      _ => 'En attente',
    };

    final roleLabel = invitation.role == 'guest-read'
        ? 'Consultation'
        : 'Étendu';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(invitation.email),
        subtitle: Text('Rôle: $roleLabel'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: statusColor.withAlpha(25),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                statusLabel,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (invitation.status == 'pending') ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  unawaited(
                    context
                        .read<InvitationCubit>()
                        .revokeInvitation(invitation.id),
                  );
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
