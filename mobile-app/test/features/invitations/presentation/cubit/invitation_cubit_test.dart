import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdb_copilot/features/auth/data/auth_exception.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';
import 'package:mdb_copilot/features/invitations/data/invitation_repository.dart';
import 'package:mdb_copilot/features/invitations/data/models/invitation_model.dart';
import 'package:mdb_copilot/features/invitations/presentation/cubit/invitation_cubit.dart';
import 'package:mdb_copilot/features/invitations/presentation/cubit/invitation_state.dart';
import 'package:mocktail/mocktail.dart';

class MockInvitationRepository extends Mock implements InvitationRepository {}

void main() {
  late MockInvitationRepository mockRepo;

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
    mockRepo = MockInvitationRepository();
  });

  group('sendInvitation', () {
    blocTest<InvitationCubit, InvitationState>(
      'emits [InvitationLoading, InvitationSent] on success',
      build: () {
        when(
          () => mockRepo.sendInvitation(
            email: any(named: 'email'),
            role: any(named: 'role'),
          ),
        ).thenAnswer((_) async => invitation);
        return InvitationCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.sendInvitation(
        email: 'guest@example.com',
        role: 'guest-read',
      ),
      expect: () => [
        const InvitationLoading(),
        const InvitationSent(invitation),
      ],
    );

    blocTest<InvitationCubit, InvitationState>(
      'emits [InvitationLoading, InvitationError] on failure',
      build: () {
        when(
          () => mockRepo.sendInvitation(
            email: any(named: 'email'),
            role: any(named: 'role'),
          ),
        ).thenThrow(const ServerException());
        return InvitationCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.sendInvitation(
        email: 'guest@example.com',
        role: 'guest-read',
      ),
      expect: () => [
        const InvitationLoading(),
        const InvitationError('Erreur serveur. Réessayez plus tard.'),
      ],
    );
  });

  group('loadInvitations', () {
    blocTest<InvitationCubit, InvitationState>(
      'emits [InvitationLoading, InvitationsLoaded] on success',
      build: () {
        when(
          () => mockRepo.getInvitations(),
        ).thenAnswer((_) async => [invitation]);
        return InvitationCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.loadInvitations(),
      expect: () => [
        const InvitationLoading(),
        const InvitationsLoaded([invitation]),
      ],
    );
  });

  group('acceptInvitation', () {
    blocTest<InvitationCubit, InvitationState>(
      'emits [InvitationLoading, InvitationAccepted] on success',
      build: () {
        when(
          () => mockRepo.acceptInvitation(
            token: any(named: 'token'),
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
            password: any(named: 'password'),
            passwordConfirmation: any(named: 'passwordConfirmation'),
          ),
        ).thenAnswer((_) async => (user: user, token: 'new-token'));
        return InvitationCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.acceptInvitation(
        token: 'invitation-token',
        firstName: 'Guest',
        lastName: 'User',
        password: 'password123',
        passwordConfirmation: 'password123',
      ),
      expect: () => [
        const InvitationLoading(),
        const InvitationAccepted(user: user, token: 'new-token'),
      ],
    );
  });
}
