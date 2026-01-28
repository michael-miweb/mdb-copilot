import 'package:equatable/equatable.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileUpdated extends ProfileState {
  const ProfileUpdated(this.user);

  final UserModel? user;

  @override
  List<Object?> get props => [user];
}

final class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
