import 'package:flutter/material.dart' hide Table;
import 'package:get/get.dart';

import '/services/local_storage.dart';
import '/tools/controllers/comittee/scorecard.dart';
import './widgets/header.dart';
import './widgets/table.dart';
import '../widgets/body.dart';

class ScorecardPage extends StatelessWidget {
  const ScorecardPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ScorecardController>()) {
      final bool exists = LocalStorage.loadScore();

      if (!exists) {
        final ScorecardController _scorecardController = ScorecardController();

        Get.put<ScorecardController>(_scorecardController);
        LocalStorage.saveScore(_scorecardController);
      }
    }

    return Body(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Header(),
          SizedBox(height: 24),
          Table(),
        ],
      ),
    );
  }
}
