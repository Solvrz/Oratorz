import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/services/local_storage.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/motions.dart';
import '/tools/controllers/comittee/speech.dart';
import '/tools/extensions.dart';
import '/tools/functions.dart';
import '/ui/pages/committee/motions/widgets/motion_tile.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';

class CurrentMotionCard extends StatelessWidget {
  const CurrentMotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final MotionsController _motionsController = Get.find<MotionsController>();

    return GetBuilder<MotionsController>(
      builder: (_) => SizedBox(
        height: context.height / 2.75,
        width: context.width / 3,
        child: Card(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Motion on Floor",
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Builder(
                  builder: (_) {
                    if (_motionsController.currentMotion.isNotEmpty) {
                      return MotionTile(
                        motion: _motionsController.currentMotion,
                        current: true,
                      );
                    } else {
                      return Container(
                        margin: const EdgeInsets.only(top: 52, bottom: 12),
                        child: Text(
                          "No motions currently on the floor",
                          style: context.textTheme.bodyLarge,
                        ),
                      );
                    }
                  },
                ),
                const Divider(height: 16),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const _MultipleModeButton(
                      mode: 1,
                      tooltip: "Debate Motion",
                      color: Colors.amber,
                      icon: Icons.connect_without_contact,
                    ),
                    _MultipleModeButton(
                      mode: 2,
                      tooltip: "Vote Motion",
                      color: context.theme.colorScheme.tertiary,
                      icon: Icons.how_to_vote,
                    ),
                    RoundedButton(
                      tooltip: "Fail Motion",
                      color: Colors.redAccent,
                      onPressed: () async {
                        if (_motionsController.currentMotion.isNotEmpty) {
                          _motionsController.nextMotion(passed: false);
                          _motionsController.update();
                        }
                      },
                      child: const Icon(Icons.close),
                    ),
                    RoundedButton(
                      color: Colors.green,
                      tooltip: "Pass Motion",
                      onPressed: () {
                        if (_motionsController.currentMotion.isNotEmpty) {
                          return showDialog(
                            context: context,
                            builder: (context) => const _PassMotionDialog(),
                          );
                        }
                      },
                      child: const Icon(Icons.check),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PassMotionDialog extends StatelessWidget {
  const _PassMotionDialog();

  @override
  Widget build(BuildContext context) {
    final MotionsController _motionsController = Get.find<MotionsController>();

    return Obx(
      () => DialogBox(
        heading: "Activate ${_motionsController.currentMotion["type"]}",
        content: const Text("Do you want to activate this motion now?"),
        actions: [
          RoundedButton(
            style: RoundedButtonStyle.border,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            onPressed: () {
              _motionsController.nextMotion(passed: true);
              _motionsController.update();

              context.pop();
            },
            child: const Text("No"),
          ),
          const SizedBox(width: 5),
          RoundedButton(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            onPressed: () {
              _onPass(context, _motionsController.currentMotion);

              _motionsController.nextMotion(passed: true);
              _motionsController.update();

              context.pop();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}

class _MultipleModeButton extends StatelessWidget {
  final int mode;
  final String tooltip;
  final Color color;
  final IconData icon;

  const _MultipleModeButton({
    required this.mode,
    required this.tooltip,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final MotionsController _motionsController = Get.find<MotionsController>();

    return Obx(() {
      if (_motionsController.mode != mode) {
        return RoundedButton(
          color: color,
          tooltip: tooltip,
          onPressed: () {
            _motionsController.mode = mode;
            _motionsController.update();

            LocalStorage.updateMotions("mode", mode);
          },
          child: Icon(icon),
        );
      } else {
        return RoundedButton(
          color: Colors.grey.shade800,
          tooltip: "Add Motion",
          onPressed: () {
            _motionsController.mode = 0;
            _motionsController.update();
          },
          child: const Icon(Icons.add),
        );
      }
    });
  }
}

void _onPass(BuildContext context, Map<String, dynamic> motion) {
  final Map<String, Function> functions = {
    "Moderated Caucus": () {
      if (Get.isRegistered<SpeechController>(tag: "mod")) {
        Get.delete<SpeechController>(tag: "mod");
      }

      final SpeechController _speechController =
          Get.put(SpeechController("mod"), tag: "mod");

      _speechController.subtopic = motion["topic"] as Map<String, String>;
      _speechController.overallDuration = Duration(
        seconds: (motion["overallDuration"] as String).toInt,
      );
      _speechController.duration = Duration(
        seconds: (motion["duration"] as String).toInt,
      );

      LocalStorage.saveSpeech(_speechController);

      Get.find<CommitteeController>().tab = 0;
      context.go("/mod?id=${Get.find<CommitteeController>().committee.id}");
    },
    "Unmoderated Caucus": () {
      if (Get.isRegistered<SpeechController>(tag: "unmod")) {
        Get.delete<SpeechController>(tag: "unmod");
      }

      final SpeechController _speechController =
          Get.put(SpeechController("unmod"), tag: "unmod");

      _speechController.duration = Duration(
        seconds: (motion["duration"] as String).toInt,
      );

      Get.find<CommitteeController>().tab = 0;
      context.go("/unmod?id=${Get.find<CommitteeController>().committee.id}");
    },
    "Consultation": () {
      if (Get.isRegistered<SpeechController>(tag: "consultation")) {
        Get.delete<SpeechController>(tag: "consultation");
      }

      final SpeechController _speechController =
          Get.put(SpeechController("consultation"), tag: "consultation");

      _speechController.subtopic = motion["topic"] as Map<String, String>;
      _speechController.duration = Duration(
        seconds: (motion["duration"] as String).toInt,
      );

      Get.find<CommitteeController>().tab = 0;
      context.go(
        "/consultation?id=${Get.find<CommitteeController>().committee.id}",
      );
    },
    "Adjourn Meeting": () {
      if (Get.isRegistered<SpeechController>(tag: "adjourn")) {
        Get.delete<SpeechController>(tag: "adjourn");
      }

      final SpeechController _speechController =
          Get.put(SpeechController("adjourn"), tag: "adjourn");

      _speechController.duration = Duration(
        seconds: (motion["duration"] as String).toInt,
      );

      Get.find<CommitteeController>().tab = 0;
      context.go(
        "/adjournment?id=${Get.find<CommitteeController>().committee.id}",
      );
    },
    "Change GSL Time": () {
      late final SpeechController _speechController;

      if (Get.isRegistered<SpeechController>(tag: "gsl")) {
        _speechController = Get.find<SpeechController>(tag: "gsl");
      } else {
        _speechController =
            Get.put<SpeechController>(SpeechController("gsl"), tag: "gsl");
      }

      _speechController.duration = Duration(
        seconds: (motion["duration"] as String).toInt,
      );

      LocalStorage.saveSpeech(_speechController);

      Get.find<CommitteeController>().tab = 0;
      context.go("/gsl?id=${Get.find<CommitteeController>().committee.id}");
    },
    "Prayer": () {
      if (Get.isRegistered<SpeechController>(tag: "prayer")) {
        Get.delete<SpeechController>(tag: "prayer");
      }

      final SpeechController _speechController =
          Get.put(SpeechController("prayer"), tag: "prayer");

      _speechController.subtopic = motion["topic"] as Map<String, String>;
      _speechController.duration = Duration(
        seconds: (motion["duration"] as String).toInt,
      );

      Get.find<CommitteeController>().tab = 0;
      context.go("/prayer?id=${Get.find<CommitteeController>().committee.id}");
    },
    "End Meeting": () => context.pushReplacement("/"),
    "Set Agenda": () {
      final CommitteeController _committeeController =
          Get.find<CommitteeController>();

      _committeeController.setAgenda(
        (motion["topic"] as Map<String, String>).values.first,
      );

      snackbar(
        context,
        const Center(
          child: Text("Agenda Changed"),
        ),
      );
    },
    "Tour de Table": () {
      if (Get.isRegistered<SpeechController>(tag: "tourdetable")) {
        Get.delete<SpeechController>(tag: "tourdetable");
      }

      final SpeechController _speechController =
          Get.put(SpeechController("tourdetable"), tag: "tourdetable");

      _speechController.subtopic = motion["topic"] as Map<String, String>;
      _speechController.duration = Duration(
        seconds: (motion["duration"] as String).toInt,
      );

      Get.find<CommitteeController>().tab = 0;
      context.go(
        "/tourdetable?id=${Get.find<CommitteeController>().committee.id}",
      );
    },
    "Appeal Chair's Decision": () {
      snackbar(
        context,
        const Center(
          child: Text("Decision Appealed"),
        ),
      );
    },
    "Custom": () {
      if (Get.isRegistered<SpeechController>(tag: "custom")) {
        Get.delete<SpeechController>(tag: "custom");
      }

      final SpeechController _speechController =
          Get.put(SpeechController("custom"), tag: "custom");

      _speechController.subtopic = motion["topic"] as Map<String, String>;
      _speechController.duration = Duration(
        seconds: (motion["duration"] as String).toInt,
      );

      Get.find<CommitteeController>().tab = 0;
      context.go("/custom?id=${Get.find<CommitteeController>().committee.id}");
    },
  };

  functions[motion["type"]]!();
}
