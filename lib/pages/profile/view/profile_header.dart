import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pooapp/resources/resources.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.user, super.key});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ClipOval(
                  child: (user?.photoURL?.isEmpty ?? true)
                      ? Image.asset(AppIcons.appIcon, fit: BoxFit.cover)
                      : Image.network(
                          user?.photoURL ?? 'url-not-found',
                          fit: BoxFit.fill,
                          errorBuilder: (context, _, e) =>
                              Image.asset(AppIcons.appIcon),
                        ),
                ),
              ),
            ),
            SizedBox(
              width: 32,
              height: 32,
              child: RawMaterialButton(
                onPressed: () {
                  // TODO: implement changing user avatar
                },
                fillColor: Colors.black,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user?.displayName ?? 'User',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
