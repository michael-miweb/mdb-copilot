import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_state.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Scaffold(
          appBar: AppBar(title: const Text('Plus')),
          body: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: MdbTokens.space8,
            ),
            children: [
              if (user != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MdbTokens.space16,
                    vertical: MdbTokens.space16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: MdbTokens.space4),
                      Text(
                        user.email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: .6),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
              ListTile(
                leading: const Icon(Icons.person_outlined),
                title: const Text('Mon profil'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/more/profile'),
              ),
              if (user != null && user.role == 'owner')
                ListTile(
                  leading: const Icon(Icons.group_add_outlined),
                  title: const Text('Invitations'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/more/invitations'),
                ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                  color: theme.colorScheme.error,
                ),
                title: Text(
                  'Se déconnecter',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                onTap: () => unawaited(
                  context.read<AuthCubit>().logout(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
