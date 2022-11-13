import 'package:flutter/material.dart';

import '/config/colors.dart';

class OrDivider extends StatefulWidget {
  const OrDivider({super.key});

  @override
  State<OrDivider> createState() => _OrDividerState();
}

class _OrDividerState extends State<OrDivider> {
  late final Size size;

  @override
  void initState() {
    size = MediaQuery.of(context).size;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: MUNColors.PrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }
}
