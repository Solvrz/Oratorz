import 'package:flutter/material.dart' hide TabController;

import '/config/constants/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            "HOME PAGE",
            style: theme.textTheme.headline5,
          ),
        ),
      ),
    );
  }
}
