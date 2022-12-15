import 'package:flutter/material.dart';

import '/config/constants/constants.dart';

class BorderButton extends StatelessWidget {
  final String text;
  final Color color;
  final bool filled;
  final Function() onPressed;
  final TextStyle? style;
  final IconData? icon;

  const BorderButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.filled = false,
    this.style,
    this.icon,
  });

  @override
  Widget build(BuildContext context) => TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              side: BorderSide(color: color),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            filled ? color : Colors.white,
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            filled ? Colors.white : color,
          ),
          overlayColor: MaterialStateProperty.all<Color>(
            filled ? Colors.white12 : color.withAlpha(30),
          ),
        ),
        onPressed: onPressed,
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: (text.length).toDouble(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon),
                const VerticalDivider(
                  thickness: 0.5,
                  color: Colors.black,
                ),
              ],
              Text(text, style: style ?? theme.textTheme.bodyLarge),
            ],
          ),
        ),
      );
}
