class ApiEndpoints {
  ApiEndpoints._();

  static const connectionTimeout = Duration(seconds: 1000);

  static const receiveTimeout = Duration(seconds: 1000);

  // static const String serverAddress = "http://10.0.2.2:5050";
  static const String serverAddress = "http://192.168.254.12:5050";

  static const String baseUrl = "$serverAddress/api";

  static const String imageUrl = "$serverAddress/uploads";

  //Auth

  static const String register = "/auth/register";
  static const String login = "/auth/login";

  //payment
  static const String plans = "/auth/subscription/plans";
  static const String checkout = "/auth/checkout";
  static const String verifyPayment = "/auth/checkout/verify-payment";

  //dashboard
  static const String recentTrades = "/admin/log/stats";

  //goals
  static const String getGoals = "/admin/goals";
  static String deleteGoal(String id) => "/admin/goals/$id";

  //profile
  static const String getProfile = "/admin/settings/profile/me";

  //security
  static const String changePassword =
      "/admin/settings/security/change-password";
  static const String deleteMyAccount = "/admin/settings/security/me";
  static const String exportMyData = "/admin/settings/security/me/export";

  //Journaling
  static const String trades = "/admin/log";
  static String tradeById(String id) => "/admin/log/$id";

  //chat
  static const String conversations = "/admin/conversations";
  static const String chatUsers = "/admin/conversations/users";
  static const String createMessage = "/admin/conversations/messages";
  static String getMessages(String conversationId) =>
      "/admin/conversations/$conversationId/messages";
  static const String findOrCreateConversation =
      "/admin/conversations/find-or-create";

  //forgot password
  static const String requestOtp = "/auth/request-otp";
  static const String verifyOtp = "/auth/verify-otp";
  static const String resetPasswordWithOtp = "/auth/reset-password-with-otp";

  //notification endpoint
  static const String getMyNotification = "/admin/notifications";
  static const String markNotificationAsRead = "/admin/notifications/read";
}
