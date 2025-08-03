// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuccessMessageModel _$SuccessMessageModelFromJson(Map<String, dynamic> json) =>
    SuccessMessageModel(
      messageModel: json['message'] as String,
    );

Map<String, dynamic> _$SuccessMessageModelToJson(
        SuccessMessageModel instance) =>
    <String, dynamic>{
      'message': instance.messageModel,
    };

UserExportDetailModel _$UserExportDetailModelFromJson(
        Map<String, dynamic> json) =>
    UserExportDetailModel(
      idModel: json['_id'] as String?,
      fullNameModel: json['fullName'] as String?,
      emailModel: json['email'] as String?,
      roleModel: json['role'] as String?,
      createdAtModel: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAtModel: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserExportDetailModelToJson(
        UserExportDetailModel instance) =>
    <String, dynamic>{
      '_id': instance.idModel,
      'fullName': instance.fullNameModel,
      'email': instance.emailModel,
      'role': instance.roleModel,
      'createdAt': instance.createdAtModel?.toIso8601String(),
      'updatedAt': instance.updatedAtModel?.toIso8601String(),
    };

ProfileExportDetailModel _$ProfileExportDetailModelFromJson(
        Map<String, dynamic> json) =>
    ProfileExportDetailModel(
      idModel: json['_id'] as String?,
      userIdModel: json['user'] as String?,
      firstNameModel: json['firstName'] as String?,
      lastNameModel: json['lastName'] as String?,
      bioModel: json['bio'] as String?,
      avatarModel: json['avatar'] as String?,
      subscriptionIdModel: json['subscription'] as String?,
      createdAtModel: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAtModel: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProfileExportDetailModelToJson(
        ProfileExportDetailModel instance) =>
    <String, dynamic>{
      '_id': instance.idModel,
      'user': instance.userIdModel,
      'firstName': instance.firstNameModel,
      'lastName': instance.lastNameModel,
      'bio': instance.bioModel,
      'avatar': instance.avatarModel,
      'subscription': instance.subscriptionIdModel,
      'createdAt': instance.createdAtModel?.toIso8601String(),
      'updatedAt': instance.updatedAtModel?.toIso8601String(),
    };

SubscriptionExportDetailModel _$SubscriptionExportDetailModelFromJson(
        Map<String, dynamic> json) =>
    SubscriptionExportDetailModel(
      idModel: json['_id'] as String?,
      userIdModel: json['userId'] as String?,
      planModel: json['plan'] as String?,
      billingCycleModel: json['billingCycle'] as String?,
      priceModel: (json['price'] as num?)?.toDouble(),
      statusModel: json['status'] as String?,
      startDateModel: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDateModel: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      createdAtModel: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAtModel: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SubscriptionExportDetailModelToJson(
        SubscriptionExportDetailModel instance) =>
    <String, dynamic>{
      '_id': instance.idModel,
      'userId': instance.userIdModel,
      'plan': instance.planModel,
      'billingCycle': instance.billingCycleModel,
      'price': instance.priceModel,
      'status': instance.statusModel,
      'startDate': instance.startDateModel?.toIso8601String(),
      'endDate': instance.endDateModel?.toIso8601String(),
      'createdAt': instance.createdAtModel?.toIso8601String(),
      'updatedAt': instance.updatedAtModel?.toIso8601String(),
    };

PaymentExportDetailModel _$PaymentExportDetailModelFromJson(
        Map<String, dynamic> json) =>
    PaymentExportDetailModel(
      idModel: json['_id'] as String?,
      userIdModel: json['userId'] as String?,
      subscriptionIdModel: json['subscriptionId'] as String?,
      amountModel: (json['amount'] as num?)?.toDouble(),
      currencyModel: json['currency'] as String?,
      paymentMethodModel: json['paymentMethod'] as String?,
      statusModel: json['status'] as String?,
      createdAtModel: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAtModel: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PaymentExportDetailModelToJson(
        PaymentExportDetailModel instance) =>
    <String, dynamic>{
      '_id': instance.idModel,
      'userId': instance.userIdModel,
      'subscriptionId': instance.subscriptionIdModel,
      'amount': instance.amountModel,
      'currency': instance.currencyModel,
      'paymentMethod': instance.paymentMethodModel,
      'status': instance.statusModel,
      'createdAt': instance.createdAtModel?.toIso8601String(),
      'updatedAt': instance.updatedAtModel?.toIso8601String(),
    };

TradeExportDetailModel _$TradeExportDetailModelFromJson(
        Map<String, dynamic> json) =>
    TradeExportDetailModel(
      idModel: json['_id'] as String?,
      userIdModel: json['user'] as String?,
      symbolModel: json['symbol'] as String?,
      statusModel: json['status'] as String?,
      assetClassModel: json['assetClass'] as String?,
      tradeDirectionModel: json['tradeDirection'] as String?,
      entryDateModel: json['entryDate'] == null
          ? null
          : DateTime.parse(json['entryDate'] as String),
      entryPriceModel: (json['entryPrice'] as num?)?.toDouble(),
      positionSizeModel: (json['positionSize'] as num?)?.toInt(),
      exitDateModel: json['exitDate'] == null
          ? null
          : DateTime.parse(json['exitDate'] as String),
      exitPriceModel: (json['exitPrice'] as num?)?.toDouble(),
      feesModel: (json['fees'] as num?)?.toDouble(),
      tagsModel:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      notesModel: json['notes'] as String?,
      chartScreenshotUrlModel: json['chartScreenshotUrl'] as String?,
      createdAtModel: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAtModel: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TradeExportDetailModelToJson(
        TradeExportDetailModel instance) =>
    <String, dynamic>{
      '_id': instance.idModel,
      'user': instance.userIdModel,
      'symbol': instance.symbolModel,
      'status': instance.statusModel,
      'assetClass': instance.assetClassModel,
      'tradeDirection': instance.tradeDirectionModel,
      'entryDate': instance.entryDateModel?.toIso8601String(),
      'entryPrice': instance.entryPriceModel,
      'positionSize': instance.positionSizeModel,
      'exitDate': instance.exitDateModel?.toIso8601String(),
      'exitPrice': instance.exitPriceModel,
      'fees': instance.feesModel,
      'tags': instance.tagsModel,
      'notes': instance.notesModel,
      'chartScreenshotUrl': instance.chartScreenshotUrlModel,
      'createdAt': instance.createdAtModel?.toIso8601String(),
      'updatedAt': instance.updatedAtModel?.toIso8601String(),
    };

UserDataExportModel _$UserDataExportModelFromJson(Map<String, dynamic> json) =>
    UserDataExportModel(
      userModel: json['user'] == null
          ? null
          : UserExportDetailModel.fromJson(
              json['user'] as Map<String, dynamic>),
      profileModel: json['profile'] == null
          ? null
          : ProfileExportDetailModel.fromJson(
              json['profile'] as Map<String, dynamic>),
      subscriptionModel: json['subscription'] == null
          ? null
          : SubscriptionExportDetailModel.fromJson(
              json['subscription'] as Map<String, dynamic>),
      paymentsModel: (json['payments'] as List<dynamic>?)
          ?.map((e) =>
              PaymentExportDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      tradesModel: (json['trades'] as List<dynamic>?)
          ?.map(
              (e) => TradeExportDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserDataExportModelToJson(
        UserDataExportModel instance) =>
    <String, dynamic>{
      'user': instance.userModel,
      'profile': instance.profileModel,
      'subscription': instance.subscriptionModel,
      'payments': instance.paymentsModel,
      'trades': instance.tradesModel,
    };
