import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/widgets/rounded_button.dart';

class AddMotionsCard extends StatelessWidget {
  const AddMotionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> motions = [
      {
        "name": "Moderated Caucus",
        "icon": Icons.forum,
        "onTap": () {},
      },
      {
        "name": "Unmoderated Caucus",
        "icon": Icons.workspaces,
        "onTap": () {},
      },
      {
        "name": "Consultation",
        "icon": Icons.circle_outlined,
        "onTap": () {},
      },
      {
        "name": "Adjourn Meeting",
        "icon": Icons.pause,
        "onTap": () {},
      },
      {
        "name": "Change GSL Time",
        "icon": Icons.timelapse,
        "onTap": () {},
      },
      {
        "name": "Extend Caucus",
        "icon": Icons.more_time,
        "onTap": () {},
      },
      {
        "name": "Prayer",
        "icon": Icons.church,
        "onTap": () {},
      },
      {
        "name": "Close Agenda",
        "icon": Icons.cancel_presentation,
        "onTap": () {}
      },
      {
        "name": "End Meeting",
        "icon": Icons.stop,
        "onTap": () {},
      },
      {
        "name": "Set Agenda",
        "icon": Icons.tune,
        "onTap": () {},
      },
      {
        "name": "Tour de Table",
        "icon": Icons.autorenew,
        "onTap": () {},
      },
      {
        "name": "Appeal Chair's Decision",
        "icon": Icons.block,
        "onTap": () {},
      },
      {
        "name": "Custom",
        "icon": Icons.edit,
        "onTap": () {},
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
                "Add Motions",
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
                        onPressed: _motion["onTap"],
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
                              _motion["name"],
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
