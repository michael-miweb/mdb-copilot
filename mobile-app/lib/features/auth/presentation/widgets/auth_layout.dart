import 'package:flutter/material.dart';

/// Responsive layout wrapper for authentication pages.
///
/// - Compact (< 600 dp): full-width form with 24px padding + AppBar.
/// - Medium+ (≥ 600 dp): centred card, max 440px wide, no AppBar.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    required this.child,
    super.key,
  });

  final Widget child;

  static const _compactBreakpoint = 600.0;
  static const _formMaxWidth = 440.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= _compactBreakpoint;

            if (isWide) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _formMaxWidth,
                    ),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: child,
            );
          },
        ),
      ),
    );
  }
}
