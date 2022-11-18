import 'package:flutter/material.dart';

class StopwatchButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function() onPressed;

  const StopwatchButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        overlayColor: MaterialStateProperty.all<Color>(Colors.white12),
        side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Icon(icon),
      ),
    );
  }
}
