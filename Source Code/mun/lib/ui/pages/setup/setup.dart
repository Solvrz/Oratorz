import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/setup_committee.dart';
import './widgets/committee_card.dart';
import './widgets/load_committee.dart';
import './widgets/new_committee.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final SetupCommitteeController committee =
      Get.put(SetupCommitteeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Setup Committee",
            style: TextStyle(color: Colors.black),
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
