import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdb_copilot/features/auth/data/auth_exception.dart';
import 'package:mdb_copilot/features/auth/data/auth_repository.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';
import 'package:mdb_copilot/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mdb_copilot/features/profile/data/profile_repository.dart';
import 'package:mdb_copilot/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mdb_copilot/features/profile/presentation/cubit/profile_state.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockProfileRepository mockProfileRepo;
  late AuthCubit authCubit;
  late MockAuthRepository mockAuthRepo;

  const updatedUser = UserModel(
    id: 1,
    firstName: 'Jean',
    lastName: 'Mis à jour',
    email: 'new@example.com',
  );

  setUp(() {
    mockProfileRepo = MockProfileRepository();
    mockAuthRepo = MockAuthRepository();
    authCubit = AuthCubit(repository: mockAuthRepo);
  });

  tearDown(() async {
    await authCubit.close();
  });

  group('updateProfile', () {
    blocTest<ProfileCubit, ProfileState>(
      'emits [ProfileLoading, ProfileUpdated] on success',
      build: () {
        when(
          () => mockProfileRepo.updateProfile(
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async => updatedUser);
        return ProfileCubit(
          repository: mockProfileRepo,
          authCubit: authCubit,
        );
      },
      act: (cubit) => cubit.updateProfile(
        firstName: 'Jean',
        lastName: 'Mis à jour',
        email: 'new@example.com',
      ),
      expect: () => [
        const ProfileLoading(),
        const ProfileUpdated(updatedUser),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [ProfileLoading, ProfileError] on failure',
      build: () {
        when(
          () => mockProfileRepo.updateProfile(
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
            email: any(named: 'email'),
          ),
        ).thenThrow(const ServerException());
        return ProfileCubit(
          repository: mockProfileRepo,
          authCubit: authCubit,
        );
      },
      act: (cubit) => cubit.updateProfile(firstName: 'Test'),
      expect: () => [
        const ProfileLoading(),
        const ProfileError(
          'Erreur serveur. Réessayez plus tard.',
        ),
      ],
    );
  });

  group('updatePassword', () {
    blocTest<ProfileCubit, ProfileState>(
      'emits [ProfileLoading, ProfileUpdated] on success',
      build: () {
        when(
          () => mockProfileRepo.updatePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            confirmPassword: any(named: 'confirmPassword'),
          ),
        ).thenAnswer((_) async {});
        return ProfileCubit(
          repository: mockProfileRepo,
          authCubit: authCubit,
        );
      },
      act: (cubit) => cubit.updatePassword(
        currentPassword: 'old',
        newPassword: 'new12345',
        confirmPassword: 'new12345',
      ),
      expect: () => [
        const ProfileLoading(),
        const ProfileUpdated(null),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [ProfileLoading, ProfileError] on wrong password',
      build: () {
        when(
          () => mockProfileRepo.updatePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            confirmPassword: any(named: 'confirmPassword'),
          ),
        ).thenThrow(
          const AuthException(
            'Le mot de passe actuel est incorrect.',
          ),
        );
        return ProfileCubit(
          repository: mockProfileRepo,
          authCubit: authCubit,
        );
      },
      act: (cubit) => cubit.updatePassword(
        currentPassword: 'wrong',
        newPassword: 'new12345',
        confirmPassword: 'new12345',
      ),
      expect: () => [
        const ProfileLoading(),
        const ProfileError(
          'Le mot de passe actuel est incorrect.',
        ),
      ],
    );
  });
}
