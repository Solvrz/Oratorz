import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/config/constants/constants.dart';
import '/config/data.dart';

class DelegateTile extends StatelessWidget {
  final String delegate;
  final Function()? onTap;
  final Widget? trailing;
  final EdgeInsets? contentPadding;

  const DelegateTile({
    super.key,
    required this.delegate,
    this.onTap,
    this.trailing,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: contentPadding,
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
          child: SvgPicture.asset("flags/$delegate.svg"),
        ),
        // TODO: Change to Delegates
        title: Text(
          COUNTRIES[delegate]!,
          style: theme.textTheme.bodyText1,
        ),
        trailing: trailing,
      );
}
