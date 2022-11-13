import 'package:flutter/material.dart';

import '/config/constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding * 2),
        Row(
          children: const [
            Spacer(),
            // TODO: Fix
            // Expanded(
            //   flex: 8,
            //   child: SvgPicture.asset("assets/icons/login.svg"),
            // ),
            Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
