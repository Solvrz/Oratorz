import 'package:flutter/material.dart';

import 'widgets/committee_card.dart';
import 'widgets/load_committee.dart';
import 'widgets/new_committee.dart';

class SetupDelegatesPage extends StatelessWidget {
  const SetupDelegatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                LoadCommitteeCard(),
                SizedBox(height: 12),
                Expanded(child: NewCommitteeCard()),
              ],
            ),
          ),
          SizedBox(width: 36),
          CommitteeCard(),
        ],
      ),
    );
  }
}
