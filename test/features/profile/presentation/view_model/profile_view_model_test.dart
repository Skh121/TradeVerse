import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/profile/domain/entity/profile_entity.dart';
import 'package:tradeverse/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:tradeverse/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:tradeverse/features/profile/presentation/view_model/profile_event.dart';
import 'package:tradeverse/features/profile/presentation/view_model/profile_state.dart';
import 'package:tradeverse/features/profile/presentation/view_model/profile_view_model.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

class FakeUpdateProfileParams extends Fake implements UpdateProfileParams {}

void main() {
  late MockGetProfileUseCase mockGetProfile;
  late MockUpdateProfileUseCase mockUpdateProfile;
  late ProfileViewModel viewModel;

  setUpAll(() {
    registerFallbackValue(FakeUpdateProfileParams());
  });

  setUp(() {
    mockGetProfile = MockGetProfileUseCase();
    mockUpdateProfile = MockUpdateProfileUseCase();
    viewModel = ProfileViewModel(
      getProfile: mockGetProfile,
      updateProfile: mockUpdateProfile,
    );
  });

  final profile = ProfileEntity(
    id: '123',
    user: const UserDetailEntity(
      fullName: 'Sabin Khadka',
      email: 'sabin@example.com',
    ),
    subscription: const SubscriptionEntity(plan: 'premium'),
    firstName: 'Sabin',
    lastName: 'Khadka',
    bio: 'A trader',
    avatar: 'avatar.png',
  );

  group('LoadProfile', () {
    blocTest<ProfileViewModel, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when GetProfileUseCase succeeds',
      build: () {
        when(() => mockGetProfile()).thenAnswer((_) async => Right(profile));
        return viewModel;
      },
      act: (bloc) => bloc.add(LoadProfile()),
      expect: () => [ProfileLoading(), ProfileLoaded(profile: profile)],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits [ProfileLoading, ProfileError] when GetProfileUseCase fails',
      build: () {
        when(
          () => mockGetProfile(),
        ).thenAnswer((_) async => const Left(ApiFailure(message: 'Failed')));
        return viewModel;
      },
      act: (bloc) => bloc.add(LoadProfile()),
      expect: () => [ProfileLoading(), const ProfileError(message: 'Failed')],
    );
  });

  group('UpdateProfileEvent', () {
    const updatedFirstName = 'New';
    const updatedLastName = 'Name';
    const updatedBio = 'Updated Bio';
    final updatedAvatar = File('avatar.jpg');

    final updatedProfile = profile.copyWith(
      firstName: updatedFirstName,
      lastName: updatedLastName,
      bio: updatedBio,
      avatar: updatedAvatar.path,
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when UpdateProfileUseCase succeeds',
      build: () {
        when(
          () => mockUpdateProfile(any()),
        ).thenAnswer((_) async => Right(updatedProfile));
        return viewModel;
      },
      seed: () => ProfileLoaded(profile: profile),
      act:
          (bloc) => bloc.add(
            UpdateProfileEvent(
              firstName: updatedFirstName,
              lastName: updatedLastName,
              bio: updatedBio,
              avatarFile: File('avatar.jpg'),
            ),
          ),
      expect: () => [ProfileLoading(), ProfileLoaded(profile: updatedProfile)],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded (old), ProfileError] when UpdateProfileUseCase fails and state is ProfileLoaded',
      build: () {
        when(() => mockUpdateProfile(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Update failed')),
        );
        return viewModel;
      },
      seed: () => ProfileLoaded(profile: profile),
      act:
          (bloc) => bloc.add(
            const UpdateProfileEvent(
              firstName: updatedFirstName,
              lastName: updatedLastName,
              bio: updatedBio,
              avatarFile: null,
            ),
          ),
      expect:
          () => [
            ProfileLoading(),
            ProfileLoaded(profile: profile),
            const ProfileError(message: 'Update failed'),
          ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits [ProfileLoading, ProfileError] when UpdateProfileUseCase fails and no previous profile loaded',
      build: () {
        when(() => mockUpdateProfile(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Update failed')),
        );
        return viewModel;
      },
      act:
          (bloc) => bloc.add(
            const UpdateProfileEvent(
              firstName: updatedFirstName,
              lastName: updatedLastName,
              bio: updatedBio,
              avatarFile: null,
            ),
          ),
      expect:
          () => [
            ProfileLoading(),
            const ProfileError(message: 'Update failed'),
          ],
    );
  });
}
