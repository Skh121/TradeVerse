import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tradeverse/app/constant/hive/hive_table_constant.dart';
import 'package:tradeverse/features/auth/data/model/auth_hive_model.dart';
import 'package:tradeverse/features/chat/data/models/conversation_hive_model.dart';
import 'package:tradeverse/features/chat/data/models/message_hive_model.dart';
import 'package:tradeverse/features/chat/data/models/user_hive_model.dart';
import 'package:tradeverse/features/dashboard/data/models/dashboard_hive_models.dart';
import 'package:tradeverse/features/goal/data/model/goal_hive_model.dart';
import 'package:tradeverse/features/notification/data/model/notification_hive_model.dart';
import 'package:tradeverse/features/notification/data/model/sender_hive_model.dart';
import 'package:tradeverse/features/payment/data/model/payment_hive_model.dart';
import 'package:tradeverse/features/profile/data/model/profile_hive_model.dart';
import 'package:tradeverse/features/trade/data/model/paginated_trade_hive_model.dart';
import 'package:tradeverse/features/trade/data/model/trade_hive_model.dart';

class HiveService {
  late Box<AuthHiveModel> _userBox;
  late Box<PaymentHiveModel> _paymentBox;
  late Box<DashboardStatsHiveModel> _dashboardStatsBox;
  late Box<GoalHiveModel> _goalBox;
  late Box<ProfileHiveModel> _profileBox;
  late Box<TradeHiveModel> _tradeBox;
  late Box<PaginatedTradeHiveModel> _paginatedTradeBox;
  late Box<ConversationHiveModel> _conversationBox;
  late Box<MessageHiveModel> _messageBox;
  late Box<UserHiveModel> _chatUserBox;
  late Box<NotificationHiveModel> _notificationBox;
  // late Box<SenderHiveModel> _senderBox;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    // Using a subdirectory for Hive files is a good practice.
    Hive.init('${dir.path}/db');

    Hive.registerAdapter(AuthHiveModelAdapter());
    Hive.registerAdapter(PaymentHiveModelAdapter());
    Hive.registerAdapter(FlSpotAdapter());
    Hive.registerAdapter(RecentTradeHiveModelAdapter());
    Hive.registerAdapter(ThisWeekSummaryHiveModelAdapter());
    Hive.registerAdapter(DashboardStatsHiveModelAdapter());
    Hive.registerAdapter(GoalHiveModelAdapter());
    Hive.registerAdapter(SubscriptionHiveModelAdapter());
    Hive.registerAdapter(UserDetailHiveModelAdapter());
    Hive.registerAdapter(ProfileHiveModelAdapter());
    Hive.registerAdapter(TradeHiveModelAdapter());
    Hive.registerAdapter(PaginatedTradeHiveModelAdapter());
    Hive.registerAdapter(UserHiveModelAdapter());
    Hive.registerAdapter(ConversationHiveModelAdapter());
    Hive.registerAdapter(MessageHiveModelAdapter());
    Hive.registerAdapter(NotificationHiveModelAdapter());
    Hive.registerAdapter(SenderHiveModelAdapter());

    _userBox = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    _paymentBox = await Hive.openBox<PaymentHiveModel>(
      HiveTableConstant.paymentBox,
    );
    _dashboardStatsBox = await Hive.openBox<DashboardStatsHiveModel>(
      HiveTableConstant.dashboardStatsBox,
    );
    _goalBox = await Hive.openBox<GoalHiveModel>(HiveTableConstant.goalBox);
    _profileBox = await Hive.openBox<ProfileHiveModel>(
      HiveTableConstant.profileBox,
    );
    _tradeBox = await Hive.openBox<TradeHiveModel>(HiveTableConstant.tradeBox);
    _paginatedTradeBox = await Hive.openBox<PaginatedTradeHiveModel>(
      HiveTableConstant.paginatedTradeBox,
    );
    _conversationBox = await Hive.openBox<ConversationHiveModel>(
      HiveTableConstant.conversationBox,
    );
    _messageBox = await Hive.openBox<MessageHiveModel>(
      HiveTableConstant.messageBox,
    );
    _chatUserBox = await Hive.openBox<UserHiveModel>(
      HiveTableConstant.chatUserBox,
    );
    _notificationBox = await Hive.openBox<NotificationHiveModel>(
      HiveTableConstant.notificationBox,
    );
    // _senderBox = await Hive.openBox<SenderHiveModel>(HiveTableConstant.senderBox);
  }

  Box<AuthHiveModel> get userBox => _userBox;
  Box<PaymentHiveModel> get paymentBox => _paymentBox;
  Box<DashboardStatsHiveModel> get dashboardStatsBox => _dashboardStatsBox;
  Box<GoalHiveModel> get goalBox => _goalBox;
  Box<ProfileHiveModel> get profileBox => _profileBox;
  Box<TradeHiveModel> get tradeBox => _tradeBox;
  Box<PaginatedTradeHiveModel> get paginatedTradeBox => _paginatedTradeBox;
  Box<ConversationHiveModel> get conversationBox => _conversationBox;
  Box<MessageHiveModel> get messageBox => _messageBox;
  Box<UserHiveModel> get chatUserBox => _chatUserBox;
  Box<NotificationHiveModel> get notificationBox => _notificationBox;

  /// Saves or updates a user in the Hive box.
  /// The user's email is used as the key for easy lookup.
  Future<void> createAccount(AuthHiveModel auth) async {
    // Use the email as the key to prevent duplicate users and allow easy updates.
    await _userBox.put(auth.email, auth);
  }

  /// Finds a user by email. This is more efficient than iterating through all users.
  Future<AuthHiveModel?> login(String email) async {
    // Directly look up the user by their email key.
    final user = _userBox.get(email);
    return user;
  }

  Future<void> close() async {
    await _userBox.close();
    await _paymentBox.close();
  }

  Future<void> clearAllUserData() async {
    // await _userBox.clear(); 
    // await _paymentBox.clear();
    // await _dashboardStatsBox.clear();
    // await _goalBox.clear();
    // await _profileBox.clear();
    // await _tradeBox.clear();
    // await _paginatedTradeBox.clear();
    // await _conversationBox.clear();
    // await _messageBox.clear();
    // await _chatUserBox.clear();
    // await _notificationBox.clear();
  }
}
