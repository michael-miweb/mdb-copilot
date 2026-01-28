import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mdb_copilot/core/api/token_storage.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_state.dart';
import 'package:mdb_copilot/features/auth/presentation/pages/login_page.dart';
import 'package:mdb_copilot/features/auth/presentation/pages/register_page.dart';
import 'package:mdb_copilot/features/home/presentation/pages/home_page.dart';
import 'package:mdb_copilot/features/invitations/presentation/pages/accept_invitation_page.dart';
import 'package:mdb_copilot/features/invitations/presentation/pages/invitations_page.dart';
import 'package:mdb_copilot/features/invitations/presentation/pages/send_invitation_page.dart';
import 'package:mdb_copilot/features/profile/presentation/pages/profile_page.dart';

GoRouter createRouter(AuthCubit authCubit, TokenStorage tokenStorage) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: _AuthChangeNotifier(authCubit),
    redirect: (context, state) {
      final authState = authCubit.state;
      final isAuthenticated = authState is AuthAuthenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isAcceptRoute =
          state.matchedLocation.startsWith('/invitations/accept');

      // Allow accept invitation route without auth
      if (isAcceptRoute) {
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
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/invitations',
        builder: (context, state) => const InvitationsPage(),
      ),
      GoRoute(
        path: '/invitations/send',
        builder: (context, state) => const SendInvitationPage(),
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
