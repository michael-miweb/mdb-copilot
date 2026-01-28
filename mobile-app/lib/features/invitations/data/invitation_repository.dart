import 'package:mdb_copilot/features/auth/data/models/user_model.dart';
import 'package:mdb_copilot/features/invitations/data/invitation_remote_source.dart';
import 'package:mdb_copilot/features/invitations/data/models/invitation_model.dart';

class InvitationRepository {
  const InvitationRepository({
    required InvitationRemoteSource remoteSource,
  }) : _remoteSource = remoteSource;

  final InvitationRemoteSource _remoteSource;

  Future<InvitationModel> sendInvitation({
    required String email,
    required String role,
  }) {
    return _remoteSource.sendInvitation(
      email: email,
      role: role,
    );
  }

  Future<List<InvitationModel>> getInvitations() {
    return _remoteSource.getInvitations();
  }

  Future<void> revokeInvitation(String invitationId) {
    return _remoteSource.revokeInvitation(invitationId);
  }

  Future<({UserModel user, String token})> acceptInvitation({
    required String token,
    required String firstName,
    required String lastName,
    required String password,
    required String passwordConfirmation,
  }) {
    return _remoteSource.acceptInvitation(
      token: token,
      firstName: firstName,
      lastName: lastName,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
