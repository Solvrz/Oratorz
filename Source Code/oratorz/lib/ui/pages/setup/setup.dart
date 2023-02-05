import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/setup.dart';
import './widgets/committee_card.dart';
import './widgets/load_committee.dart';
import './widgets/new_committee.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<SetupController>(SetupController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Setup Committee",
            style:
                context.textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: const [
                    LoadCommitteeCard(),
                    SizedBox(height: 12),
                    Expanded(child: NewCommitteeCard()),
                  ],
                ),
              ),
              const SizedBox(width: 36),
              const CommitteeCard(),
            ],
          ),
        ),
      ),
    );
  }
}
