import 'package:flutter/material.dart';

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
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Motion on Floor",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "No motions currently on the floor",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const Divider(height: 16),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FilledButton(
                                icon: Icons.connect_without_contact,
                                color: const Color(0xFFFBAD30),
                                onPressed: () {},
                              ),
                              FilledButton(
                                icon: Icons.how_to_vote,
                                color: const Color(0xFF3BA7C5),
                                onPressed: () {},
                              ),
                              FilledButton(
                                icon: Icons.close,
                                color: const Color(0xFFE34F62),
                                onPressed: () {},
                              ),
                              FilledButton(
                                icon: Icons.check,
                                color: const Color(0xFF53BD6B),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Future Motions",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "No future motions added",
                            style: Theme.of(context).textTheme.bodyText1,
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
            AddMotionsCard(),
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
        "name": "Consulation",
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
        "name": "Suspend Meeting",
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Motions",
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(
                        motions.length ~/ 2,
                        (index) {
                          final Map<String, dynamic> _motion = motions[index];

                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: BorderButton(
                              text: _motion["name"],
                              icon: _motion["icon"],
                              color: Colors.amber.shade400,
                              onPressed: _motion["onTap"],
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: (_motion["name"].toString().length)
                                    .toDouble(),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(
                        motions.length ~/ 2,
                        (index) {
                          final Map<String, dynamic> _motion =
                              motions[index + motions.length ~/ 2];

                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: BorderButton(
                              text: _motion["name"],
                              icon: _motion["icon"],
                              color: Colors.amber.shade400,
                              onPressed: _motion["onTap"],
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: (_motion["name"].toString().length)
                                    .toDouble(),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
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
