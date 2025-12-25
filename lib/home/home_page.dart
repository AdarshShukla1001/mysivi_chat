import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/users/presentation/user_list_page.dart';
import '../features/history/presentation/chat_history_page.dart';
import '../features/users/presentation/bloc/user_bloc.dart';
import '../features/users/presentation/bloc/user_event.dart';
import '../features/history/presentation/bloc/history_bloc.dart';
import '../features/history/presentation/bloc/history_event.dart';
import '../core/di/service_locator.dart';
import '../features/home/presentation/widgets/custom_tab_switcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (_) => sl<UserBloc>()..add(LoadUsers())),
        BlocProvider<HistoryBloc>(
          create: (_) => sl<HistoryBloc>()..add(LoadHistory()),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              TabBarView(
                controller: _tabController,
                children: const [UserListPage(), ChatHistoryPage()],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 80,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  alignment: Alignment.center,
                  child: CustomTabSwitcher(
                    selectedIndex: _currentIndex,
                    onTabSelected: (index) {
                      setState(() => _currentIndex = index);
                      _tabController.animateTo(index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
