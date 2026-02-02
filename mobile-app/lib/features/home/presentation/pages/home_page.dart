import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        final isLoading = state is AuthLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text('MDB Copilot'),
            actions: [
              if (user != null && user.role == 'owner')
                IconButton(
                  onPressed: () => context.go('/more/invitations'),
                  icon: const Icon(Icons.group_add_outlined),
                  tooltip: 'Invitations',
                ),
              IconButton(
                onPressed: () => context.go('/more/profile'),
                icon: const Icon(Icons.person_outlined),
                tooltip: 'Profil',
              ),
              Semantics(
                button: true,
                label: 'Se déconnecter',
                child: IconButton(
                  onPressed: isLoading
                      ? null
                      : () => unawaited(
                            context.read<AuthCubit>().logout(),
                          ),
                  icon: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout_outlined),
                  tooltip: 'Se déconnecter',
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(MdbTokens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenue${user != null ? ', ${user.firstName}' : ''} !',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: MdbTokens.space4),
                if (user != null)
                  Text(
                    user.email,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: .7,
                      ),
                    ),
                  ),
                const SizedBox(height: MdbTokens.space32),
                Text(
                  'Accès rapide',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: MdbTokens.space12),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: const Icon(Icons.home_work_outlined),
                    title: const Text('Mes annonces'),
                    subtitle: const Text('Consulter et gérer vos fiches'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/properties'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
