import 'package:flutter/material.dart';

class TabTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;
  final bool selected;

  const TabTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        horizontalTitleGap: 8,
        onTap: onTap,
        hoverColor: selected ? Colors.transparent : Colors.white12,
        tileColor: selected ? const Color(0xff2a313b) : const Color(0xff0d1520),
        leading: Icon(icon, color: Colors.white, size: 24),
        title: Text(title, style: Theme.of(context).textTheme.bodyText2),
      ),
    );
  }
}
