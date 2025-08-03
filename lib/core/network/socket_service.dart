// lib/features/chat/data/datasources/socket_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tradeverse/app/secure_storage/secure_storage_service.dart';
import 'package:tradeverse/core/error/failure.dart';
import 'package:tradeverse/features/chat/data/models/message_api_model.dart';
import 'package:tradeverse/features/notification/data/model/notification_api_model.dart'; // Import your SecureStorageService

abstract class SocketService {
  void connect();
  void disconnect();
  void joinUserRoom(String userId);
  void joinConversation(String conversationId);
  void sendMessage(Map<String, dynamic> messageData);
  Stream<MessageApiModel> listenForMessages();
  Stream<NotificationApiModel> get onNewNotification;
  void dispose(); // Add dispose method to close the stream controller
}

class SocketServiceImpl implements SocketService {
  final IO.Socket _socket;
  final SecureStorageService _secureStorageService;
  final StreamController<MessageApiModel> _messageController =
      StreamController<MessageApiModel>.broadcast();
  final StreamController<NotificationApiModel> _notificationController =
      StreamController<NotificationApiModel>.broadcast();

  String? _currentUserId; // Will be fetched from secure storage

  SocketServiceImpl(this._socket, this._secureStorageService) {
    _loadUserIdAndSetupListeners();
  }

  // Asynchronously loads the user ID and then sets up socket listeners
  Future<void> _loadUserIdAndSetupListeners() async {
    _currentUserId =
        await _secureStorageService.getId(); // Assuming 'userId' key
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    _socket.onConnect((_) {
      debugPrint('Socket Connected');
      if (_currentUserId != null) {
        joinUserRoom(_currentUserId!);
      } else {
        debugPrint(
          'Current user ID not available, cannot join user room upon connect.',
        );
      }
    });
    _socket.onDisconnect((_) {
      debugPrint('Socket Disconnected');
    });
    _socket.onConnectError((err) => debugPrint('Socket Connect Error: $err'));
    _socket.onError((err) => debugPrint('Socket Error: $err'));

    // Listen for 'receive_message' events and add them to the stream controller
    _socket.on('receive_message', (data) {
      try {
        debugPrint('Received message via socket: $data');
        final message = MessageApiModel.fromJson(data as Map<String, dynamic>);
        _messageController.add(message);
      } catch (e) {
        debugPrint('Error parsing received message: $e');
        _messageController.addError(
          SocketFailure(message: 'Error parsing message: $e'),
        );
      }
    });

    // Also listen for 'new_message' events from the backend controller
    _socket.on('new_message', (data) {
      try {
        debugPrint('Received NEW message via socket: $data');
        final message = MessageApiModel.fromJson(data as Map<String, dynamic>);
        _messageController.add(message);
      } catch (e) {
        debugPrint('Error parsing received NEW message: $e');
        _messageController.addError(
          SocketFailure(message: 'Error parsing NEW message: $e'),
        );
      }
    });

    _socket.on('new_notification', (data) {
      try {
        debugPrint('Received NEW notification via socket: $data');
        final notification = NotificationApiModel.fromJson(
          data as Map<String, dynamic>,
        );
        _notificationController.add(notification);
      } catch (e) {
        debugPrint('Error parsing received NEW notification: $e');
        _notificationController.addError(
          SocketFailure(message: 'Error parsing NEW notification: $e'),
        );
      }
    });
  }

  @override
  void connect() {
    if (!_socket.connected) {
      _socket.connect();
    }
  }

  @override
  void disconnect() {
    if (_socket.connected) {
      _socket.disconnect();
    }
  }

  @override
  void joinUserRoom(String userId) {
    if (_socket.connected) {
      _socket.emit('join_user_room', userId);
      debugPrint('Joined user room: $userId');
    } else {
      debugPrint('Socket not connected, cannot join user room.');
    }
  }

  @override
  void joinConversation(String conversationId) {
    if (_socket.connected) {
      _socket.emit('join_conversation', conversationId);
      debugPrint('Joined conversation room: $conversationId');
    } else {
      debugPrint('Socket not connected, cannot join conversation room.');
    }
  }

  @override
  void sendMessage(Map<String, dynamic> messageData) {
    if (_socket.connected) {
      _socket.emit('send_message', messageData);
      debugPrint('Sent message via socket: $messageData');
    } else {
      debugPrint('Socket not connected, cannot send message.');
    }
  }

  @override
  Stream<MessageApiModel> listenForMessages() {
    return _messageController.stream; // Return the stream from the controller
  }

  @override
  Stream<NotificationApiModel> get onNewNotification =>
      _notificationController.stream;

  @override
  void dispose() {
    _messageController.close();
    _notificationController.close();
    disconnect();
  }
}
