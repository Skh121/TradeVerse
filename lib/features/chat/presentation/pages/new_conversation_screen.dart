import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/chat/domain/entity/user.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_bloc.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_event.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_state.dart';

class NewConversationScreen extends StatefulWidget {
  final User currentUser;

  const NewConversationScreen({super.key, required this.currentUser});

  @override
  State<NewConversationScreen> createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen> {
  @override
  void initState() {
    super.initState();
    // Access the existing ChatBloc instance via context.read
    context.read<ChatBloc>().add(const LoadChatUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start a New Conversation')),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ConversationOperationSuccess) {
            // Listen for the specific success state
            // Ensure context is still mounted before performing UI operations
            if (!mounted) return;

            final String message =
                state.isNewConversation
                    ? 'User added for conversation!'
                    : 'Conversation already exists.';

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));

            // Pop this screen to go back to ConversationListScreen
            Navigator.pop(context);
          }
          // Removed the old ChatLoaded navigation logic that was causing issues
          // The ChatLoaded state is still used by the builder, but not for navigation here.
        },
        builder: (context, state) {
          if (state is ChatLoaded) {
            // CORRECTED: Use ChatUsersLoadingStatus for comparison
            if (state.chatUsersStatus == ChatUsersLoadingStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.chatUsers.isEmpty) {
              return const Center(child: Text('No other users found.'));
            }
            return ListView.builder(
              itemCount: state.chatUsers.length,
              itemBuilder: (context, index) {
                final user = state.chatUsers[index];
                // Don't show current user in the list to start a new conversation with themselves
                if (user.id == widget.currentUser.id) {
                  return const SizedBox.shrink();
                }
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent.withOpacity(0.2),
                      child: Text(
                        user.fullName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      user.fullName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      user.role,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      // Dispatch the event to find or create conversation
                      context.read<ChatBloc>().add(
                        FindOrCreateNewConversation(recipientId: user.id),
                      );
                      // Show a temporary loading indicator or message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Processing...'),
                        ), // Generic message while processing
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Loading users...'));
        },
      ),
    );
  }
}
