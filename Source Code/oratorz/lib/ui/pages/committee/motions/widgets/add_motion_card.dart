import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/committee.dart';
import '/ui/widgets/rounded_button.dart';
import 'motion_dialog.dart';

class AddMotionCard extends StatelessWidget {
  const AddMotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> motions = [
      {
        "type": "Moderated Caucus",
        "icon": Icons.forum,
        "widgets": ["topic", "duration", "overallDuration"],
        "topic": {"Topic": "Your Topic"},
        "onPass": () {},
      },
      {
        "type": "Unmoderated Caucus",
        "icon": Icons.workspaces,
        "widgets": ["duration"],
        "onPass": () {},
      },
      {
        "type": "Consultation",
        "icon": Icons.circle_outlined,
        "widgets": ["topic", "duration"],
        "topic": {"Topic": "Your Topic"},
        "onPass": () {},
      },
      {
        "type": "Adjourn Meeting",
        "icon": Icons.pause,
        "widgets": ["duration"],
        "onPass": () {},
      },
      {
        "type": "Change GSL Time",
        "icon": Icons.timelapse,
        "widgets": ["duration"],
        "onPass": () {},
      },
      {
        "type": "Extend Caucus",
        "icon": Icons.more_time,
        "widgets": ["caucus", "duration"],
        "onPass": () {},
      },
      {
        "type": "Prayer",
        "icon": Icons.church,
        "widgets": ["topic", "duration"],
        "topic": {"Cause": "Your Cause"},
        "onPass": () {},
      },
      {
        "type": "Close Agenda",
        "icon": Icons.cancel_presentation,
        "onPass": () {},
      },
      {
        "type": "End Meeting",
        "icon": Icons.stop,
        "onPass": () {},
      },
      {
        "type": "Set Agenda",
        "icon": Icons.tune,
        "widgets": ["topic"],
        "topic": {"Agenda": Get.find<CommitteeController>().committee.agenda},
        "onPass": () {},
      },
      {
        "type": "Tour de Table",
        "icon": Icons.autorenew,
        "widgets": ["topic", "duration"],
        "topic": {"Topic": "Your Topic"},
        "onPass": () {},
      },
      {
        "type": "Appeal Chair's Decision",
        "icon": Icons.block,
        "widgets": ["topic"],
        "topic": {"Decision": "Your Decision"},
        "onPass": () {},
      },
      {
        "type": "Custom",
        "icon": Icons.edit,
        "widgets": ["topic", "duration"],
        "topic": {"Title": "Your Title"},
        "onPass": () {},
      },
    ];

    return Expanded(
      child: Card(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: context.height * 0.9,
          ),
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Motion",
                style: context.textTheme.headline5,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: motions.length,
                  itemBuilder: (_, index) {
                    final Map<String, dynamic> _motion = motions[index];

                    return Container(
                      margin: const EdgeInsets.all(8),
                      child: RoundedButton(
                        border: true,
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => MotionDialog(
                            motion: {
                              "type": _motion["type"],
                              "topic": _motion["topic"] ?? <String, String>{},
                              "widgets": _motion["widgets"] ?? <String>[],
                              "onPass": _motion["onPass"],
                              "time": DateTime.now(),
                            },
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_motion["icon"]),
                            const VerticalDivider(
                              thickness: 0.5,
                              color: Colors.black,
                            ),
                            Text(
                              _motion["type"],
                              style: context.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
