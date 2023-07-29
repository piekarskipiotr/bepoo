import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pooapp/data/enums/sign_in_method.dart';
import 'package:pooapp/l10n/l10n.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    required this.signInMethod,
    required this.onPressed,
    super.key,
  });

  final SignInMethod signInMethod;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              backgroundColor: MaterialStateProperty.all(
                signInMethod.btnBgColor,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              SvgPicture.asset(
                signInMethod.logo,
                width: 32,
                height: 32,
                colorFilter: signInMethod.logoColorFilter,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                l10n.sign_in_with(signInMethod.name),
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: signInMethod.btnTxtColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
