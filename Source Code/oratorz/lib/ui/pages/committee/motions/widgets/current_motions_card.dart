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
      height: context.height / 2.95,
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
              Obx(() {
                if (_motionsController.currentMotion.isNotEmpty) {
                  return MotionTile(
                    motion: _motionsController.currentMotion,
                    reorderable: false,
                  );
                } else {
                  return Container(
                    margin: const EdgeInsets.only(top: 52, bottom: 12),
                    child: Text(
                      "No motions currently on the floor",
                      style: context.textTheme.bodyText1,
                    ),
                  );
                }
              }),
              const Divider(height: 16),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const _MultipleModeButton(
                    mode: 1,
                    color: Colors.amber,
                    icon: Icons.connect_without_contact,
                  ),
                  const _MultipleModeButton(
                    mode: 2,
                    color: Colors.lightBlue,
                    icon: Icons.how_to_vote,
                  ),
                  RoundedButton(
                    color: Colors.redAccent,
                    onPressed: () =>
                        _motionsController.nextMotion(passed: false),
                    child: const Icon(Icons.close),
                  ),
                  RoundedButton(
                    color: Colors.green,
                    onPressed: () {
                      _motionsController.nextMotion(passed: true);

                      // TODO: Motion Pass
                    },
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

class _MultipleModeButton extends StatelessWidget {
  final int mode;
  final Color color;
  final IconData icon;

  const _MultipleModeButton({
    required this.mode,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final MotionsController _motionsController = Get.find<MotionsController>();

    return Obx(() {
      if (_motionsController.mode != mode) {
        return RoundedButton(
          color: color,
          onPressed: () => _motionsController.mode = mode,
          child: Icon(icon),
        );
      } else {
        return RoundedButton(
          color: Colors.grey.shade800,
          onPressed: () => _motionsController.mode = 0,
          child: const Icon(Icons.add),
        );
      }
    });
  }
}
