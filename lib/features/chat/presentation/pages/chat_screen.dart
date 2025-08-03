import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/chat/domain/entity/conversation.dart';
import 'package:tradeverse/features/chat/domain/entity/user.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_bloc.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_event.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_state.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final Conversation conversation;
  final User currentUser;
  final User recipient; // The other participant in the conversation

  const ChatScreen({
    super.key,
    required this.conversation,
    required this.currentUser,
    required this.recipient,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Ensure messages are loaded when entering the chat screen
    context.read<ChatBloc>().add(
      LoadMessages(conversationId: widget.conversation.id),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      context.read<ChatBloc>().add(
        SendMessage(
          // conversationId: widget.conversation.id, // Conversation ID is handled internally by bloc's currentConversationId
          text: _messageController.text,
          sender: widget.currentUser,
          recipient: widget.recipient,
        ),
      );
      _messageController.clear();
      // Scroll to the bottom after sending a message
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipient.fullName)),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded) {
                  // Only scroll to bottom when messages are loaded or a new message is received
                  if (state.messagesStatus == MessagesLoadingStatus.loaded ||
                      (state.messages.isNotEmpty &&
                          state.messages.last.sender.id ==
                              widget.currentUser.id)) {
                    _scrollToBottom();
                  }
                  if (state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage!)),
                    );
                    // Clear the error message after showing
                    // For now, reloading conversations will clear the error message in state
                    context.read<ChatBloc>().add(const LoadConversations());
                  }
                }
              },
              builder: (context, state) {
                if (state is ChatLoaded) {
                  if (state.messagesStatus == MessagesLoadingStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.messages.isEmpty) {
                    return const Center(child: Text('Say hello!'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final bool isMe =
                          message.sender.id == widget.currentUser.id;
                      return MessageBubble(message: message, isMe: isMe);
                    },
                  );
                }
                return const Center(child: Text('No messages.'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
