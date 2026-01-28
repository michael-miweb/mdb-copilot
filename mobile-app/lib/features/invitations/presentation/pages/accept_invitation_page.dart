import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/core/api/token_storage.dart';
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
              content: Text(state.message),
              backgroundColor: Colors.red,
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
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Créez votre compte pour rejoindre MDB Copilot',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AuthTextField(
                    controller: _firstNameController,
                    label: 'Prénom',
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le prénom est requis';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _lastNameController,
                    label: 'Nom',
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le nom est requis';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Mot de passe',
                    obscureText: true,
                    textInputAction: TextInputAction.next,
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
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _confirmController,
                    label: 'Confirmer le mot de passe',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onSubmit(),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Les mots de passe ne correspondent pas';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
