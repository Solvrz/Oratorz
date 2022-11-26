import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants.dart';
import '/tools/controllers/setup.dart';
import './widgets/committee_card.dart';
import './widgets/load_committee.dart';
import './widgets/new_committee.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late final SetupController committee;

  @override
  void initState() {
    super.initState();
    committee = Get.put(SetupController());
  }

  @override
  Widget build(BuildContext context) {
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
                    Expanded(child: NewCommitteeCard()),
                    SizedBox(height: 36),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              const Expanded(child: CommitteeCard()),
            ],
          ),
        ),
      ),
    );
  }
}
