import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';
import 'package:mdb_copilot/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:mdb_copilot/features/invitations/presentation/cubit/invitation_cubit.dart';
import 'package:mdb_copilot/features/invitations/presentation/cubit/invitation_state.dart';

class SendInvitationPage extends StatefulWidget {
  const SendInvitationPage({super.key});

  @override
  State<SendInvitationPage> createState() => _SendInvitationPageState();
}

class _SendInvitationPageState extends State<SendInvitationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _selectedRole = 'guest-read';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        context.read<InvitationCubit>().sendInvitation(
              email: _emailController.text,
              role: _selectedRole,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<InvitationCubit, InvitationState>(
      listener: (context, state) {
        if (state is InvitationSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle_outlined,
                    color: theme.colorScheme.onInverseSurface,
                  ),
                  const SizedBox(width: MdbTokens.space8),
                  const Text('Invitation envoyée avec succès.'),
                ],
              ),
            ),
          );
          context.go('/more/invitations');
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
            title: const Text('Nouvelle invitation'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(MdbTokens.space16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthTextField(
                    controller: _emailController,
                    label: 'Adresse email',
                    prefixIcon: const Icon(Icons.mail_outlined),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    semanticsLabel: 'Adresse email du collaborateur',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "L'adresse email est requise";
                      }
                      if (!value.contains('@')) {
                        return 'Adresse email invalide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: MdbTokens.space16),
                  Semantics(
                    label: 'Sélectionner le rôle',
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Rôle',
                        prefixIcon: const Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            MdbTokens.radiusDefault,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'guest-read',
                          child: Text('Consultation'),
                        ),
                        DropdownMenuItem(
                          value: 'guest-extended',
                          child: Text('Étendu'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedRole = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: MdbTokens.space24),
                  Semantics(
                    button: true,
                    label: "Envoyer l'invitation",
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
                          : const Text("Envoyer l'invitation"),
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
