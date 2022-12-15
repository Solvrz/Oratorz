import 'package:flutter/material.dart';

import '/config/constants/constants.dart';
import '/ui/widgets/border_button.dart';
import '/ui/widgets/filled_button.dart';

class MotionsPage extends StatelessWidget {
  const MotionsPage({super.key});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Card(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Motion on Floor",
                            style: theme.textTheme.headline5,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "No motions currently on the floor",
                            style: theme.textTheme.bodyText1,
                          ),
                          const Divider(height: 16),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FilledButton(
                                color: Colors.amber,
                                onPressed: () {},
                                child:
                                    const Icon(Icons.connect_without_contact),
                              ),
                              FilledButton(
                                color: Colors.lightBlue,
                                onPressed: () {},
                                child: const Icon(Icons.how_to_vote),
                              ),
                              FilledButton(
                                color: Colors.redAccent,
                                onPressed: () {},
                                child: const Icon(Icons.close),
                              ),
                              FilledButton(
                                color: Colors.green,
                                onPressed: () {},
                                child: const Icon(Icons.check),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Future Motions",
                            style: theme.textTheme.headline5,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "No future motions added",
                            style: theme.textTheme.bodyText1,
                          ),
                          const Divider(height: 16),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const AddMotionsCard(),
          ],
        ),
      );
}

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
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Motions",
                style: theme.textTheme.headline5,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    motions.length,
                    (index) {
                      final Map<String, dynamic> _motion = motions[index];

                      return BorderButton(
                        text: _motion["name"],
                        icon: _motion["icon"],
                        color: Colors.amber.shade400,
                        onPressed: _motion["onTap"],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
