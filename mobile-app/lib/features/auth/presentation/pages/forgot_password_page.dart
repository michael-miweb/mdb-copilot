import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/core/widgets/status_banner.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_state.dart';
import 'package:mdb_copilot/features/auth/presentation/widgets/auth_layout.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _successMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        context.read<AuthCubit>().forgotPassword(
              email: _emailController.text.trim(),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordResetSent) {
            setState(() {
              _successMessage = state.message;
            });
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              _buildHeader(),
              const SizedBox(height: 32),
              _buildEmailField(),
              const SizedBox(height: 8),
              _buildMessages(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              const SizedBox(height: 16),
              _buildBackToLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.lock_reset,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'R\u00e9initialiser votre mot de passe',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Entrez votre adresse email pour recevoir '
          'un lien de r\u00e9initialisation.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final isSuccess = _successMessage != null;

        return TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _onSubmit(),
          enabled: !isLoading && !isSuccess,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email_outlined),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "L'email est requis.";
            }
            if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$')
                .hasMatch(value)) {
              return "L'email doit \u00eatre une adresse valide.";
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildMessages() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthError) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: StatusBanner(
              type: StatusBannerType.error,
              message: state.message,
            ),
          );
        }

        if (_successMessage != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: StatusBanner(
              type: StatusBannerType.success,
              message: _successMessage!,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final isSuccess = _successMessage != null;

        return FilledButton(
          onPressed: isLoading || isSuccess ? null : _onSubmit,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    isSuccess ? 'Email envoy\u00e9' : 'Envoyer le lien',
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildBackToLoginLink() {
    return TextButton(
      onPressed: () => context.go('/login'),
      child: const Text('Retour \u00e0 la connexion'),
    );
  }
}
