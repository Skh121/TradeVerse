import 'package:equatable/equatable.dart';

/// Represents the user's subscription details in the domain.
class SubscriptionEntity extends Equatable {
  final String? plan;

  const SubscriptionEntity({this.plan});

  @override
  List<Object?> get props => [plan];
}

/// Represents the user's basic details in the domain.
class UserDetailEntity extends Equatable {
  final String fullName;
  final String email;

  const UserDetailEntity({required this.fullName, required this.email});

  @override
  List<Object> get props => [fullName, email];
}

/// Represents the complete user profile in the domain.
class ProfileEntity extends Equatable {
  final String? id; // _id from backend
  final UserDetailEntity user;
  final SubscriptionEntity? subscription;
  final String firstName;
  final String lastName;
  final String bio;
  final String? avatar; // URL of the avatar image

  const ProfileEntity({
    this.id,
    required this.user,
    this.subscription,
    required this.firstName,
    required this.lastName,
    required this.bio,
    this.avatar,
  });

  @override
  List<Object?> get props => [
    id,
    user,
    subscription,
    firstName,
    lastName,
    bio,
    avatar,
  ];

  // Helper method to create a copy with updated values (useful in BLoC/UI)
  ProfileEntity copyWith({
    String? id,
    UserDetailEntity? user,
    SubscriptionEntity? subscription,
    String? firstName,
    String? lastName,
    String? bio,
    String? avatar,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      user: user ?? this.user,
      subscription: subscription ?? this.subscription,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
    );
  }
}
