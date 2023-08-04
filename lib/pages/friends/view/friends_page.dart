import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pooapp/data/models/user_data.dart';
import 'package:pooapp/l10n/l10n.dart';
import 'package:pooapp/pages/friends/cubit/friends_cubit.dart';
import 'package:pooapp/pages/friends/cubit/friends_state.dart';
import 'package:pooapp/pages/friends/view/friend_item.dart';
import 'package:pooapp/widgets/app_bar_icon.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: _appBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: TextFormField(
                onChanged: (v) => context.read<FriendsCubit>().search(v),
                style: GoogleFonts.inter(),
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.search_friends,
                  hintStyle: GoogleFonts.inter(),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            BlocBuilder(
              bloc: context.read<FriendsCubit>(),
              builder: (context, state) {
                final users = List<UserData>.empty(growable: true);
                if (state is ReturningSearchData) {
                  users
                    ..clear()
                    ..addAll(state.users ?? []);
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) => FriendItem(
                      user: users[index],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
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
    );
  }
}
