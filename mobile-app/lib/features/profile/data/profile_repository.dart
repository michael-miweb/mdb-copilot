import 'package:mdb_copilot/features/auth/data/models/user_model.dart';
import 'package:mdb_copilot/features/profile/data/profile_remote_source.dart';

class ProfileRepository {
  const ProfileRepository({
    required ProfileRemoteSource remoteSource,
  }) : _remoteSource = remoteSource;

  final ProfileRemoteSource _remoteSource;

  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) {
    return _remoteSource.updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _remoteSource.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
