import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';
import 'package:mdb_copilot/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:mdb_copilot/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mdb_copilot/features/profile/presentation/cubit/profile_state.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({required this.user, super.key});

  final UserModel user;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.user.firstName,
    );
    _lastNameController = TextEditingController(
      text: widget.user.lastName,
    );
    _emailController = TextEditingController(
      text: widget.user.email,
    );
  }

  @override
  void didUpdateWidget(ProfileForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user != widget.user) {
      _firstNameController.text = widget.user.firstName;
      _lastNameController.text = widget.user.lastName;
      _emailController.text = widget.user.email;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        context.read<ProfileCubit>().updateProfile(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              email: _emailController.text.trim(),
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
                'Modifier le profil',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _firstNameController,
                label: 'Prénom',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom';
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
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!value.contains('@')) {
                    return 'Veuillez entrer un email valide';
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
                    : const Text('Enregistrer'),
              ),
            ],
          ),
        );
      },
    );
  }
}
