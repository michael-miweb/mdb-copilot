import 'package:flutter/material.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';

/// M3 text field with fixed label above the input (not floating).
///
/// Provides WCAG 2.1 AA compliant touch targets (≥ 48 dp),
/// border-radius 12 px, and [Semantics] wrapper.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.controller,
    required this.label,
    super.key,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.semanticsLabel,
    this.semanticsHint,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? semanticsLabel;
  final String? semanticsHint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: semanticsLabel ?? label,
      hint: semanticsHint,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: MdbTokens.space4),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              hintText: label,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}
