import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BorderButton extends StatelessWidget {
  final String text;
  final bool filled;
  final Function() onPressed;
  final Color? color;
  final TextStyle? style;
  final IconData? icon;

  const BorderButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.filled = false,
    this.color,
    this.style,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Color _color = color ?? context.theme.colorScheme.secondary;

    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            side: BorderSide(color: _color),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          filled ? _color : Colors.white,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          filled ? Colors.white : _color,
        ),
        overlayColor: MaterialStateProperty.all<Color>(
          filled ? Colors.white12 : _color.withAlpha(30),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: (text.length).toDouble(),
          vertical: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon),
              const VerticalDivider(
                thickness: 0.5,
                color: Colors.black,
              ),
            ],
            Text(text, style: style ?? context.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
