import 'package:equatable/equatable.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final UserModel user;

  @override
  List<Object?> get props => [user];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class AuthPasswordReset extends AuthState {
  const AuthPasswordReset(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
