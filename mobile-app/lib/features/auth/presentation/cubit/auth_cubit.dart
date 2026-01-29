import 'package:bloc/bloc.dart';
import 'package:mdb_copilot/features/auth/data/auth_exception.dart';
import 'package:mdb_copilot/features/auth/data/auth_repository.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepository repository})
      : _repository = repository,
        super(const AuthInitial());

  final AuthRepository _repository;

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } on AuthException catch (e) {
      emit(const AuthUnauthenticated());
      emit(AuthError(e.message));
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      emit(AuthAuthenticated(user));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.login(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> forgotPassword({required String email}) async {
    emit(const AuthLoading());
    try {
      final message = await _repository.forgotPassword(email: email);
      emit(AuthPasswordResetSent(message));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const AuthLoading());
    try {
      final message = await _repository.resetPassword(
        token: token,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      emit(AuthPasswordReset(message));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    }
  }

  void updateUser(UserModel user) {
    emit(AuthAuthenticated(user));
  }

  bool isOwner() {
    final s = state;
    return s is AuthAuthenticated && s.user.role == 'owner';
  }

  bool isGuestRead() {
    final s = state;
    return s is AuthAuthenticated && s.user.role == 'guest-read';
  }

  bool isGuestExtended() {
    final s = state;
    return s is AuthAuthenticated &&
        s.user.role == 'guest-extended';
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    try {
      await _repository.logout();
    } on AuthException {
      // Ignore errors during logout
    } finally {
      emit(const AuthUnauthenticated());
    }
  }
}
