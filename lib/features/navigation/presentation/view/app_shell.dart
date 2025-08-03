import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Still needed for context.read
import 'package:tradeverse/features/chat/presentation/pages/conversation_list_screen.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_bloc.dart';
import 'package:tradeverse/features/chat/presentation/view_model/chat_event.dart';
// Import your feature views
import 'package:tradeverse/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:tradeverse/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:tradeverse/features/settings/presentation/view/settings_view.dart';

// Import Bloc events for dispatching on tab tap
import 'package:tradeverse/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:tradeverse/features/trade/presentation/view/trade_view.dart';
import 'package:tradeverse/features/trade/presentation/view_model/trade_event.dart';
import 'package:tradeverse/features/trade/presentation/view_model/trade_view_model.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Dashboard(),
    const ConversationListScreen(),
    const TradeView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // Use IndexedStack to preserve state of tabs
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            context.read<DashboardViewModel>().add(FetchDashboardStats());
          } else if (index == 1) {
            context.read<ChatBloc>().add(LoadConversations());
          } else if (index == 2) {
            context.read<TradeViewModel>().add(const FetchAllTrades());
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/dashboardIcon.png')),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Journal',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Settings'),
        ],
      ),
    );
  }
}
