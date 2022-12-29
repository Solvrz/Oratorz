import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/tools/extensions.dart';
import '/tools/functions.dart';

class MotionTile extends StatelessWidget {
  final Map<String, dynamic> motion;

  const MotionTile({super.key, required this.motion});

  @override
  Widget build(BuildContext context) {
    // TODO: Edit Button, Remove Button & Time Pushed
    return Container(
      width: context.width / 3,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          "${motion["type"]}, ${DELEGATES[motion["delegate"]]!}",
          style: context.textTheme.headline6,
        ),
        leading: flag(motion["delegate"]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (motion.containsKey("topic"))
              Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: RichText(
                  text: TextSpan(
                    text:
                        "${(motion["topic"] as Map<String, String>).keys.first}: ",
                    style: context.textTheme.bodyText1
                        ?.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: (motion["topic"] as Map<String, String>)
                            .values
                            .first,
                        style: context.textTheme.bodyText2,
                      )
                    ],
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (motion.containsKey("duration")) ...[
                  const Icon(
                    Icons.timelapse,
                    size: 25,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    Duration(seconds: motion["duration"]).time,
                    style: context.textTheme.bodyText1,
                  ),
                ],
                if (motion.containsKey("overallDuration")) ...[
                  const SizedBox(width: 45),
                  const Icon(
                    Icons.person,
                    size: 25,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    Duration(seconds: motion["overallDuration"]).time,
                    style: context.textTheme.bodyText1,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
