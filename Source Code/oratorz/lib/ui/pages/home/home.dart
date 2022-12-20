import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              "HOME PAGE",
              style: context.textTheme.headline5,
            ),
          ),
        ),
      );
}
