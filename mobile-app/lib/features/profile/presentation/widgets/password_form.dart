import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';
import 'package:mdb_copilot/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:mdb_copilot/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mdb_copilot/features/profile/presentation/cubit/profile_state.dart';

class PasswordForm extends StatefulWidget {
  const PasswordForm({super.key});

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _currentVisible = false;
  bool _newVisible = false;
  bool _confirmVisible = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        context.read<ProfileCubit>().updatePassword(
              currentPassword: _currentController.text,
              newPassword: _newController.text,
              confirmPassword: _confirmController.text,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final isLoading = state is ProfileLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Modifier le mot de passe',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: MdbTokens.space16),
              AuthTextField(
                controller: _currentController,
                label: 'Mot de passe actuel',
                obscureText: !_currentVisible,
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _currentVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: _currentVisible
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  onPressed: () =>
                      setState(() => _currentVisible = !_currentVisible),
                ),
                textInputAction: TextInputAction.next,
                semanticsLabel: 'Mot de passe actuel',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe actuel';
                  }
                  return null;
                },
              ),
              const SizedBox(height: MdbTokens.space16),
              AuthTextField(
                controller: _newController,
                label: 'Nouveau mot de passe',
                obscureText: !_newVisible,
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _newVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: _newVisible
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  onPressed: () =>
                      setState(() => _newVisible = !_newVisible),
                ),
                textInputAction: TextInputAction.next,
                semanticsLabel: 'Nouveau mot de passe',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nouveau mot de passe';
                  }
                  if (value.length < 8) {
                    return 'Le mot de passe doit contenir'
                        ' au moins 8 caractères';
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
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  onPressed: () =>
                      setState(() => _confirmVisible = !_confirmVisible),
                ),
                textInputAction: TextInputAction.done,
                semanticsLabel: 'Confirmer le nouveau mot de passe',
                validator: (value) {
                  if (value != _newController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: MdbTokens.space16),
              Semantics(
                button: true,
                label: 'Changer le mot de passe',
                child: OutlinedButton(
                  onPressed: isLoading ? null : _onSubmit,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Changer le mot de passe'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
