import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoundedButton extends StatelessWidget {
  final Widget child;
  final bool border;
  final Function()? onPressed;
  final EdgeInsets? padding;
  final String? tooltip;
  final Color? color;

  const RoundedButton({
    super.key,
    required this.child,
    this.border = false,
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
              side: BorderSide(color: _color),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            border ? Colors.white : _color,
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            border ? _color : Colors.white,
          ),
          overlayColor: MaterialStateProperty.all<Color>(
            border ? _color.withAlpha(30) : Colors.white12,
          ),
        ),
        onPressed: onPressed,
        child: Container(
          margin: padding ?? const EdgeInsets.all(8),
          child: child,
        ),
      ),
    );
  }
}
