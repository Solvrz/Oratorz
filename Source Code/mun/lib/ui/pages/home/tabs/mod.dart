import 'package:flutter/material.dart';

class ModTab extends StatelessWidget {
  const ModTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Mod PAGE",
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
