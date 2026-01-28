import 'package:bloc/bloc.dart';
import 'package:mdb_copilot/features/auth/data/auth_exception.dart';
import 'package:mdb_copilot/features/invitations/data/invitation_repository.dart';
import 'package:mdb_copilot/features/invitations/presentation/cubit/invitation_state.dart';

class InvitationCubit extends Cubit<InvitationState> {
  InvitationCubit({required InvitationRepository repository})
      : _repository = repository,
        super(const InvitationInitial());

  final InvitationRepository _repository;

  Future<void> sendInvitation({
    required String email,
    required String role,
  }) async {
    emit(const InvitationLoading());
    try {
      final invitation = await _repository.sendInvitation(
        email: email,
        role: role,
      );
      emit(InvitationSent(invitation));
    } on AuthException catch (e) {
      emit(InvitationError(e.message));
    }
  }

  Future<void> loadInvitations() async {
    emit(const InvitationLoading());
    try {
      final invitations = await _repository.getInvitations();
      emit(InvitationsLoaded(invitations));
    } on AuthException catch (e) {
      emit(InvitationError(e.message));
    }
  }

  Future<void> revokeInvitation(String invitationId) async {
    emit(const InvitationLoading());
    try {
      await _repository.revokeInvitation(invitationId);
      emit(const InvitationRevoked());
      await loadInvitations();
    } on AuthException catch (e) {
      emit(InvitationError(e.message));
    }
  }

  Future<void> acceptInvitation({
    required String token,
    required String firstName,
    required String lastName,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const InvitationLoading());
    try {
      final result = await _repository.acceptInvitation(
        token: token,
        firstName: firstName,
        lastName: lastName,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      emit(
        InvitationAccepted(
          user: result.user,
          token: result.token,
        ),
      );
    } on AuthException catch (e) {
      emit(InvitationError(e.message));
    }
  }
}
