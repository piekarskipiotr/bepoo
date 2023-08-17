import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bepoo/helpers/app_action_sheet_source.dart';
import 'package:bepoo/helpers/app_camera.dart';
import 'package:bepoo/pages/profile/bloc/profile_bloc.dart';
import 'package:bepoo/pages/profile/view/selected_avatar_bottom_sheet_dialog.dart';
import 'package:bepoo/resources/resources.dart';

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
                onPressed: () => AppActionSheetSource.show(
                  context: context,
                  onCameraPressed: () => AppCamera.takePicture(
                    context: context,
                    preferredCameraDevice: CameraDevice.front,
                  ).then((image) {
                    if (image != null) {
                      _showSelectedAvatarBottomDialog(context, image);
                    }
                  }),
                  onGalleryPressed: () => AppCamera.openGallery(
                    context: context,
                  ).then((image) {
                    if (image != null) {
                      _showSelectedAvatarBottomDialog(context, image);
                    }
                  }),
                ),
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

  void _showSelectedAvatarBottomDialog(BuildContext context, XFile image) {
    showModalBottomSheet<dynamic>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileBloc>(),
        child: SelectedAvatarBottomSheetDialog(image: image),
      ),
    );
  }
}
