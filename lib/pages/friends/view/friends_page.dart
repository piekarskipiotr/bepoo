import 'package:bepoo/di/get_it.dart';
import 'package:bepoo/l10n/l10n.dart';
import 'package:bepoo/pages/friends/cubit/friends_cubit.dart';
import 'package:bepoo/pages/friends/cubit/friends_item_cubit.dart';
import 'package:bepoo/pages/friends/cubit/friends_state.dart';
import 'package:bepoo/pages/friends/view/friend_item.dart';
import 'package:bepoo/pages/friends/view/friends_empty_list.dart';
import 'package:bepoo/widgets/app_bar_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final _refreshController = RefreshController();
  final _requestsRefreshController = RefreshController();
  final _allFriendsRefreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _appBar(),
        body: SafeArea(
          child: TabBarView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: TextFormField(
                      onChanged: (v) {
                        _refreshController.resetNoData();
                        context.read<FriendsCubit>().search(v);
                      },
                      style: GoogleFonts.inter(),
                      decoration: InputDecoration(
                        hintText: l10n.search_friends,
                        hintStyle: GoogleFonts.inter(),
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  _searchList(),
                ],
              ),
              _requestsList(),
              _allFriendsList(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    final l10n = context.l10n;

    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        l10n.friends,
        style: GoogleFonts.inter(),
      ),
      leadingWidth: 64,
      leading: AppBarIcon(
        onPressed: () => context.pop(),
        icon: Icons.arrow_back_ios_new,
        isLeading: true,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: TabBar(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (_) => Colors.transparent,
          ),
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(.7),
          labelStyle: GoogleFonts.inter(),
          tabs: [
            Tab(text: l10n.search),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (context
                    .read<FriendsCubit>()
                    .requestUsersList
                    .isNotEmpty) ...[
                  const Icon(Icons.circle, size: 8, color: Colors.deepOrange),
                  const SizedBox(width: 8),
                ],
                Tab(text: l10n.requests),
              ],
            ),
            Tab(text: l10n.all_friends),
          ],
        ),
      ),
    );
  }

  Widget _searchList() {
    final l10n = context.l10n;
    return BlocBuilder(
      bloc: context.read<FriendsCubit>(),
      builder: (context, state) {
        final users = context.read<FriendsCubit>().usersList;
        if (state is Searching) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        return Expanded(
          child: users.isEmpty
              ? FriendsEmptyList(text: l10n.friends_empty_list)
              : SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: users.length >= 10,
                  enablePullDown: false,
                  onLoading: () => context.read<FriendsCubit>().fetchNextPage(
                        _refreshController,
                      ),
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (_) => getIt<FriendsItemCubit>(),
                        ),
                        BlocProvider.value(
                          value: context.read<FriendsCubit>(),
                        ),
                      ],
                      child: FriendItem(
                        user: users[index],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _requestsList() {
    final l10n = context.l10n;
    return BlocBuilder(
      bloc: context.read<FriendsCubit>(),
      builder: (context, state) {
        final users = context.read<FriendsCubit>().requestUsersList;
        if (state is GettingUserFriendsInfo) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        return SmartRefresher(
          controller: _requestsRefreshController,
          onRefresh: () => context.read<FriendsCubit>().fetchUserFriendsInfo(
                refreshController: _requestsRefreshController,
              ),
          child: users.isEmpty
              ? FriendsEmptyList(text: l10n.requests_empty_list)
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ListView.builder(
                    primary: false,
                    itemCount: users.length,
                    itemBuilder: (context, index) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (_) => getIt<FriendsItemCubit>(),
                        ),
                        BlocProvider.value(
                          value: context.read<FriendsCubit>(),
                        ),
                      ],
                      child: FriendItem(
                        user: users[index],
                        hasRequested: true,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _allFriendsList() {
    final l10n = context.l10n;
    return BlocBuilder(
      bloc: context.read<FriendsCubit>(),
      builder: (context, state) {
        final users = context.read<FriendsCubit>().friendUsersList;
        if (state is GettingUserFriendsInfo) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        return SmartRefresher(
          controller: _allFriendsRefreshController,
          onRefresh: () => context.read<FriendsCubit>().fetchUserFriendsInfo(
                refreshController: _allFriendsRefreshController,
              ),
          child: users.isEmpty
              ? FriendsEmptyList(text: l10n.all_friends_empty_list)
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ListView.builder(
                    primary: false,
                    itemCount: users.length,
                    itemBuilder: (context, index) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (_) => getIt<FriendsItemCubit>(),
                        ),
                        BlocProvider.value(
                          value: context.read<FriendsCubit>(),
                        ),
                      ],
                      child: FriendItem(
                        user: users[index],
                        isFriend: true,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
