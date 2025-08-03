import 'package:json_annotation/json_annotation.dart';
import 'package:tradeverse/features/security/domain/entity/security_entity.dart';

part 'security_api_model.g.dart'; 

/// Data model for a generic success message.
@JsonSerializable()
class SuccessMessageModel extends SuccessMessageEntity {
  @JsonKey(name: 'message')
  final String messageModel;

  const SuccessMessageModel({required this.messageModel})
    : super(message: messageModel);

  factory SuccessMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SuccessMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$SuccessMessageModelToJson(this);
}

// Data models for exported user data components

@JsonSerializable()
class UserExportDetailModel extends UserExportDetailEntity {
  @JsonKey(name: '_id')
  final String? idModel;
  @JsonKey(name: 'fullName')
  final String? fullNameModel;
  @JsonKey(name: 'email')
  final String? emailModel;
  @JsonKey(name: 'role')
  final String? roleModel;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAtModel;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAtModel;

  const UserExportDetailModel({
    this.idModel,
    this.fullNameModel,
    this.emailModel,
    this.roleModel,
    this.createdAtModel,
    this.updatedAtModel,
  }) : super(
         id: idModel,
         fullName: fullNameModel,
         email: emailModel,
         role: roleModel,
         createdAt: createdAtModel,
         updatedAt: updatedAtModel,
       );

  factory UserExportDetailModel.fromJson(Map<String, dynamic> json) =>
      _$UserExportDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserExportDetailModelToJson(this);
}

@JsonSerializable()
class ProfileExportDetailModel extends ProfileExportDetailEntity {
  @JsonKey(name: '_id')
  final String? idModel;
  @JsonKey(name: 'user')
  final String? userIdModel; // Backend sends user ID as string here
  @JsonKey(name: 'firstName')
  final String? firstNameModel;
  @JsonKey(name: 'lastName')
  final String? lastNameModel;
  @JsonKey(name: 'bio')
  final String? bioModel;
  @JsonKey(name: 'avatar')
  final String? avatarModel;
  @JsonKey(name: 'subscription')
  final String? subscriptionIdModel; // Backend sends subscription ID as string here
  @JsonKey(name: 'createdAt')
  final DateTime? createdAtModel;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAtModel;

  const ProfileExportDetailModel({
    this.idModel,
    this.userIdModel,
    this.firstNameModel,
    this.lastNameModel,
    this.bioModel,
    this.avatarModel,
    this.subscriptionIdModel,
    this.createdAtModel,
    this.updatedAtModel,
  }) : super(
         id: idModel,
         userId: userIdModel,
         firstName: firstNameModel,
         lastName: lastNameModel,
         bio: bioModel,
         avatar: avatarModel,
         subscriptionId: subscriptionIdModel,
         createdAt: createdAtModel,
         updatedAt: updatedAtModel,
       );

  factory ProfileExportDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileExportDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileExportDetailModelToJson(this);
}

@JsonSerializable()
class SubscriptionExportDetailModel extends SubscriptionExportDetailEntity {
  @JsonKey(name: '_id')
  final String? idModel;
  @JsonKey(name: 'userId')
  final String? userIdModel;
  @JsonKey(name: 'plan')
  final String? planModel;
  @JsonKey(name: 'billingCycle')
  final String? billingCycleModel;
  @JsonKey(name: 'price')
  final double? priceModel;
  @JsonKey(name: 'status')
  final String? statusModel;
  @JsonKey(name: 'startDate')
  final DateTime? startDateModel;
  @JsonKey(name: 'endDate')
  final DateTime? endDateModel;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAtModel;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAtModel;

  const SubscriptionExportDetailModel({
    this.idModel,
    this.userIdModel,
    this.planModel,
    this.billingCycleModel,
    this.priceModel,
    this.statusModel,
    this.startDateModel,
    this.endDateModel,
    this.createdAtModel,
    this.updatedAtModel,
  }) : super(
         id: idModel,
         userId: userIdModel,
         plan: planModel,
         billingCycle: billingCycleModel,
         price: priceModel,
         status: statusModel,
         startDate: startDateModel,
         endDate: endDateModel,
         createdAt: createdAtModel,
         updatedAt: updatedAtModel,
       );

  factory SubscriptionExportDetailModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionExportDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionExportDetailModelToJson(this);
}

