import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/profile/domain/entity/profile_entity.dart';
import 'package:tradeverse/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:tradeverse/features/profile/domain/use_case/update_profile_use_case.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;

  ProfileViewModel({
    required GetProfileUseCase getProfile,
    required UpdateProfileUseCase updateProfile,
  }) : _getProfile = getProfile,
       _updateProfile = updateProfile,
       super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await _getProfile();
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event, // Use UpdateProfileEvent
    Emitter<ProfileState> emit,
  ) async {
    ProfileEntity? currentProfile;
    if (state is ProfileLoaded) {
      currentProfile = (state as ProfileLoaded).profile;
    }

    emit(ProfileLoading()); // Show loading indicator during update

    final params = UpdateProfileParams(
      firstName: event.firstName,
      lastName: event.lastName,
      bio: event.bio,
      avatarFile: event.avatarFile,
    );

    final result = await _updateProfile(params);
    result.fold((failure) {
      if (currentProfile != null) {
        emit(
          ProfileLoaded(profile: currentProfile),
        );
      }
      emit(ProfileError(message: failure.message));
    }, (profile) => emit(ProfileLoaded(profile: profile)));
  }
}
