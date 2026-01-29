import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdb_copilot/app/routes.dart';
import 'package:mdb_copilot/core/api/api_client.dart';
import 'package:mdb_copilot/core/api/token_storage.dart';
import 'package:mdb_copilot/core/theme/mdb_dark_theme.dart';
import 'package:mdb_copilot/core/theme/mdb_light_theme.dart';
import 'package:mdb_copilot/features/auth/data/auth_remote_source.dart';
import 'package:mdb_copilot/features/auth/data/auth_repository.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/invitations/data/invitation_remote_source.dart';
import 'package:mdb_copilot/features/invitations/data/invitation_repository.dart';
import 'package:mdb_copilot/features/invitations/presentation/cubit/invitation_cubit.dart';
import 'package:mdb_copilot/features/profile/data/profile_remote_source.dart';
import 'package:mdb_copilot/features/profile/data/profile_repository.dart';
import 'package:mdb_copilot/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mdb_copilot/l10n/l10n.dart';

class App extends StatefulWidget {
  const App({required this.apiBaseUrl, super.key});

  final String apiBaseUrl;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final TokenStorage _tokenStorage;
  late final ApiClient _apiClient;
  late final AuthRemoteSource _authRemoteSource;
  late final AuthRepository _authRepository;
  late final AuthCubit _authCubit;
  late final ProfileRemoteSource _profileRemoteSource;
  late final ProfileRepository _profileRepository;
  late final ProfileCubit _profileCubit;
  late final InvitationRemoteSource _invitationRemoteSource;
  late final InvitationRepository _invitationRepository;
  late final InvitationCubit _invitationCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _tokenStorage = TokenStorage();
    _apiClient = ApiClient(
      baseUrl: widget.apiBaseUrl,
      tokenStorage: _tokenStorage,
    );
    _authRemoteSource = AuthRemoteSource(apiClient: _apiClient);
    _authRepository = AuthRepository(
      remoteSource: _authRemoteSource,
      tokenStorage: _tokenStorage,
    );
    _authCubit = AuthCubit(repository: _authRepository);
    unawaited(_authCubit.checkAuthStatus());
    _profileRemoteSource = ProfileRemoteSource(
      apiClient: _apiClient,
    );
    _profileRepository = ProfileRepository(
      remoteSource: _profileRemoteSource,
    );
    _profileCubit = ProfileCubit(
      repository: _profileRepository,
      authCubit: _authCubit,
    );
    _invitationRemoteSource = InvitationRemoteSource(
      apiClient: _apiClient,
    );
    _invitationRepository = InvitationRepository(
      remoteSource: _invitationRemoteSource,
    );
    _invitationCubit = InvitationCubit(
      repository: _invitationRepository,
    );
    _router = createRouter(_authCubit, _tokenStorage);
  }

  @override
  void dispose() {
    unawaited(_invitationCubit.close());
    unawaited(_profileCubit.close());
    unawaited(_authCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authCubit),
        BlocProvider.value(value: _profileCubit),
        BlocProvider.value(value: _invitationCubit),
      ],
      child: MaterialApp.router(
        theme: mdbLightTheme.copyWith(
          textTheme: GoogleFonts.interTextTheme(mdbLightTheme.textTheme),
        ),
        darkTheme: mdbDarkTheme.copyWith(
          textTheme: GoogleFonts.interTextTheme(mdbDarkTheme.textTheme),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
      ),
    );
  }
}
