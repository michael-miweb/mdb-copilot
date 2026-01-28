import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => context.push('/invitations'),
                  icon: const Icon(Icons.group_add),
                  tooltip: 'Invitations',
                ),
              IconButton(
                onPressed: () => context.push('/profile'),
                icon: const Icon(Icons.person),
              ),
              IconButton(
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
                    : const Icon(Icons.logout),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bienvenue${user != null ? ', ${user.firstName}' : ''} !',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                if (user != null)
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
