import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants.dart';
import '/tools/controllers/setup.dart';
import './widgets/committee_card.dart';
import './widgets/load_committee.dart';
import './widgets/new_committee.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  // TODO: Go Named Not Working

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
}
