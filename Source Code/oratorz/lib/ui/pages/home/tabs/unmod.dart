import 'package:flutter/material.dart';

import '../widgets/stopwatch.dart';

class UnmodTab extends StatelessWidget {
  const UnmodTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Container(
          height: MediaQuery.of(context).size.height / 2.5,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 18,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StopwatchWidget(onTimeEnd: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
