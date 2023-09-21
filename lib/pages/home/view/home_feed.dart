import 'package:bepoo/pages/home/cubit/home_feed_cubit.dart';
import 'package:bepoo/pages/home/cubit/home_feed_state.dart';
import 'package:bepoo/pages/home/view/home_empty_feed.dart';
import 'package:bepoo/pages/home/view/poost_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  final _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    context.read<HomeFeedCubit>().fetchPoosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: context.read<HomeFeedCubit>(),
      builder: (context, state) {
        final poosts = context.read<HomeFeedCubit>().poostsList;
        if (state is FetchingPoosts && poosts.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        return SmartRefresher(
          controller: _refreshController,
          enablePullUp: poosts.length >= 5,
          onRefresh: () => context.read<HomeFeedCubit>().fetchPoosts(
                refreshController: _refreshController,
              ),
          onLoading: () => context.read<HomeFeedCubit>().fetchNextPage(
                _refreshController,
              ),
          child: poosts.isEmpty
              ? const HomeEmptyFeed()
              : ListView.builder(
                  itemCount: poosts.length,
                  itemBuilder: (context, index) => PoostItem(
                    poost: poosts[index],
                  ),
                ),
        );
      },
    );
  }
}
