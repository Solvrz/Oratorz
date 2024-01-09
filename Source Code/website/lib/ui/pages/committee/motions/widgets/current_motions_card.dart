import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import './motion_tile.dart';
import '/services/local_storage.dart';
import '/tools/controllers/comittee/motions.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';

class CurrentMotionCard extends StatelessWidget {
  const CurrentMotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final MotionsController _motionsController = Get.find<MotionsController>();

    return GetBuilder<MotionsController>(
      builder: (_) => SizedBox(
        height: context.height / 2.85,
        width: context.width / 3,
        child: Card(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Motion on Floor",
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Builder(
                  builder: (_) {
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
                          style: context.textTheme.bodyLarge,
                        ),
                      );
                    }
                  },
                ),
                const Divider(height: 16),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const _MultipleModeButton(
                      mode: 1,
                      tooltip: "Debate Motion",
                      color: Colors.amber,
                      icon: Icons.connect_without_contact,
                    ),
                    const _MultipleModeButton(
                      mode: 2,
                      tooltip: "Vote Motion",
                      color: Colors.lightBlue,
                      icon: Icons.how_to_vote,
                    ),
                    RoundedButton(
                      tooltip: "Fail Motion",
                      color: Colors.redAccent,
                      onPressed: () async {
                        if (_motionsController.currentMotion.isNotEmpty) {
                          _motionsController.nextMotion(passed: false);
                          _motionsController.update();
                        }
                      },
                      child: const Icon(Icons.close),
                    ),
                    RoundedButton(
                      color: Colors.green,
                      tooltip: "Pass Motion",
                      onPressed: () {
                        if (_motionsController.currentMotion.isNotEmpty) {
                          return showDialog(
                            context: context,
                            builder: (context) => const _PassMotionDialog(),
                          );
                        }
                      },
                      child: const Icon(Icons.check),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PassMotionDialog extends StatelessWidget {
  const _PassMotionDialog();

  @override
  Widget build(BuildContext context) {
    final MotionsController _motionsController = Get.find<MotionsController>();

    return Obx(
      () => DialogBox(
        heading: "Activate ${_motionsController.currentMotion["type"]}",
        content: const Text(
          "Do you want to activate this motion now?\nAfter Activation go to the respective page!",
        ),
        actions: [
          RoundedButton(
            style: RoundedButtonStyle.border,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            onPressed: () {
              _motionsController.nextMotion(passed: true);
              _motionsController.update();

              context.pop();
            },
            child: const Text("No"),
          ),
          const SizedBox(width: 5),
          RoundedButton(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            onPressed: () {
              _motionsController
                  .currentMotion["onPass"](_motionsController.currentMotion);

              _motionsController.nextMotion(passed: true);
              _motionsController.update();

              context.pop();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}

class _MultipleModeButton extends StatelessWidget {
  final int mode;
  final String tooltip;
  final Color color;
  final IconData icon;

  const _MultipleModeButton({
    required this.mode,
    required this.tooltip,
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
          tooltip: tooltip,
          onPressed: () {
            _motionsController.mode = mode;
            _motionsController.update();

            LocalStorage.updateMotions("mode", mode);
          },
          child: Icon(icon),
        );
      } else {
        return RoundedButton(
          color: Colors.grey.shade800,
          tooltip: "Add Motion",
          onPressed: () {
            _motionsController.mode = 0;
            _motionsController.update();
          },
          child: const Icon(Icons.add),
        );
      }
    });
  }
}
