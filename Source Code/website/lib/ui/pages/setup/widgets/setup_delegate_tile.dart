import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/data.dart';
import '/tools/functions.dart';

class SetupDelegateTile extends StatefulWidget {
  final String delegate;
  final Function()? onTap;
  final Widget? trailing;
  final Widget? onHover;
  final bool isExpanded;

  const SetupDelegateTile({
    super.key,
    required this.delegate,
    this.onTap,
    this.trailing,
    this.onHover,
    this.isExpanded = false,
  });

  @override
  State<SetupDelegateTile> createState() => _SetupDelegateTileState();
}

class _SetupDelegateTileState extends State<SetupDelegateTile> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: ListTile(
        onTap: widget.onTap,
        leading: flag(widget.delegate),
        subtitle: widget.isExpanded
            ? const Row(
                children: [
                  Text("Delegate E-mail:"),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        title: Text(
          DELEGATES[widget.delegate]!,
          style: context.textTheme.bodyLarge,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.trailing != null) widget.trailing!,
            if (widget.trailing != null && widget.onHover != null)
              const SizedBox(width: 8),
            if (hovering && widget.onHover != null) widget.onHover!,
          ],
        ),
      ),
    );
  }
}
