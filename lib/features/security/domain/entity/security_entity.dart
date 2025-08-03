// lib/features/security/domain/entities/security_entity.dart

import 'package:equatable/equatable.dart';

class SuccessMessageEntity extends Equatable {
  final String message;

  const SuccessMessageEntity({required this.message});

  @override
  List<Object> get props => [message];
}

/// Entity for user details within the exported data.
class UserExportDetailEntity extends Equatable {
  final String? id; // Mapped from _id
  final String? fullName;
  final String? email;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserExportDetailEntity({
    this.id,
    this.fullName,
    this.email,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, fullName, email, role, createdAt, updatedAt];
}

/// Entity for profile details within the exported data.
class ProfileExportDetailEntity extends Equatable {
  final String? id; // Mapped from _id
  final String? userId; // Mapped from user
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? avatar;
  final String? subscriptionId; // Mapped from subscription
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileExportDetailEntity({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.bio,
    this.avatar,
    this.subscriptionId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    firstName,
    lastName,
    bio,
    avatar,
    subscriptionId,
    createdAt,
    updatedAt,
  ];
}

/// Entity for subscription details within the exported data.
class SubscriptionExportDetailEntity extends Equatable {
  final String? id; // Mapped from _id
  final String? userId;
  final String? plan;
  final String? billingCycle;
  final double? price;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SubscriptionExportDetailEntity({
    this.id,
    this.userId,
    this.plan,
    this.billingCycle,
    this.price,
    this.status,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    plan,
    billingCycle,
    price,
    status,
    startDate,
    endDate,
    createdAt,
    updatedAt,
  ];
}

/// Entity for payment details within the exported data.
class PaymentExportDetailEntity extends Equatable {
  final String? id; // Mapped from _id
  final String? userId;
  final String? subscriptionId;
  final double? amount;
  final String? currency;
  final String? paymentMethod;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PaymentExportDetailEntity({
    this.id,
    this.userId,
    this.subscriptionId,
    this.amount,
    this.currency,
    this.paymentMethod,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    subscriptionId,
    amount,
    currency,
    paymentMethod,
    status,
    createdAt,
    updatedAt,
  ];
}

/// Entity for trade details within the exported data.
class TradeExportDetailEntity extends Equatable {
  final String? id; // Mapped from _id
  final String? userId; // Mapped from user
  final String? symbol;
  final String? status;
  final String? assetClass;
  final String? tradeDirection;
  final DateTime? entryDate;
  final double? entryPrice;
  final int? positionSize;
  final DateTime? exitDate;
  final double? exitPrice;
  final double? fees;
  final List<String>? tags;
  final String? notes;
  final String? chartScreenshotUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TradeExportDetailEntity({
    this.id,
    this.userId,
    this.symbol,
    this.status,
    this.assetClass,
    this.tradeDirection,
    this.entryDate,
    this.entryPrice,
    this.positionSize,
    this.exitDate,
    this.exitPrice,
    this.fees,
    this.tags,
    this.notes,
    this.chartScreenshotUrl,
    this.createdAt,
    this.updatedAt,
  });

  // Computed property for profit/loss
  double get profitLoss {
    if (entryPrice != null && exitPrice != null && fees != null) {
      return (exitPrice! - entryPrice!) - fees!;
    }
    return 0.0;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    symbol,
    status,
    assetClass,
    tradeDirection,
    entryDate,
    entryPrice,
    positionSize,
    exitDate,
    exitPrice,
    fees,
    tags,
    notes,
    chartScreenshotUrl,
    createdAt,
    updatedAt,
  ];
}

/// Entity representing the comprehensive exported user data.
class UserDataExportEntity extends Equatable {
  final UserExportDetailEntity? user;
  final ProfileExportDetailEntity? profile;
  final SubscriptionExportDetailEntity? subscription;
  final List<PaymentExportDetailEntity>? payments;
  final List<TradeExportDetailEntity>? trades;

  const UserDataExportEntity({
    this.user,
    this.profile,
    this.subscription,
    this.payments,
    this.trades,
  });

  @override
  List<Object?> get props => [user, profile, subscription, payments, trades];
}
