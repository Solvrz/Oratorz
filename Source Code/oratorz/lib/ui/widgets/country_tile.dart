import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/config/data.dart';

class CountryTile extends StatelessWidget {
  final String country;
  final Function()? onTap;
  final Widget? trailing;
  final EdgeInsets? contentPadding;

  const CountryTile({
    super.key,
    required this.country,
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
          child: SvgPicture.asset("flags/$country.svg"),
        ),
        title: Text(
          COUNTRIES[country]!,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        trailing: trailing,
      );
}
