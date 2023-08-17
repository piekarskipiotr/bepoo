import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bepoo/l10n/l10n.dart';
import 'package:bepoo/pages/profile/bloc/profile_bloc.dart';
import 'package:bepoo/widgets/buttons/primary_button.dart';

class SelectedAvatarBottomSheetDialog extends StatelessWidget {
  const SelectedAvatarBottomSheetDialog({required this.image, super.key});

  final XFile image;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: Text(
                  l10n.selected_avatar_title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 192,
                height: 192,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipOval(
                    child: Image.file(
                      File(image.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          PrimaryButton(
            text: l10n.save,
            onPressed: () {
              context.read<ProfileBloc>().add(SaveAvatar(image));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
