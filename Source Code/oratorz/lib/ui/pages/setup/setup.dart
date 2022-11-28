import 'package:flutter/material.dart';

import '/config/constants.dart';
import './widgets/committee_card.dart';
import './widgets/load_committee.dart';
import './widgets/new_committee.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Setup Committee",
              style: theme.textTheme.headline5,
            ),
            backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      LoadCommitteeCard(),
                      SizedBox(height: 12),
                      NewCommitteeCard(),
                      SizedBox(height: 36),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                const CommitteeCard(),
              ],
            ),
          ),
        ),
      );
}
