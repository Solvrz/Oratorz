import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/motions.dart';
import '/ui/widgets/rounded_button.dart';
import './motion_tile.dart';

class CurrentMotionCard extends StatelessWidget {
  const CurrentMotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final MotionsController _motionsController = Get.find<MotionsController>();

    return SizedBox(
      height: context.height / 3.35,
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
              _motionsController.currentMotion.isNotEmpty
                  ? MotionTile(motion: _motionsController.currentMotion)
                  : Text(
                      "No motions currently on the floor",
                      style: context.textTheme.bodyText1,
                    ),
              const Divider(height: 16),
              const SizedBox(height: 20),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _motionsController.mode != 1
                        ? RoundedButton(
                            color: Colors.amber,
                            onPressed: () {
                              _motionsController.mode = 1;
                            },
                            child: const Icon(Icons.connect_without_contact),
                          )
                        : RoundedButton(
                            color: Colors.grey.shade800,
                            onPressed: () {
                              _motionsController.mode = 0;
                            },
                            child: const Icon(Icons.add),
                          ),
                    _motionsController.mode != 2
                        ? RoundedButton(
                            color: Colors.lightBlue,
                            onPressed: () {
                              _motionsController.mode = 2;
                            },
                            child: const Icon(Icons.how_to_vote),
                          )
                        : RoundedButton(
                            color: Colors.grey.shade800,
                            onPressed: () {
                              _motionsController.mode = 0;
                            },
                            child: const Icon(Icons.add),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
