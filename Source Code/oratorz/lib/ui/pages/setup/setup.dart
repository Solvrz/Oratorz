import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/constants.dart';
import '/tools/controllers/setup.dart';
import './widgets/committee_card.dart';
import './widgets/load_committee.dart';
import './widgets/new_committee.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SetupController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Setup Committee",
            style: theme.textTheme.headline5,
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
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
}
