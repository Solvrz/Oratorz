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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: "Back",
            hoverColor: Colors.white12,
          ),
          title: Text(
            "Setup Committee",
            style: context.textTheme.headline5?.copyWith(color: Colors.white),
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
