import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/committee.dart';
import '/tools/extensions.dart';
import '/ui/widgets/rounded_button.dart';
import './motion_dialog.dart';

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
      },
      {
        "type": "Unmoderated Caucus",
        "icon": Icons.workspaces,
        "widgets": ["duration"],
      },
      {
        "type": "Consultation",
        "icon": Icons.circle_outlined,
        "widgets": ["topic", "duration"],
        "topic": {"Topic": "Your Topic"},
      },
      {
        "type": "Adjourn Meeting",
        "icon": Icons.pause,
        "widgets": ["duration"],
      },
      {
        "type": "Change GSL Time",
        "icon": Icons.timelapse,
        "widgets": ["duration"],
      },
      {
        "type": "Prayer",
        "icon": Icons.church,
        "widgets": ["topic", "duration"],
        "topic": {"Cause": "Your Cause"},
      },
      {
        "type": "End Meeting",
        "icon": Icons.stop,
      },
      {
        "type": "Set Agenda",
        "icon": Icons.tune,
        "widgets": ["topic"],
        "topic": {"Agenda": Get.find<CommitteeController>().committee.agenda},
      },
      {
        "type": "Tour de Table",
        "icon": Icons.autorenew,
        "widgets": ["topic", "duration"],
        "topic": {"Topic": "Your Topic"},
      },
      {
        "type": "Appeal Chair's Decision",
        "icon": Icons.block,
        "widgets": ["topic"],
        "topic": {"Decision": "Your Decision"},
      },
      {
        "type": "Custom",
        "icon": Icons.edit,
        "widgets": ["topic", "duration"],
        "topic": {"Title": "Your Title"},
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
                style: context.textTheme.headlineSmall,
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
                        style: RoundedButtonStyle.border,
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => MotionDialog(
                            motion: {
                              "type": _motion["type"],
                              "topic": _motion["topic"] ?? <String, String>{},
                              "widgets": _motion["widgets"] ?? <String>[],
                              "time":
                                  _motion["time"] ?? DateTime.now().to12Hour,
                              "timestamp":
                                  _motion["timestamp"] ?? Timestamp.now(),
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
