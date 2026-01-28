import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdb_copilot/features/auth/data/auth_exception.dart';
import 'package:mdb_copilot/features/auth/data/auth_repository.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  const testUser = UserModel(
    id: 1,
    firstName: 'Jean',
    lastName: 'Dupont',
    email: 'jean@example.com',
  );

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  group('checkAuthStatus', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when user is authenticated',
      build: () {
        when(() => mockRepository.getCurrentUser())
            .thenAnswer((_) async => testUser);
        return AuthCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when no user',
      build: () {
        when(() => mockRepository.getCurrentUser())
            .thenAnswer((_) async => null);
        return AuthCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );
  });

  group('register', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success',
      build: () {
        when(
          () => mockRepository.register(
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
            passwordConfirmation: any(named: 'passwordConfirmation'),
          ),
        ).thenAnswer((_) async => testUser);
        return AuthCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.register(
        firstName: 'Jean',
        lastName: 'Dupont',
        email: 'jean@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      ),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] on failure',
      build: () {
        when(
          () => mockRepository.register(
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
            passwordConfirmation: any(named: 'passwordConfirmation'),
          ),
        ).thenThrow(const EmailAlreadyUsedException());
        return AuthCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.register(
        firstName: 'Jean',
        lastName: 'Dupont',
        email: 'jean@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      ),
      expect: () => [
        const AuthLoading(),
        const AuthError('Cette adresse email est déjà utilisée.'),
      ],
    );
  });

  group('login', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success',
      build: () {
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => testUser);
        return AuthCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.login(
        email: 'jean@example.com',
        password: 'password123',
      ),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] on failure',
      build: () {
        when(
          () => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const InvalidCredentialsException());
        return AuthCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.login(
        email: 'jean@example.com',
        password: 'wrong',
      ),
      expect: () => [
        const AuthLoading(),
        const AuthError('Identifiants incorrects.'),
      ],
    );
  });

  group('logout', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] on success',
      build: () {
        when(() => mockRepository.logout()).thenAnswer((_) async {});
        return AuthCubit(repository: mockRepository);
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );
  });
}
