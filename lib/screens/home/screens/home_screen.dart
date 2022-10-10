import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/constants/colors_constants.dart';
import '../../../utils/constants/routes_constants.dart';
import '../../../utils/constants/string_constants.dart';
import '../../../utils/widgets/chats_list.dart';
import '../../calls_screen.dart';
import '../../sender_info/controllers/sender_user_data_controller.dart';
import '../../status/screens/status_screen.dart';
import '../widgets/home_fab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        ref.watch(senderUserDataControllerProvider).setSenderUserState(true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        ref.watch(senderUserDataControllerProvider).setSenderUserState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    log('build');
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: TabBarView(
          controller: _tabController,
          children: const [
            ChatsList(),
            StatusScreen(),
            CallsScreen(),
          ],
        ),
        floatingActionButton: HomeFAB(tabController: _tabController),
      ),
    );
  }

  /// AppBar of the home screen
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
      ),
      title: Text(
        StringsConsts.appName,
        style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.landingScreen,
              (route) => false,
            );
          },
          icon: const Icon(
            Icons.search,
            color: AppColors.appBarActionIcon,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_vert,
            color: AppColors.appBarActionIcon,
          ),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.white,
        indicatorWeight: 4.0,
        labelColor: AppColors.sTabLabel,
        unselectedLabelColor: AppColors.uTabLabel,
        labelStyle: Theme.of(context).textTheme.headlineSmall,
        tabs: const [
          Tab(text: 'CHATS'),
          Tab(text: 'STATUS'),
          Tab(text: 'CALLS'),
        ],
      ),
    );
  }
}
