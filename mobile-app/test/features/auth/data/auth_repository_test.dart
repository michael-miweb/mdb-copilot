import 'package:flutter_test/flutter_test.dart';
import 'package:mdb_copilot/core/api/token_storage.dart';
import 'package:mdb_copilot/features/auth/data/auth_exception.dart';
import 'package:mdb_copilot/features/auth/data/auth_remote_source.dart';
import 'package:mdb_copilot/features/auth/data/auth_repository.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteSource extends Mock implements AuthRemoteSource {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockAuthRemoteSource mockRemoteSource;
  late MockTokenStorage mockTokenStorage;
  late AuthRepository repository;

  const testUser = UserModel(
    id: 1,
    firstName: 'Jean',
    lastName: 'Dupont',
    email: 'jean@example.com',
  );

  setUp(() {
    mockRemoteSource = MockAuthRemoteSource();
    mockTokenStorage = MockTokenStorage();
    repository = AuthRepository(
      remoteSource: mockRemoteSource,
      tokenStorage: mockTokenStorage,
    );
  });

  group('register', () {
    test('saves token and returns user on success', () async {
      when(
        () => mockRemoteSource.register(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          password: any(named: 'password'),
          passwordConfirmation: any(named: 'passwordConfirmation'),
        ),
      ).thenAnswer((_) async => (user: testUser, token: 'test-token'));
      when(() => mockTokenStorage.saveToken(any()))
          .thenAnswer((_) async {});

      final user = await repository.register(
        firstName: 'Jean',
        lastName: 'Dupont',
        email: 'jean@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      expect(user, equals(testUser));
      verify(() => mockTokenStorage.saveToken('test-token')).called(1);
    });
  });

  group('login', () {
    test('saves token and returns user on success', () async {
      when(
        () => mockRemoteSource.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => (user: testUser, token: 'test-token'));
      when(() => mockTokenStorage.saveToken(any()))
          .thenAnswer((_) async {});

      final user = await repository.login(
        email: 'jean@example.com',
        password: 'password123',
      );

      expect(user, equals(testUser));
      verify(() => mockTokenStorage.saveToken('test-token')).called(1);
    });
  });

  group('logout', () {
    test('revokes token and deletes local token', () async {
      when(() => mockRemoteSource.logout()).thenAnswer((_) async {});
      when(() => mockTokenStorage.deleteToken()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => mockRemoteSource.logout()).called(1);
      verify(() => mockTokenStorage.deleteToken()).called(1);
    });

    test('deletes local token even if API fails', () async {
      when(() => mockRemoteSource.logout())
          .thenThrow(const ServerException());
      when(() => mockTokenStorage.deleteToken()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => mockTokenStorage.deleteToken()).called(1);
    });
  });

  group('getCurrentUser', () {
    test('returns user when token exists', () async {
      when(() => mockTokenStorage.getToken())
          .thenAnswer((_) async => 'test-token');
      when(() => mockRemoteSource.getUser())
          .thenAnswer((_) async => testUser);

      final user = await repository.getCurrentUser();

      expect(user, equals(testUser));
    });

    test('returns null when no token', () async {
      when(() => mockTokenStorage.getToken()).thenAnswer((_) async => null);

      final user = await repository.getCurrentUser();

      expect(user, isNull);
    });

    test('returns null and clears token when API fails', () async {
      when(() => mockTokenStorage.getToken())
          .thenAnswer((_) async => 'expired-token');
      when(() => mockRemoteSource.getUser())
          .thenThrow(const InvalidCredentialsException());
      when(() => mockTokenStorage.deleteToken()).thenAnswer((_) async {});

      final user = await repository.getCurrentUser();

      expect(user, isNull);
      verify(() => mockTokenStorage.deleteToken()).called(1);
    });
  });
}
