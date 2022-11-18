import 'package:flutter/material.dart';

class UnmodPage extends StatelessWidget {
  const UnmodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Unmod PAGE",
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
