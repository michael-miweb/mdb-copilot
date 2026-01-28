import 'package:equatable/equatable.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';
import 'package:mdb_copilot/features/invitations/data/models/invitation_model.dart';

sealed class InvitationState extends Equatable {
  const InvitationState();

  @override
  List<Object?> get props => [];
}

class InvitationInitial extends InvitationState {
  const InvitationInitial();
}

class InvitationLoading extends InvitationState {
  const InvitationLoading();
}

class InvitationSent extends InvitationState {
  const InvitationSent(this.invitation);

  final InvitationModel invitation;

  @override
  List<Object?> get props => [invitation];
}

class InvitationsLoaded extends InvitationState {
  const InvitationsLoaded(this.invitations);

  final List<InvitationModel> invitations;

  @override
  List<Object?> get props => [invitations];
}

class InvitationRevoked extends InvitationState {
  const InvitationRevoked();
}

class InvitationAccepted extends InvitationState {
  const InvitationAccepted({
    required this.user,
    required this.token,
  });

  final UserModel user;
  final String token;

  @override
  List<Object?> get props => [user, token];
}

class InvitationError extends InvitationState {
  const InvitationError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
