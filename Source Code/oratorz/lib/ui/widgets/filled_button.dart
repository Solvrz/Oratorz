import 'package:flutter/material.dart';

class FilledButton extends StatelessWidget {
  final Color color;
  final Widget child;
  final Function() onPressed;
  final EdgeInsets? padding;

  const FilledButton({
    super.key,
    required this.child,
    required this.color,
    required this.onPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) => TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          overlayColor: MaterialStateProperty.all<Color>(Colors.white12),
          side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
        ),
        onPressed: onPressed,
        child: Container(
          margin: padding ?? const EdgeInsets.symmetric(horizontal: 8),
          child: child,
        ),
      );
}