@JsonSerializable()
class PaymentExportDetailModel extends PaymentExportDetailEntity {
  @JsonKey(name: '_id')
  final String? idModel;
  @JsonKey(name: 'userId')
  final String? userIdModel;
  @JsonKey(name: 'subscriptionId')
  final String? subscriptionIdModel;
  @JsonKey(name: 'amount')
  final double? amountModel;
  @JsonKey(name: 'currency')
  final String? currencyModel;
  @JsonKey(name: 'paymentMethod')
  final String? paymentMethodModel;
  @JsonKey(name: 'status')
  final String? statusModel;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAtModel;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAtModel;

  const PaymentExportDetailModel({
    this.idModel,
    this.userIdModel,
    this.subscriptionIdModel,
    this.amountModel,
    this.currencyModel,
    this.paymentMethodModel,
    this.statusModel,
    this.createdAtModel,
    this.updatedAtModel,
  }) : super(
         id: idModel,
         userId: userIdModel,
         subscriptionId: subscriptionIdModel,
         amount: amountModel,
         currency: currencyModel,
         paymentMethod: paymentMethodModel,
         status: statusModel,
         createdAt: createdAtModel,
         updatedAt: updatedAtModel,
       );

  factory PaymentExportDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentExportDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentExportDetailModelToJson(this);
}

@JsonSerializable()
class TradeExportDetailModel extends TradeExportDetailEntity {
  @JsonKey(name: '_id')
  final String? idModel;
  @JsonKey(name: 'user')
  final String? userIdModel; // Backend sends user ID as string here
  @JsonKey(name: 'symbol')
  final String? symbolModel;
  @JsonKey(name: 'status')
  final String? statusModel;
  @JsonKey(name: 'assetClass')
  final String? assetClassModel;
  @JsonKey(name: 'tradeDirection')
  final String? tradeDirectionModel;
  @JsonKey(name: 'entryDate')
  final DateTime? entryDateModel;
  @JsonKey(name: 'entryPrice')
  final double? entryPriceModel;
  @JsonKey(name: 'positionSize')
  final int? positionSizeModel;
  @JsonKey(name: 'exitDate')
  final DateTime? exitDateModel;
  @JsonKey(name: 'exitPrice')
  final double? exitPriceModel;
  @JsonKey(name: 'fees')
  final double? feesModel;
  @JsonKey(name: 'tags')
  final List<String>? tagsModel;
  @JsonKey(name: 'notes')
  final String? notesModel;
  @JsonKey(name: 'chartScreenshotUrl')
  final String? chartScreenshotUrlModel;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAtModel;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAtModel;

  const TradeExportDetailModel({
    this.idModel,
    this.userIdModel,
    this.symbolModel,
    this.statusModel,
    this.assetClassModel,
    this.tradeDirectionModel,
    this.entryDateModel,
    this.entryPriceModel,
    this.positionSizeModel,
    this.exitDateModel,
    this.exitPriceModel,
    this.feesModel,
    this.tagsModel,
    this.notesModel,
    this.chartScreenshotUrlModel,
    this.createdAtModel,
    this.updatedAtModel,
  }) : super(
         id: idModel,
         userId: userIdModel,
         symbol: symbolModel,
         status: statusModel,
         assetClass: assetClassModel,
         tradeDirection: tradeDirectionModel,
         entryDate: entryDateModel,
         entryPrice: entryPriceModel,
         positionSize: positionSizeModel,
         exitDate: exitDateModel,
         exitPrice: exitPriceModel,
         fees: feesModel,
         tags: tagsModel,
         notes: notesModel,
         chartScreenshotUrl: chartScreenshotUrlModel,
         createdAt: createdAtModel,
         updatedAt: updatedAtModel,
       );

  factory TradeExportDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TradeExportDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$TradeExportDetailModelToJson(this);
}

/// Data model representing the comprehensive exported user data.
@JsonSerializable()
class UserDataExportModel extends UserDataExportEntity {
  @JsonKey(name: 'user')
  final UserExportDetailModel? userModel;
  @JsonKey(name: 'profile')
  final ProfileExportDetailModel? profileModel;
  @JsonKey(name: 'subscription')
  final SubscriptionExportDetailModel? subscriptionModel;
  @JsonKey(name: 'payments')
  final List<PaymentExportDetailModel>? paymentsModel;
  @JsonKey(name: 'trades')
  final List<TradeExportDetailModel>? tradesModel;

  const UserDataExportModel({
    this.userModel,
    this.profileModel,
    this.subscriptionModel,
    this.paymentsModel,
    this.tradesModel,
  }) : super(
         user: userModel,
         profile: profileModel,
         subscription: subscriptionModel,
         payments: paymentsModel,
         trades: tradesModel,
       );

  factory UserDataExportModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataExportModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataExportModelToJson(this);
}
