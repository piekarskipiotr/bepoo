import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pooapp/data/models/user_data.dart';
import 'package:pooapp/l10n/l10n.dart';
import 'package:pooapp/pages/friends/cubit/friends_item_cubit.dart';
import 'package:pooapp/pages/friends/cubit/friends_item_state.dart';
import 'package:pooapp/resources/resources.dart';
import 'package:pooapp/widgets/buttons/primary_action_button.dart';

class FriendItem extends StatefulWidget {
  const FriendItem({required this.user, super.key});

  final UserData user;

  @override
  State<FriendItem> createState() => _FriendItemState();
}

class _FriendItemState extends State<FriendItem> {
  late UserData _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    context.read<FriendsItemCubit>().initializeFriendsInfo(_user);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: ClipOval(
                        child: (_user.avatarUrl?.isEmpty ?? true)
                            ? Image.asset(AppIcons.appIcon, fit: BoxFit.cover)
                            : Image.network(
                                _user.avatarUrl ?? 'url-not-found',
                                fit: BoxFit.fill,
                                errorBuilder: (context, _, e) =>
                                    Image.asset(AppIcons.appIcon),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            BlocBuilder(
              bloc: context.read<FriendsItemCubit>(),
              builder: (context, state) {
                if (state is AddingFriend ||
                    state is AcceptingFriendRequest ||
                    state is DecliningFriendRequest) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                return _actionWidget();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionWidget() {
    final l10n = context.l10n;
    if (context.read<FriendsItemCubit>().isFriend) {
      return PrimaryActionButton(
        title: l10n.view_profile,
        textColor: Colors.white,
        backgroundColor: Colors.black,
        onPressed: () {},
      );
    }

    if (context.read<FriendsItemCubit>().isAwaiting) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(l10n.awaiting_for_accept),
      );
    }

    if (context.read<FriendsItemCubit>().hasRequested) {
      return Row(
        children: [
          PrimaryActionButton(
            title: l10n.accept,
            textColor: Colors.white,
            backgroundColor: Colors.green,
            onPressed: () =>
                context.read<FriendsItemCubit>().acceptFriendRequest(
                      _user,
                    ),
          ),
          const SizedBox(width: 8),
          PrimaryActionButton(
            title: l10n.decline,
            onPressed: () =>
                context.read<FriendsItemCubit>().decliningFriendRequest(
                      _user,
                    ),
          ),
        ],
      );
    }

    return PrimaryActionButton(
      title: l10n.add_friend,
      textColor: Colors.white,
      backgroundColor: const Color(0xFF452F2B),
      onPressed: () => context.read<FriendsItemCubit>().addFriend(_user),
    );
  }
}
