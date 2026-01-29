import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/core/widgets/status_banner.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_state.dart';
import 'package:mdb_copilot/features/auth/presentation/widgets/auth_layout.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    required this.token,
    required this.email,
    super.key,
  });

  final String token;
  final String email;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _successMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        context.read<AuthCubit>().resetPassword(
              token: widget.token,
              email: widget.email,
              password: _passwordController.text,
              passwordConfirmation: _confirmController.text,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordReset) {
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
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildConfirmField(),
              const SizedBox(height: 8),
              _buildMessages(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              if (_successMessage != null) ...[
                const SizedBox(height: 16),
                _buildGoToLoginButton(),
              ],
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
          Icons.lock_outline,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Cr\u00e9er un nouveau mot de passe',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Choisissez un mot de passe s\u00e9curis\u00e9 '
          "d'au moins 8 caract\u00e8res.",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final isSuccess = _successMessage != null;

        return TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          enabled: !isLoading && !isSuccess,
          decoration: InputDecoration(
            labelText: 'Nouveau mot de passe',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: _obscurePassword
                    ? null
                    : Theme.of(context).colorScheme.primary,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Le mot de passe est requis.';
            }
            if (value.length < 8) {
              return 'Le mot de passe doit contenir au moins '
                  '8 caract\u00e8res.';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildConfirmField() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final isSuccess = _successMessage != null;

        return TextFormField(
          controller: _confirmController,
          obscureText: _obscureConfirm,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _onSubmit(),
          enabled: !isLoading && !isSuccess,
          decoration: InputDecoration(
            labelText: 'Confirmer le mot de passe',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: _obscureConfirm
                    ? null
                    : Theme.of(context).colorScheme.primary,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La confirmation est requise.';
            }
            if (value != _passwordController.text) {
              return 'Les mots de passe ne correspondent pas.';
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
                    isSuccess
                        ? 'Mot de passe modifi\u00e9'
                        : 'R\u00e9initialiser',
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildGoToLoginButton() {
    return OutlinedButton(
      onPressed: () => context.go('/login'),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Se connecter',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
