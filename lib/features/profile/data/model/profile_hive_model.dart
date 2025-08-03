import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tradeverse/app/constant/hive/hive_table_constant.dart';
import 'package:tradeverse/features/profile/domain/entity/profile_entity.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.subscriptionTableId)
class SubscriptionHiveModel extends Equatable {
  @HiveField(0)
  final String? plan;

  const SubscriptionHiveModel({this.plan});

  factory SubscriptionHiveModel.fromEntity(SubscriptionEntity entity) {
    return SubscriptionHiveModel(plan: entity.plan);
  }

  SubscriptionEntity toEntity() {
    return SubscriptionEntity(plan: plan);
  }

  @override
  List<Object?> get props => [plan];
}

@HiveType(typeId: HiveTableConstant.userDetailTableId)
class UserDetailHiveModel extends Equatable {
  @HiveField(0)
  final String fullName;
  @HiveField(1)
  final String email;

  const UserDetailHiveModel({required this.fullName, required this.email});

  factory UserDetailHiveModel.fromEntity(UserDetailEntity entity) {
    return UserDetailHiveModel(fullName: entity.fullName, email: entity.email);
  }

  UserDetailEntity toEntity() {
    return UserDetailEntity(fullName: fullName, email: email);
  }

  @override
  List<Object?> get props => [fullName, email];
}

@HiveType(typeId: HiveTableConstant.profileTableId)
class ProfileHiveModel extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final UserDetailHiveModel user;
  @HiveField(2)
  final SubscriptionHiveModel? subscription;
  @HiveField(3)
  final String firstName;
  @HiveField(4)
  final String lastName;
  @HiveField(5)
  final String bio;
  @HiveField(6)
  final String? avatar;

  const ProfileHiveModel({
    this.id,
    required this.user,
    this.subscription,
    required this.firstName,
    required this.lastName,
    required this.bio,
    this.avatar,
  });

  factory ProfileHiveModel.fromEntity(ProfileEntity entity) {
    return ProfileHiveModel(
      id: entity.id,
      user: UserDetailHiveModel.fromEntity(entity.user),
      subscription:
          entity.subscription != null
              ? SubscriptionHiveModel.fromEntity(entity.subscription!)
              : null,
      firstName: entity.firstName,
      lastName: entity.lastName,
      bio: entity.bio,
      avatar: entity.avatar,
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      user: user.toEntity(),
      subscription: subscription?.toEntity(),
      firstName: firstName,
      lastName: lastName,
      bio: bio,
      avatar: avatar,
    );
  }

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
}
