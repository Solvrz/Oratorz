import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function() onPressed;
  final bool filled;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.filled = false,
    this.padding,
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
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Text(text),
        ),
      );
}
