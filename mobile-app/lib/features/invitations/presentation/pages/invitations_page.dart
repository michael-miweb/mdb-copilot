import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';
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
    final theme = Theme.of(context);

    return BlocConsumer<InvitationCubit, InvitationState>(
      listener: (context, state) {
        if (state is InvitationRevoked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle_outlined,
                    color: theme.colorScheme.onInverseSurface,
                  ),
                  const SizedBox(width: MdbTokens.space8),
                  const Text('Invitation révoquée.'),
                ],
              ),
            ),
          );
        } else if (state is InvitationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.error_outlined,
                    color: theme.colorScheme.onError,
                  ),
                  const SizedBox(width: MdbTokens.space8),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: theme.colorScheme.error,
              action: SnackBarAction(
                label: 'Réessayer',
                textColor: theme.colorScheme.onError,
                onPressed: () {
                  unawaited(
                    context.read<InvitationCubit>().loadInvitations(),
                  );
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Invitations'),
          ),
          floatingActionButton: Semantics(
            button: true,
            label: 'Nouvelle invitation',
            child: FloatingActionButton(
              onPressed: () => context.go('/more/invitations/send'),
              child: const Icon(Icons.person_add_outlined),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, InvitationState state) {
    if (state is InvitationLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is InvitationsLoaded) {
      if (state.invitations.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(MdbTokens.space32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.group_add_outlined,
                  size: 64,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: .4),
                ),
                const SizedBox(height: MdbTokens.space16),
                Text(
                  'Aucune invitation envoyée.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: MdbTokens.space8),
                Text(
                  'Invitez un collaborateur pour commencer.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: .6),
                      ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(MdbTokens.space16),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final (statusColor, statusLabel) = switch (invitation.status) {
      'accepted' => (Colors.green, 'Acceptée'),
      'expired' => (colorScheme.outline, 'Expirée'),
      _ => (Colors.orange, 'En attente'),
    };

    final roleLabel = invitation.role == 'guest-read'
        ? 'Consultation'
        : 'Étendu';

    return Card(
      margin: const EdgeInsets.only(bottom: MdbTokens.space12),
      child: ListTile(
        leading: const Icon(Icons.mail_outlined),
        title: Text(invitation.email),
        subtitle: Text('Rôle : $roleLabel'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                statusLabel,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              backgroundColor: statusColor.withValues(alpha: .12),
              side: BorderSide.none,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            if (invitation.status == 'pending') ...[
              const SizedBox(width: MdbTokens.space4),
              Semantics(
                button: true,
                label: 'Révoquer invitation pour ${invitation.email}',
                child: IconButton(
                  onPressed: () {
                    unawaited(
                      context
                          .read<InvitationCubit>()
                          .revokeInvitation(invitation.id),
                    );
                  },
                  icon: Icon(
                    Icons.delete_outlined,
                    color: colorScheme.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
