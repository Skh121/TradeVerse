// features/payment/presentation/view_model/deep_link_listener.dart

import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:tradeverse/app/secure_storage/secure_storage_service.dart';
import 'package:tradeverse/app/service_locator/service_locator.dart';
import 'package:tradeverse/features/payment/presentation/view_model/payment_event.dart';
import 'package:tradeverse/features/payment/presentation/view_model/payment_view_model.dart';

class DeepLinkListener {
  final AppLinks _appLinks = AppLinks();
  final PaymentViewModel paymentViewModel;
  StreamSubscription? _sub;

  DeepLinkListener({required this.paymentViewModel});

  void startListening() {
    debugPrint('🔵 DeepLinkListener: Starting to listen for URI links...');
    _sub = _appLinks.uriLinkStream.listen(
      (uri) async {
        debugPrint('🟢 DeepLinkListener: Received URI: $uri');
        if (uri.scheme == 'tradeverse' && uri.host == 'checkout-success') {
          final sessionId = uri.queryParameters['session_id'];
          debugPrint('🟢 DeepLinkListener: Session ID from URI: $sessionId');
          final secureStorage = serviceLocator<SecureStorageService>();
          final email = await secureStorage.getEmail();
          debugPrint('🟢 DeepLinkListener: Retrieved email: $email');

          if (sessionId != null && sessionId.isNotEmpty && email != null) {
            debugPrint(
              '🟢 DeepLinkListener: Dispatching VerifyPayment event with sessionId: $sessionId, email: $email',
            );
            paymentViewModel.add(
              VerifyPayment(sessionId: sessionId, email: email),
            );
          } else {
            debugPrint(
              '🟡 DeepLinkListener: Missing sessionId or email from deep link. SessionId: $sessionId, Email: $email',
            );
          }
        } else {
          debugPrint(
            '🟡 DeepLinkListener: URI not matching expected scheme/host: ${uri.scheme}://${uri.host}',
          );
        }
      },
      onError: (error) {
        debugPrint('🔴 DeepLinkListener: Error: $error');
      },
      onDone: () {
        debugPrint('🔵 DeepLinkListener: Stream done.');
      },
    );
  }

  void dispose() {
    debugPrint('🔵 DeepLinkListener: Disposing stream subscription.');
    _sub?.cancel();
  }
}
