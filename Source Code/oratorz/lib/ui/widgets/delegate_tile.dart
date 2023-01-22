import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/tools/functions.dart';

class DelegateTile extends StatefulWidget {
  final String delegate;
  final Function()? onTap;
  final List<Widget> trailing;
  final bool hover;

  const DelegateTile({
    super.key,
    required this.delegate,
    this.onTap,
    this.trailing = const [],
    this.hover = true,
  });

  @override
  State<DelegateTile> createState() => _DelegateTileState();
}

class _DelegateTileState extends State<DelegateTile> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      hoverColor: Colors.transparent,
      onHover: (val) {
        setState(() => hovering = val);
      },
      child: ListTile(
        onTap: widget.onTap,
        leading: flag(widget.delegate),
        title: Text(
          DELEGATES[widget.delegate]!,
          style: context.textTheme.bodyText1,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hovering || !widget.hover) ...widget.trailing,
          ],
        ),
      ),
    );
  }
}
