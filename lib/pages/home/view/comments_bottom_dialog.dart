import 'package:bepoo/l10n/l10n.dart';
import 'package:bepoo/pages/home/cubit/comments_cubit.dart';
import 'package:bepoo/pages/home/view/comment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommentsBottomDialog extends StatefulWidget {
  const CommentsBottomDialog({required this.poostId, super.key});

  final String poostId;

  @override
  State<CommentsBottomDialog> createState() => _CommentsBottomDialogState();
}

class _CommentsBottomDialogState extends State<CommentsBottomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _refreshController = RefreshController();
  final _commentTextController = TextEditingController();
  late String _poostId;
  bool _showSendBtn = false;

  @override
  void initState() {
    super.initState();
    _poostId = widget.poostId;
  }

  @override
  void dispose() {
    super.dispose();
    _commentTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder(
            bloc: context.read<CommentsCubit>(),
            builder: (context, state) {
              final comments = context.read<CommentsCubit>().commentsList;

              return Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: comments.length >= 10,
                  enablePullDown: false,
                  onLoading: () => context.read<CommentsCubit>().fetchNextPage(
                        poostId: _poostId,
                        refreshController: _refreshController,
                      ),
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) => CommentItem(
                      comment: comments[index],
                    ),
                  ),
                ),
              );
            },
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: _commentTextController,
                onChanged: (v) => setState(() => _showSendBtn = v.isNotEmpty),
                onSaved: (v) {
                  context
                      .read<CommentsCubit>()
                      .addComment(_poostId, v ?? '')
                      .whenComplete(() {
                    _commentTextController.clear();
                    setState(() => _showSendBtn = false);
                  });
                },
                style: GoogleFonts.inter(),
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintStyle: GoogleFonts.inter(),
                  hintText: l10n.comment_hint,
                  suffixIconConstraints: const BoxConstraints(
                    maxHeight: 42,
                  ),
                  suffixIcon: _showSendBtn
                      ? RawMaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _formKey.currentState!.save();
                            }
                          },
                          fillColor: const Color(0xFF452F2B),
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
