import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    required this.title,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  final String title;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return _CustomChoiceChip(
      label: Text(
        title,
        style: GoogleFonts.inter(),
      ),
      selected: isSelected,
      onSelected: onSelected,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
    );
  }
}

class _CustomChoiceChip extends StatelessWidget
    implements
        ChipAttributes,
        SelectableChipAttributes,
        DisabledChipAttributes {
  const _CustomChoiceChip({
    required this.label,
    required this.selected,
    super.key,
    this.avatar,
    this.labelStyle,
    this.labelPadding,
    this.onSelected,
    this.pressElevation,
    this.selectedColor,
    this.disabledColor,
    this.tooltip,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.backgroundColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.selectedShadowColor,
    this.avatarBorder = const CircleBorder(),
  })  : assert(
          pressElevation == null || pressElevation >= 0.0,
          'pressElevation == null || pressElevation >= 0.0',
        ),
        assert(
          elevation == null || elevation >= 0.0,
          'elevation == null || elevation >= 0.0',
        );

  @override
  final Widget? avatar;
  @override
  final Widget label;
  @override
  final TextStyle? labelStyle;
  @override
  final EdgeInsetsGeometry? labelPadding;
  @override
  final ValueChanged<bool>? onSelected;
  @override
  final double? pressElevation;
  @override
  final bool selected;
  @override
  final Color? disabledColor;
  @override
  final Color? selectedColor;
  @override
  final String? tooltip;
  @override
  final BorderSide? side;
  @override
  final OutlinedBorder? shape;
  @override
  final Clip clipBehavior;
  @override
  final FocusNode? focusNode;
  @override
  final bool autofocus;
  @override
  final Color? backgroundColor;
  @override
  final EdgeInsetsGeometry? padding;
  @override
  final VisualDensity? visualDensity;
  @override
  final MaterialTapTargetSize? materialTapTargetSize;
  @override
  final double? elevation;
  @override
  final Color? shadowColor;
  @override
  final Color? surfaceTintColor;
  @override
  final Color? selectedShadowColor;
  @override
  final ShapeBorder avatarBorder;
  @override
  final IconThemeData? iconTheme;

  @override
  bool get isEnabled => onSelected != null;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context), 'debugCheckHasMaterial');
    final chipTheme = ChipTheme.of(context);
    final ChipThemeData? defaults = Theme.of(context).useMaterial3
        ? _ChoiceChipDefaultsM3(
            context: context,
            isEnabled: isEnabled,
            isSelected: selected,
          )
        : null;
    return RawChip(
      defaultProperties: defaults,
      avatar: avatar,
      label: label,
      labelStyle:
          labelStyle ?? (selected ? chipTheme.secondaryLabelStyle : null),
      labelPadding: labelPadding,
      onSelected: onSelected,
      pressElevation: pressElevation,
      selected: selected,
      showCheckmark: false,
      tooltip: tooltip,
      side: side,
      shape: shape,
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      autofocus: autofocus,
      disabledColor: disabledColor,
      selectedColor: selectedColor ?? chipTheme.secondarySelectedColor,
      backgroundColor: backgroundColor,
      padding: padding,
      visualDensity: visualDensity,
      isEnabled: isEnabled,
      materialTapTargetSize: materialTapTargetSize,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      selectedShadowColor: selectedShadowColor,
      avatarBorder: avatarBorder,
      iconTheme: iconTheme,
    );
  }
}

class _ChoiceChipDefaultsM3 extends ChipThemeData {
  _ChoiceChipDefaultsM3({
    required this.context,
    required this.isEnabled,
    required this.isSelected,
  }) : super(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          showCheckmark: false,
        );

  final BuildContext context;
  final bool isEnabled;
  final bool isSelected;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  TextStyle? get labelStyle => _textTheme.labelLarge;

  @override
  Color? get backgroundColor => null;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get surfaceTintColor => _colors.surfaceTint;

  @override
  Color? get selectedColor => isEnabled
      ? _colors.secondaryContainer
      : _colors.onSurface.withOpacity(0.12);

  @override
  Color? get checkmarkColor => _colors.onSecondaryContainer;

  @override
  Color? get disabledColor =>
      isSelected ? _colors.onSurface.withOpacity(0.12) : null;

  @override
  Color? get deleteIconColor => _colors.onSecondaryContainer;

  @override
  BorderSide? get side => !isSelected
      ? isEnabled
          ? BorderSide(color: _colors.outline)
          : BorderSide(color: _colors.onSurface.withOpacity(0.12))
      : const BorderSide(color: Colors.transparent);

  @override
  IconThemeData? get iconTheme => IconThemeData(
        color: isEnabled ? null : _colors.onSurface,
        size: 18,
      );

  @override
  EdgeInsetsGeometry? get padding => const EdgeInsets.all(8);

  @override
  EdgeInsetsGeometry? get labelPadding => EdgeInsets.lerp(
        const EdgeInsets.symmetric(horizontal: 8),
        const EdgeInsets.symmetric(horizontal: 4),
        clampDouble(MediaQuery.textScaleFactorOf(context) - 1.0, 0, 1),
      )!;
}
