import 'package:flutter/material.dart' hide TabController;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            "HOME PAGE",
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ),
    );
  }
}
