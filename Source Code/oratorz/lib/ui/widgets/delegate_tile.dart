import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/tools/functions.dart';

class DelegateTile extends StatefulWidget {
  final String delegate;
  final Function()? onTap;
  final Widget? trailing;
  final Widget? onHover;

  const DelegateTile({
    super.key,
    required this.delegate,
    this.onTap,
    this.trailing,
    this.onHover,
  });

  @override
  State<DelegateTile> createState() => _DelegateTileState();
}

class _DelegateTileState extends State<DelegateTile> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: ListTile(
        onTap: widget.onTap,
        leading: flag(widget.delegate),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        title: Text(
          DELEGATES[widget.delegate]!,
          style: context.textTheme.bodyText1,
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
