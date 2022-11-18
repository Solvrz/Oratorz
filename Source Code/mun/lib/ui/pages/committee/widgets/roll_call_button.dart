import 'package:flutter/material.dart';

class RollCallButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function() onPressed;
  final bool selected;
  final EdgeInsets? padding;

  const RollCallButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.selected = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            side: BorderSide(color: color),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          selected ? color : Colors.white,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          selected ? Colors.white : color,
        ),
        overlayColor: MaterialStateProperty.all<Color>(
          selected ? Colors.white12 : color.withAlpha(30),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Text(text),
      ),
    );
  }
}
