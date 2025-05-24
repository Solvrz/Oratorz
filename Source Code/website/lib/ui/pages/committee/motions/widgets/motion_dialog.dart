import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/tools/controllers/comittee/motions.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';
import './buttons/duration.dart';
import './buttons/submitted_by.dart';
import './buttons/topic.dart';

class MotionDialog extends StatelessWidget {
  final Map<String, dynamic> motion;
  final bool add;

  const MotionDialog({
    super.key,
    required this.motion,
    this.add = true,
  });

  @override
  Widget build(BuildContext context) {
    final MotionsController _motionsController = Get.find<MotionsController>();

    return DialogBox(
      heading: motion["type"],
      content: SizedBox(
        height: context.height / 2,
        width: context.width / 3.5,
        child: ListView(
          children: [
            if (motion["widgets"].contains("topic")) ...[
              TopicButton(
                topic: motion["topic"],
                onChanged: (value) =>
                    motion["topic"][motion["topic"]?.keys.first] = value,
              ),
              const SizedBox(height: 20),
            ],
            if (motion["widgets"].contains("duration")) ...[
              DurationButton(
                title: "Speaker Time",
                duration: motion["duration"],
                onChanged: (duration) => motion["duration"] = duration,
              ),
              const SizedBox(height: 20),
            ],
            if (motion["widgets"].contains("overallDuration")) ...[
              DurationButton(
                title: "Caucus Time",
                duration: motion["overallDuration"],
                onChanged: (duration) => motion["overallDuration"] = duration,
              ),
              const SizedBox(height: 20),
            ],
            SubmittedByButton(
              delegate: motion["delegate"],
              onChanged: (delegate) => motion["delegate"] = delegate,
            ),
          ],
        ),
      ),
      actions: [
        RoundedButton(
          style: RoundedButtonStyle.border,
          color: Colors.amber.shade400,
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          onPressed: () {
            if (add) {
              _motionsController.addMotion(
                motion
                  ..removeWhere((key, value) {
                    try {
                      return value.isEmpty;
                    } catch (_) {
                      return false;
                    }
                  }),
              );
            }

            _motionsController.update();
            context.pop();
          },
          child: Text(add ? "Add" : "Update"),
        ),
      ],
    );
  }
}
