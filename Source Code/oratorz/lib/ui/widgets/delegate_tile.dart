import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/tools/functions.dart';

class DelegateTile extends StatelessWidget {
  final String delegate;
  final Function()? onTap;
  final Widget? trailing;

  const DelegateTile({
    super.key,
    required this.delegate,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      hoverColor: Colors.grey[100],
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(1, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: flag(delegate),
      ),
      title: Text(
        DELEGATES[delegate]!,
        style: context.textTheme.bodyText1,
      ),
      trailing: trailing,
    );
  }
}
