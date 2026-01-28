import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              const SizedBox(height: 16),
              AuthTextField(
                controller: _currentController,
                label: 'Mot de passe actuel',
                obscureText: true,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe actuel';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _newController,
                label: 'Nouveau mot de passe',
                obscureText: true,
                textInputAction: TextInputAction.next,
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
              const SizedBox(height: 16),
              AuthTextField(
                controller: _confirmController,
                label: 'Confirmer le mot de passe',
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value != _newController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                    : const Text('Changer le mot de passe'),
              ),
            ],
          ),
        );
      },
    );
  }
}
