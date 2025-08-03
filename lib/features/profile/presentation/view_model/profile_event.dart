import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String bio;
  final File? avatarFile; 

  const UpdateProfileEvent({
    required this.firstName,
    required this.lastName,
    required this.bio,
    this.avatarFile,
  });

  @override
  List<Object> get props => [firstName, lastName, bio, avatarFile ?? ''];
}
