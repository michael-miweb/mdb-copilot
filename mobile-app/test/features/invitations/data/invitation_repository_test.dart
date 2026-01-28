import 'package:flutter_test/flutter_test.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';
import 'package:mdb_copilot/features/invitations/data/invitation_remote_source.dart';
import 'package:mdb_copilot/features/invitations/data/invitation_repository.dart';
import 'package:mdb_copilot/features/invitations/data/models/invitation_model.dart';
import 'package:mocktail/mocktail.dart';

class MockInvitationRemoteSource extends Mock
    implements InvitationRemoteSource {}

void main() {
  late MockInvitationRemoteSource mockRemoteSource;
  late InvitationRepository repository;

  const invitation = InvitationModel(
    id: 'uuid-123',
    ownerId: 1,
    email: 'guest@example.com',
    role: 'guest-read',
    status: 'pending',
  );

  const user = UserModel(
    id: 2,
    firstName: 'Guest',
    lastName: 'User',
    email: 'guest@example.com',
    role: 'guest-read',
  );

  setUp(() {
    mockRemoteSource = MockInvitationRemoteSource();
    repository = InvitationRepository(remoteSource: mockRemoteSource);
  });

  group('sendInvitation', () {
    test('returns invitation on success', () async {
      when(
        () => mockRemoteSource.sendInvitation(
          email: any(named: 'email'),
          role: any(named: 'role'),
        ),
      ).thenAnswer((_) async => invitation);

      final result = await repository.sendInvitation(
        email: 'guest@example.com',
        role: 'guest-read',
      );

      expect(result, equals(invitation));
    });
  });

  group('acceptInvitation', () {
    test('returns user and token on success', () async {
      when(
        () => mockRemoteSource.acceptInvitation(
          token: any(named: 'token'),
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          password: any(named: 'password'),
          passwordConfirmation: any(named: 'passwordConfirmation'),
        ),
      ).thenAnswer((_) async => (user: user, token: 'new-token'));

      final result = await repository.acceptInvitation(
        token: 'invitation-token',
        firstName: 'Guest',
        lastName: 'User',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      expect(result.user, equals(user));
      expect(result.token, equals('new-token'));
    });
  });

  group('revokeInvitation', () {
    test('calls remote source', () async {
      when(
        () => mockRemoteSource.revokeInvitation(any()),
      ).thenAnswer((_) async {});

      await repository.revokeInvitation('uuid-123');

      verify(
        () => mockRemoteSource.revokeInvitation('uuid-123'),
      ).called(1);
    });
  });
}
