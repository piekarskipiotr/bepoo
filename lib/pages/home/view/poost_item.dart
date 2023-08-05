import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pooapp/data/enums/poop_type.dart';
import 'package:pooapp/data/models/poost.dart';
import 'package:pooapp/data/models/user_data.dart';
import 'package:pooapp/l10n/l10n.dart';
import 'package:pooapp/resources/resources.dart';
import 'package:pooapp/widgets/buttons/outlined_action_button.dart';

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
            Container(
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
                      Container(
                        padding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          right: 72,
                        ),
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedActionButton(
                              onPressed: () {},
                              title:
                                  '${_poost.poopType.emoji} ${_poost.poopType.getName(context)}',
                              textColor: Colors.white,
                              borderColor: Colors.white,
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                _poost.poopType.getDescription(context),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
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
                                    ? Image.asset(AppIcons.appIcon,
                                        fit: BoxFit.cover)
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
                  const SizedBox(height: 16),
                  if (_poost.description?.isNotEmpty ?? false) ...[
                    Text(
                      _poost.description!,
                      style: GoogleFonts.inter(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
