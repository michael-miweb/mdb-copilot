import 'package:bloc/bloc.dart';
import 'package:mdb_copilot/features/auth/data/auth_exception.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/profile/data/profile_repository.dart';
import 'package:mdb_copilot/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required ProfileRepository repository,
    required AuthCubit authCubit,
  })  : _repository = repository,
        _authCubit = authCubit,
        super(const ProfileInitial());

  final ProfileRepository _repository;
  final AuthCubit _authCubit;

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    emit(const ProfileLoading());
    try {
      final user = await _repository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      _authCubit.updateUser(user);
      emit(ProfileUpdated(user));
    } on AuthException catch (e) {
      emit(ProfileError(e.message));
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(const ProfileLoading());
    try {
      await _repository.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      emit(const ProfileUpdated(null));
    } on AuthException catch (e) {
      emit(ProfileError(e.message));
    }
  }
}
