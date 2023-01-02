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
      onTap: onTap,
      leading: flag(delegate),
      title: Text(
        DELEGATES[delegate]!,
        style: context.textTheme.bodyText1,
      ),
      trailing: trailing,
    );
  }
}
