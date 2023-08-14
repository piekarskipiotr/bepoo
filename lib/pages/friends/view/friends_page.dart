import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pooapp/di/get_it.dart';
import 'package:pooapp/l10n/l10n.dart';
import 'package:pooapp/pages/friends/cubit/friends_cubit.dart';
import 'package:pooapp/pages/friends/cubit/friends_item_cubit.dart';
import 'package:pooapp/pages/friends/view/friend_item.dart';
import 'package:pooapp/widgets/app_bar_icon.dart';
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
                      autofocus: true,
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
            Tab(text: l10n.requests),
            Tab(text: l10n.all_friends),
          ],
        ),
      ),
    );
  }

  Widget _searchList() {
    return BlocBuilder(
      bloc: context.read<FriendsCubit>(),
      builder: (context, state) {
        final users = context.read<FriendsCubit>().usersList;

        return Expanded(
          child: SmartRefresher(
            controller: _refreshController,
            enablePullUp: users.length >= 10,
            enablePullDown: false,
            onLoading: () => context.read<FriendsCubit>().fetchNextPage(
                  _refreshController,
                ),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) => BlocProvider(
                create: (_) => getIt<FriendsItemCubit>(),
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
    return BlocBuilder(
      bloc: context.read<FriendsCubit>(),
      builder: (context, state) {
        final users = context.read<FriendsCubit>().requestUsersList;

        return SmartRefresher(
          controller: _requestsRefreshController,
          onRefresh: () => context.read<FriendsCubit>().fetchUserFriendsInfo(
                refreshController: _requestsRefreshController,
              ),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) => BlocProvider(
              create: (_) => getIt<FriendsItemCubit>(),
              child: FriendItem(
                user: users[index],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _allFriendsList() {
    return BlocBuilder(
      bloc: context.read<FriendsCubit>(),
      builder: (context, state) {
        final users = context.read<FriendsCubit>().friendUsersList;

        return SmartRefresher(
          controller: _allFriendsRefreshController,
          onRefresh: () => context.read<FriendsCubit>().fetchUserFriendsInfo(
                refreshController: _allFriendsRefreshController,
              ),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) => BlocProvider(
              create: (_) => getIt<FriendsItemCubit>(),
              child: FriendItem(
                user: users[index],
              ),
            ),
          ),
        );
      },
    );
  }
}
