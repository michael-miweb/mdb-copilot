import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/app/shell.dart';
import 'package:mdb_copilot/core/api/token_storage.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_state.dart';
import 'package:mdb_copilot/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:mdb_copilot/features/auth/presentation/pages/login_page.dart';
import 'package:mdb_copilot/features/auth/presentation/pages/register_page.dart';
import 'package:mdb_copilot/features/auth/presentation/pages/reset_password_page.dart';
import 'package:mdb_copilot/features/home/presentation/pages/home_page.dart';
import 'package:mdb_copilot/features/invitations/presentation/pages/accept_invitation_page.dart';
import 'package:mdb_copilot/features/invitations/presentation/pages/invitations_page.dart';
import 'package:mdb_copilot/features/invitations/presentation/pages/send_invitation_page.dart';
import 'package:mdb_copilot/features/more/presentation/pages/more_page.dart';
import 'package:mdb_copilot/features/profile/presentation/pages/profile_page.dart';

GoRouter createRouter(AuthCubit authCubit, TokenStorage tokenStorage) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: _AuthChangeNotifier(authCubit),
    redirect: (context, state) {
      final authState = authCubit.state;
      final isAuthenticated = authState is AuthAuthenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation == '/reset-password';
      final isAcceptRoute =
          state.matchedLocation.startsWith('/invitations/accept');

      final isForgotRoute =
          state.matchedLocation == '/forgot-password';
      final isResetRoute =
          state.matchedLocation == '/reset-password';

      // Allow public routes without auth
      if (isAcceptRoute || isForgotRoute || isResetRoute) {
        return null;
      }

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Auth routes — outside shell (no navigation bar)
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          final email = state.uri.queryParameters['email'] ?? '';
          return ResetPasswordPage(token: token, email: email);
        },
      ),
      GoRoute(
        path: '/invitations/accept',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return AcceptInvitationPage(
            token: token,
            tokenStorage: tokenStorage,
          );
        },
      ),

      // Shell routes — with AdaptiveScaffold navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // Branch 0: Accueil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // Branch 1: Pipeline (placeholder)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pipeline',
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text('Pipeline — à venir')),
                ),
              ),
            ],
          ),
          // Branch 2: Plus (profile, invitations)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (context, state) => const MorePage(),
                routes: [
                  GoRoute(
                    path: 'profile',
                    builder: (context, state) => const ProfilePage(),
                  ),
                  GoRoute(
                    path: 'invitations',
                    builder: (context, state) => const InvitationsPage(),
                  ),
                  GoRoute(
                    path: 'invitations/send',
                    builder: (context, state) => const SendInvitationPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(AuthCubit authCubit) {
    _subscription = authCubit.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
