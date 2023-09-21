import 'package:bepoo/data/models/comment.dart';
import 'package:bepoo/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({required this.comment, super.key});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ClipOval(
            child: (comment.userData?.avatarUrl?.isEmpty ?? true)
                ? Image.asset(
                    AppIcons.appIcon,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    comment.userData?.avatarUrl ?? 'url-not-found',
                    fit: BoxFit.fill,
                    errorBuilder: (context, _, e) =>
                        Image.asset(AppIcons.appIcon),
                  ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: 0.8,
            child: Text(
              comment.userData?.name ?? 'User',
              style: GoogleFonts.inter(fontSize: 12, height: 0),
            ),
          ),
          Text(
            comment.content,
            style: GoogleFonts.inter(fontSize: 14, height: 0),
          ),
          const SizedBox(height: 4),
          Opacity(
            opacity: 0.8,
            child: Text(
              DateFormat('dd.MM.yyyy hh:mm').format(comment.createdAt),
              style: GoogleFonts.inter(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
