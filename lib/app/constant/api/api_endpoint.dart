class ApiEndpoints {
  ApiEndpoints._();

  static const connectionTimeout = Duration(seconds: 1000);

  static const receiveTimeout = Duration(seconds: 1000);

  static const String serverAddress = "http://10.0.2.2:5050";

  static const String baseUrl = "$serverAddress/api";

  static const String imageUrl = "$serverAddress/uploads";

  //Auth

  static const String register = "/auth/register";
  static const String login = "/auth/login";
}
