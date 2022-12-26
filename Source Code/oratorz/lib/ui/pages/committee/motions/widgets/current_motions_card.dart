import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/widgets/rounded_button.dart';

class CurrentMotionCard extends StatelessWidget {
  const CurrentMotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height / 4,
      width: context.width / 3,
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Motion on Floor",
                style: context.textTheme.headline5,
              ),
              const SizedBox(height: 8),
              Text(
                "No motions currently on the floor",
                style: context.textTheme.bodyText1,
              ),
              const Divider(height: 16),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundedButton(
                    color: Colors.amber,
                    onPressed: () {},
                    child: const Icon(Icons.connect_without_contact),
                  ),
                  RoundedButton(
                    color: Colors.lightBlue,
                    onPressed: () {},
                    child: const Icon(Icons.how_to_vote),
                  ),
                  RoundedButton(
                    color: Colors.redAccent,
                    onPressed: () {},
                    child: const Icon(Icons.close),
                  ),
                  RoundedButton(
                    color: Colors.green,
                    onPressed: () {},
                    child: const Icon(Icons.check),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
