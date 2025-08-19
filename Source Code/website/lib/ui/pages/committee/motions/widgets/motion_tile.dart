import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/data.dart';
import '/tools/extensions.dart';
import '/tools/functions.dart';
import '../../../../widgets/rounded_button.dart';
import 'motion_dialog.dart';

class MotionTile extends StatelessWidget {
  final Map<String, dynamic> motion;
  final bool current;

  const MotionTile({
    super.key,
    required this.motion,
    this.current = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.width / 3.3,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: flag(motion["delegate"] ?? ""),
            title: Row(
              children: [
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: motion["type"],
                      style: context.textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text:
                              "\n${DELEGATES[motion["delegate"].toString()] ?? "Delegate"}",
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            if (motion.containsKey("topic"))
                              TextSpan(
                                text: "\n${motion["topic"].keys.first}: ",
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: motion["topic"].values.first,
                                    style: context.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
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
                        seconds: (motion["overallDuration"] as String).toInt,
                      ),
                    ],
                    Center(
                      child: Text(
                        motion["time"],
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                if (current)
                  RoundedButton(
                    style: RoundedButtonStyle.border,
                    color: Colors.green.shade400,
                    padding: const EdgeInsets.all(4),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => MotionDialog(
                        motion: motion,
                        add: false,
                      ),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.green.shade400,
                    ),
                  ),
              ],
            ),
          ),
        ),
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
          style: context.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
