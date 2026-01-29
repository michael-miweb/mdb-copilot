import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/core/api/token_storage.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:mdb_copilot/features/invitations/presentation/cubit/invitation_cubit.dart';
import 'package:mdb_copilot/features/invitations/presentation/cubit/invitation_state.dart';

class AcceptInvitationPage extends StatefulWidget {
  const AcceptInvitationPage({
    required this.token,
    required this.tokenStorage,
    super.key,
  });

  final String token;
  final TokenStorage tokenStorage;

  @override
  State<AcceptInvitationPage> createState() => _AcceptInvitationPageState();
}

class _AcceptInvitationPageState extends State<AcceptInvitationPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        context.read<InvitationCubit>().acceptInvitation(
              token: widget.token,
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              password: _passwordController.text,
              passwordConfirmation: _confirmController.text,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<InvitationCubit, InvitationState>(
      listener: (context, state) async {
        if (state is InvitationAccepted) {
          await widget.tokenStorage.saveToken(state.token);
          if (context.mounted) {
            context.read<AuthCubit>().updateUser(state.user);
            context.go('/home');
          }
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
                onPressed: () {},
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is InvitationLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Accepter l'invitation"),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(MdbTokens.space16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(MdbTokens.space16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.group_add_outlined,
                            size: 48,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: MdbTokens.space8),
                          Text(
                            'Créez votre compte pour rejoindre '
                            'MDB Copilot',
                            style: theme.textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: MdbTokens.space24),
                  AuthTextField(
                    controller: _firstNameController,
                    label: 'Prénom',
                    prefixIcon: const Icon(Icons.person_outlined),
                    textInputAction: TextInputAction.next,
                    semanticsLabel: 'Prénom',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le prénom est requis';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: MdbTokens.space16),
                  AuthTextField(
                    controller: _lastNameController,
                    label: 'Nom',
                    prefixIcon: const Icon(Icons.person_outlined),
                    textInputAction: TextInputAction.next,
                    semanticsLabel: 'Nom de famille',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le nom est requis';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: MdbTokens.space16),
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Mot de passe',
                    obscureText: !_passwordVisible,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: _passwordVisible
                            ? theme.colorScheme.primary
                            : null,
                      ),
                      onPressed: () => setState(
                        () => _passwordVisible = !_passwordVisible,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    semanticsLabel: 'Mot de passe',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le mot de passe est requis';
                      }
                      if (value.length < 8) {
                        return 'Le mot de passe doit contenir '
                            'au moins 8 caractères';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: MdbTokens.space16),
                  AuthTextField(
                    controller: _confirmController,
                    label: 'Confirmer le mot de passe',
                    obscureText: !_confirmVisible,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: _confirmVisible
                            ? theme.colorScheme.primary
                            : null,
                      ),
                      onPressed: () => setState(
                        () => _confirmVisible = !_confirmVisible,
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onSubmit(),
                    semanticsLabel: 'Confirmer le mot de passe',
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Les mots de passe ne correspondent pas';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: MdbTokens.space24),
                  Semantics(
                    button: true,
                    label: 'Accepter et créer mon compte',
                    child: FilledButton(
                      onPressed: isLoading ? null : _onSubmit,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Accepter et créer mon compte'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
