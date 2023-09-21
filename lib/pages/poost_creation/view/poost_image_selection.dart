import 'dart:io';

import 'package:bepoo/helpers/app_camera.dart';
import 'package:bepoo/l10n/l10n.dart';
import 'package:bepoo/pages/poost_creation/bloc/poost_creation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class PoostImageSelection extends StatefulWidget {
  const PoostImageSelection({super.key});

  @override
  State<PoostImageSelection> createState() => _PoostImageSelectionState();
}

class _PoostImageSelectionState extends State<PoostImageSelection> {
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: MediaQuery.of(context).size.shortestSide,
      height: MediaQuery.of(context).size.shortestSide,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        color: Color(0xFF211F1F),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => AppCamera.takePicture(context: context).then((image) {
            if (image != null) {
              setState(() {
                _image = image;
                context.read<PoostCreationBloc>().image = image;
              });
            }
          }),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: _image != null
              ? ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  child: Image.file(
                    File(_image!.path),
                    fit: BoxFit.cover,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.photo_camera_rounded,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.take_picture,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
