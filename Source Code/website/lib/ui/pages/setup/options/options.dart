import 'package:flutter/material.dart';

import 'widgets/date_card.dart';
import 'widgets/info_card.dart';
import 'widgets/members_card.dart';

class SetupOptionsPage extends StatelessWidget {
  const SetupOptionsPage({super.key});

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
                MembersCard(),
                SizedBox(height: 12),
                Expanded(child: DateCard()),
              ],
            ),
          ),
          SizedBox(width: 36),
          InfoCard(),
        ],
      ),
    );
  }
}
