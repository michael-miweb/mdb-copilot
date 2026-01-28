import 'package:flutter_test/flutter_test.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';
import 'package:mdb_copilot/features/profile/data/profile_remote_source.dart';
import 'package:mdb_copilot/features/profile/data/profile_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRemoteSource extends Mock implements ProfileRemoteSource {}

void main() {
  late MockProfileRemoteSource mockRemoteSource;
  late ProfileRepository repository;

  const updatedUser = UserModel(
    id: 1,
    firstName: 'Jean',
    lastName: 'Mis à jour',
    email: 'new@example.com',
  );

  setUp(() {
    mockRemoteSource = MockProfileRemoteSource();
    repository = ProfileRepository(remoteSource: mockRemoteSource);
  });

  group('updateProfile', () {
    test('returns updated user', () async {
      when(
        () => mockRemoteSource.updateProfile(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => updatedUser);

      final user = await repository.updateProfile(
        firstName: 'Jean',
        lastName: 'Mis à jour',
        email: 'new@example.com',
      );

      expect(user, equals(updatedUser));
    });
  });

  group('updatePassword', () {
    test('calls remote source', () async {
      when(
        () => mockRemoteSource.updatePassword(
          currentPassword: any(named: 'currentPassword'),
          newPassword: any(named: 'newPassword'),
          confirmPassword: any(named: 'confirmPassword'),
        ),
      ).thenAnswer((_) async {});

      await repository.updatePassword(
        currentPassword: 'old123',
        newPassword: 'new12345',
        confirmPassword: 'new12345',
      );

      verify(
        () => mockRemoteSource.updatePassword(
          currentPassword: 'old123',
          newPassword: 'new12345',
          confirmPassword: 'new12345',
        ),
      ).called(1);
    });
  });
}
