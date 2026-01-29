import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_state.dart';
import 'package:mdb_copilot/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mdb_copilot/features/profile/presentation/cubit/profile_state.dart';
import 'package:mdb_copilot/features/profile/presentation/widgets/password_form.dart';
import 'package:mdb_copilot/features/profile/presentation/widgets/profile_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle_outlined,
                    color: theme.colorScheme.onInverseSurface,
                  ),
                  const SizedBox(width: MdbTokens.space8),
                  const Text('Modifications enregistrées.'),
                ],
              ),
            ),
          );
        } else if (state is ProfileError) {
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
                onPressed: () {},
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Semantics(
            button: true,
            label: 'Retour',
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          title: const Text('Mon profil'),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is! AuthAuthenticated) {
              return const SizedBox.shrink();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(MdbTokens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileForm(user: state.user),
                  const SizedBox(height: MdbTokens.space32),
                  const Divider(),
                  const SizedBox(height: MdbTokens.space16),
                  const PasswordForm(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
