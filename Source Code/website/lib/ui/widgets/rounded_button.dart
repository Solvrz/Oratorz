import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum RoundedButtonStyle { fill, border, empty }

class RoundedButton extends StatelessWidget {
  final Widget child;
  final RoundedButtonStyle style;
  final Function()? onPressed;
  final EdgeInsets? padding;
  final String? tooltip;
  final Color? color;

  const RoundedButton({
    super.key,
    required this.child,
    this.style = RoundedButtonStyle.fill,
    this.onPressed,
    this.padding,
    this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color _color = color ?? context.theme.colorScheme.secondary;

    return Tooltip(
      message: tooltip ?? "",
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: style == RoundedButtonStyle.empty
                  ? BorderSide.none
                  : BorderSide(color: _color),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            style == RoundedButtonStyle.border ? Colors.white : _color,
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            style == RoundedButtonStyle.border ? _color : Colors.white,
          ),
          overlayColor: MaterialStateProperty.all<Color>(
            style == RoundedButtonStyle.border
                ? _color.withAlpha(30)
                : Colors.white12,
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(8),
          child: child,
        ),
      ),
    );
  }
}
