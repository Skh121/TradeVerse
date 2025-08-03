import 'package:equatable/equatable.dart';
import 'package:tradeverse/features/profile/domain/entity/profile_entity.dart';

/// Base class for all Profile states.
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

/// State indicating that the profile is currently loading.
class ProfileLoading extends ProfileState {}

/// State indicating that the profile has been successfully loaded.
class ProfileLoaded extends ProfileState {
  final ProfileEntity profile; // Now holds ProfileEntity

  const ProfileLoaded({required this.profile});

  @override
  List<Object> get props => [profile];
}

/// State indicating that an error occurred during profile operations.
class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}
