import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/app/secure_storage/secure_storage_service.dart';
import 'package:tradeverse/app/service_locator/service_locator.dart';
import 'package:tradeverse/features/chat/data/models/user_api_model.dart';
import 'package:tradeverse/features/chat/domain/entity/user.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_bloc.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_event.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_state.dart';
import '../widgets/conversation_tile.dart';
import 'chat_screen.dart';
import 'new_conversation_screen.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  User? _currentUser; // Make it nullable and non-final
  late ChatBloc _chatBloc; // Declare a late variable to hold the Bloc instance

  @override
  void initState() {
    super.initState();
    // Get the Bloc instance here in initState, it's safe to use context here
    _chatBloc = context.read<ChatBloc>();
    _loadCurrentUser(); // Load user data asynchronously
  }

  Future<void> _loadCurrentUser() async {
    // Access secureStorage via serviceLocator
    final secureStorage =
        serviceLocator<
          SecureStorageService
        >(); // Using your SecureStorageService
    final userId = await secureStorage.getId();
    final fullName = await secureStorage.getFullName();
    final role = await secureStorage.getRole();

    // IMPORTANT: Guard against context use across async gaps
    if (!mounted) return;

    if (userId != null && fullName != null && role != null) {
      setState(() {
        _currentUser = User(id: userId, fullName: fullName, role: role);
      });

      // Connect socket and join user room only if user data is available
      // Use the stored _chatBloc instance
      _chatBloc.add(const ConnectSocket());
      _chatBloc.add(JoinUserRoom(userId: _currentUser!.id));
      // Load conversations when the screen initializes
      _chatBloc.add(const LoadConversations());
    } else {
      // Handle case where user data is not found (e.g., redirect to login)
      debugPrint(
        'User data not found in secure storage. Cannot initialize chat.',
      );
      // You might want to show a message to the user or navigate to a login screen.
      // Example: Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    // Use the stored _chatBloc instance in dispose, no context needed
    _chatBloc.add(const DisconnectSocket());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Conversations')),
        body: const Center(
          child: CircularProgressIndicator(),
        ), // Show loading indicator while fetching user
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ChatBloc>().add(const LoadConversations());
            },
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded) {
            if (state.conversations.isEmpty) {
              return const Center(
                child: Text(
                  'No conversations yet. Start a new one!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.conversations.length,
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];
                // Determine the other participant's name for display
                final otherParticipant = conversation.participants.firstWhere(
                  (p) =>
                      p.id !=
                      _currentUser!
                          .id, // Use _currentUser! as it's guaranteed non-null here
                  orElse: () {
                    // Return a UserApiModel from _currentUser for type compatibility
                    return UserApiModel(
                      idModel: _currentUser!.id,
                      fullNameModel: _currentUser!.fullName,
                      roleModel: _currentUser!.role,
                    );
                  },
                );

                return ConversationTile(
                  conversation: conversation,
                  otherParticipantName: otherParticipant.fullName,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => BlocProvider.value(
                              value: context.read<ChatBloc>(),
                              child: ChatScreen(
                                conversation: conversation,
                                currentUser: _currentUser!, // Use _currentUser!
                                recipient: otherParticipant,
                              ),
                            ),
                      ),
                    );
                    context.read<ChatBloc>().add(
                      LoadMessages(conversationId: conversation.id),
                    );
                  },
                );
              },
            );
          }
          return const Center(
            child: Text('Press refresh to load conversations.'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: context.read<ChatBloc>(),
                    child: NewConversationScreen(
                      currentUser: _currentUser!,
                    ), // Use _currentUser!
                  ),
            ),
          );
        },
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}
