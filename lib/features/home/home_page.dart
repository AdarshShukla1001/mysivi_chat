import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysivi_chat/core/di/injection_container.dart';
import 'package:mysivi_chat/features/history/presentation/screens/chat_history_page.dart';
import 'package:mysivi_chat/features/home/presentation/widgets/custom_tab_switcher.dart';
import '../users/presentation/user_list_page.dart';
import '../users/presentation/bloc/user_bloc.dart';
import '../users/presentation/bloc/user_event.dart';
import '../history/presentation/bloc/history_bloc.dart';
import '../history/presentation/bloc/history_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  bool _showAppBar = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
          _showAppBar = true;
        });
      }
    });
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
        BlocProvider(create: (_) => sl<UserBloc>()..add(LoadUsers())),
        BlocProvider(create: (_) => sl<HistoryBloc>()..add(LoadHistory())),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AnimatedSlide(
            offset: _showAppBar ? Offset.zero : const Offset(0, -1),
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            child: AppBar(
              backgroundColor: Colors.white.withValues(alpha: 0.9),
              elevation: 0,
              centerTitle: true,
              toolbarHeight: 70,

              actions: [const SizedBox(width: 8)],
              title: CustomTabSwitcher(
                selectedIndex: _currentIndex,
                onTabSelected: (index) {
                  setState(() => _currentIndex = index);
                  _tabController.animateTo(index);
                },
              ),
            ),
          ),
        ),
        body: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis != Axis.vertical ||
                notification.scrollDelta == null) {
              return false;
            }

            if (notification.scrollDelta! > 5 && _showAppBar) {
              setState(() => _showAppBar = false);
            } else if (notification.scrollDelta! < -5 && !_showAppBar) {
              setState(() => _showAppBar = true);
            }
            return false;
          },
          child: TabBarView(
            controller: _tabController,
            children: const [UserListPage(), ChatHistoryPage()],
          ),
        ),
      ),
    );
  }
}
