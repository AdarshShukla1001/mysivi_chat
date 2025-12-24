import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/widgets/custom_tab_switcher.dart';
import '../../../users/presentation/screens/users_page.dart';
import '../../../users/presentation/bloc/users_cubit.dart';
import '../../../history/presentation/screens/chat_history_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Tracking index to update FAB visibility
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _currentIndex) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addUser(BuildContext context) {
    // Show dialog or invalidating the input
    // For now, simpler: Just add a mock user
    final names = ['Alice', 'Bob', 'Charlie', 'David', 'Eve', 'Frank'];
    final name = names[DateTime.now().second % names.length];

    context.read<UsersCubit>().addUser(name);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('User added: $name')));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UsersCubit(),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: CustomTabSwitcher(
                  selectedIndex: _currentIndex,
                  onTabSelected: (index) {
                    _tabController.animateTo(index);
                  },
                ),
                centerTitle: true,
                floating: true,
                snap: true,
                forceElevated: innerBoxIsScrolled,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Colors.transparent,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: const [UsersPage(), ChatHistoryPage()],
          ),
        ),
        floatingActionButton: _currentIndex == 0
            ? Builder(
                builder: (context) {
                  return FloatingActionButton(
                    onPressed: () => _addUser(context),
                    child: const Icon(Icons.add),
                  );
                },
              )
            : null,
      ),
    );
  }
}
