import 'package:bepoo/data/models/poost.dart';
import 'package:bepoo/data/models/user_data.dart';
import 'package:bepoo/di/get_it.dart';
import 'package:bepoo/helpers/date_helper.dart';
import 'package:bepoo/l10n/l10n.dart';
import 'package:bepoo/pages/home/cubit/comments_cubit.dart';
import 'package:bepoo/pages/home/view/comments_bottom_dialog.dart';
import 'package:bepoo/pages/home/view/poop_type_info.dart';
import 'package:bepoo/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PoostItem extends StatefulWidget {
  const PoostItem({required this.poost, super.key});

  final Poost poost;

  @override
  State<PoostItem> createState() => _PoostItemState();
}

class _PoostItemState extends State<PoostItem> {
  late Poost _poost;
  late UserData _user;

  @override
  void initState() {
    super.initState();
    _poost = widget.poost;
    _user = _poost.userData!;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: const BoxDecoration(
          color: Color(0xFF181717),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          children: [
            _imageWidget(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: ClipOval(
                                child: (_user.avatarUrl?.isEmpty ?? true)
                                    ? Image.asset(
                                        AppIcons.appIcon,
                                        fit: BoxFit.cover,
                                      )
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
                          Text(
                            _user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Container(),
                    ],
                  ),
                  if (_poost.description?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 16),
                    Text(
                      _poost.description!,
                      style: GoogleFonts.inter(),
                    ),
                  ],
                  Text(
                    DateHelper.getDayMonthYearDateText(_poost.createdAt),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_poost.newestComment?.isNotEmpty ?? false) ...[
                    InkWell(
                      onTap: () => showModalBottomSheet<dynamic>(
                        context: context,
                        showDragHandle: true,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        builder: (context) => BlocProvider(
                          create: (_) => getIt<CommentsCubit>()
                            ..fetchComments(
                              poostId: _poost.id,
                            ),
                          child: CommentsBottomDialog(poostId: _poost.id),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.comments,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Opacity(
                                  opacity: 0.8,
                                  child: Text(
                                    '${_poost.newestCommentUserName ?? 'User'}: ',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  _poost.newestComment ?? '',
                                  style: GoogleFonts.inter(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    InkWell(
                      onTap: () => showModalBottomSheet<dynamic>(
                        context: context,
                        showDragHandle: true,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        builder: (context) => BlocProvider(
                          create: (_) => getIt<CommentsCubit>()
                            ..fetchComments(
                              poostId: _poost.id,
                            ),
                          child: CommentsBottomDialog(poostId: _poost.id),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          l10n.add_comment,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageWidget() {
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
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                _poost.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, _, e) => Center(
                  child: Text(
                    l10n.cannot_load_the_image,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              _overlay(),
              PoopTypeInfo(poopType: _poost.poopType),
            ],
          ),
        ),
      ),
    );
  }

  Widget _overlay() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(.7),
              Colors.transparent,
            ],
          ),
        ),
      );
}
