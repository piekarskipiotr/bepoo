import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pooapp/data/models/user_data.dart';
import 'package:pooapp/l10n/l10n.dart';
import 'package:pooapp/resources/resources.dart';
import 'package:pooapp/widgets/buttons/primary_action_button.dart';

class FriendItem extends StatelessWidget {
  const FriendItem({required this.user, super.key});

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                        child: (user.avatarUrl?.isEmpty ?? true)
                            ? Image.asset(AppIcons.appIcon, fit: BoxFit.cover)
                            : Image.network(
                                user.avatarUrl ?? 'url-not-found',
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
                      user.name,
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
            PrimaryActionButton(
              title: l10n.add_friend,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
