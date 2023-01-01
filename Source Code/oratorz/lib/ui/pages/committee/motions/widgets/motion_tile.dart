import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/tools/controllers/comittee/motions.dart';
import '/tools/extensions.dart';
import '/tools/functions.dart';
import '/ui/widgets/rounded_button.dart';
import './motion_dialog.dart';

class MotionTile extends StatelessWidget {
  final Map<String, dynamic> motion;
  final bool reorderable;

  const MotionTile({
    super.key,
    required this.motion,
    this.reorderable = true,
  });

  @override
  Widget build(BuildContext context) {
    final MotionsController _motionsController = Get.find<MotionsController>();

    return Row(
      children: [
        Container(
          width: context.width / (reorderable ? 3.5 : 3.3),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              SizedBox(
                width: context.width / (reorderable ? 4.2 : 4),
                child: ListTile(
                  leading: flag(motion["delegate"] ?? ""),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: motion["type"],
                          style: context.textTheme.caption,
                          children: [
                            TextSpan(
                              text:
                                  "\n${DELEGATES[motion["delegate"]] ?? "Delegate"}",
                              style: context.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                if (motion.containsKey("topic"))
                                  TextSpan(
                                    text:
                                        "\n${(motion["topic"] as Map<String, String>).keys.first}: ",
                                    style: context.textTheme.bodyText1
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: (motion["topic"]
                                                as Map<String, String>)
                                            .values
                                            .first,
                                        style: context.textTheme.bodyText2,
                                      )
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          if (motion.containsKey("duration")) ...[
                            _Duration(
                              icon: Icons.timelapse,
                              seconds: (motion["duration"] as String).toInt,
                            ),
                          ],
                          if (motion.containsKey("overallDuration")) ...[
                            const SizedBox(height: 5),
                            _Duration(
                              icon: Icons.person,
                              seconds:
                                  (motion["overallDuration"] as String).toInt,
                            ),
                          ],
                        ],
                      ),
                      Text((motion["time"] as DateTime).to12Hour)
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    RoundedButton(
                      border: true,
                      color: Colors.red.shade400,
                      padding: const EdgeInsets.all(4),
                      onPressed: () {
                        _motionsController.nextMotion(
                          passed: false,
                          add: false,
                        );
                        _motionsController.update();
                      },
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    RoundedButton(
                      border: true,
                      color: Colors.green.shade400,
                      padding: const EdgeInsets.all(4),
                      onPressed: () {
                        // TODO: Update Current motion
                        showDialog(
                          context: context,
                          builder: (context) => MotionDialog(motion: motion),
                        );
                      },
                      child: Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.green.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (reorderable) ...[
          const SizedBox(width: 8),
          Icon(
            Icons.drag_handle,
            color: Colors.grey.shade600,
          ),
        ]
      ],
    );
  }
}

class _Duration extends StatelessWidget {
  final IconData icon;
  final int seconds;

  const _Duration({
    required this.icon,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 25,
          color: Colors.grey.shade700,
        ),
        const SizedBox(width: 5),
        Text(
          Duration(seconds: seconds).time,
          style: context.textTheme.bodyText1,
        ),
      ],
    );
  }
}
