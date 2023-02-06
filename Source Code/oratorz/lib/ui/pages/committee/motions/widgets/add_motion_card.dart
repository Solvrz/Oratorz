import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/models/router.dart';
import '/services/local_storage.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/speech.dart';
import '/tools/extensions.dart';
import '/ui/widgets/rounded_button.dart';
import './motion_dialog.dart';

class AddMotionCard extends StatelessWidget {
  const AddMotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> motions = [
      {
        "type": "Moderated Caucus",
        "icon": Icons.forum,
        "widgets": ["topic", "duration", "overallDuration"],
        "topic": {"Topic": "Your Topic"},
        "onPass": (motion) {
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

          final int tab = AppRouter.tabs.indexWhere(
            (route) => route.path.contains("/id/modes/mod"),
          );
          Get.find<CommitteeController>().tab = tab;

          // TODO: Push
          // context.pushReplacement("/committee/mod");
        },
      },
      {
        "type": "Unmoderated Caucus",
        "icon": Icons.workspaces,
        "widgets": ["duration"],
        "onPass": (motion) {
          if (Get.isRegistered<SpeechController>(tag: "unmod")) {
            Get.delete<SpeechController>(tag: "unmod");
          }

          final SpeechController _speechController =
              Get.put(SpeechController("unmod"), tag: "unmod");

          _speechController.duration = Duration(
            seconds: (motion["duration"] as String).toInt,
          );

          // TODO: Push
          // context.pushReplacement("/committee/mod");
        },
      },
      {
        "type": "Consultation",
        "icon": Icons.circle_outlined,
        "widgets": ["topic", "duration"],
        "topic": {"Topic": "Your Topic"},
        "onPass": (motion) {
          if (Get.isRegistered<SpeechController>(tag: "consultation")) {
            Get.delete<SpeechController>(tag: "consultation");
          }

          final SpeechController _speechController =
              Get.put(SpeechController("consultation"), tag: "consultation");

          _speechController.subtopic = motion["topic"] as Map<String, String>;
          _speechController.duration = Duration(
            seconds: (motion["duration"] as String).toInt,
          );

          // TODO: Push
          // context.pushReplacement("/committee/mod");
        },
      },
      {
        "type": "Adjourn Meeting",
        "icon": Icons.pause,
        "widgets": ["duration"],
        "onPass": (motion) {
          if (Get.isRegistered<SpeechController>(tag: "adjourn")) {
            Get.delete<SpeechController>(tag: "adjourn");
          }

          final SpeechController _speechController =
              Get.put(SpeechController("adjourn"), tag: "adjourn");

          _speechController.duration = Duration(
            seconds: (motion["duration"] as String).toInt,
          );

          // TODO: Push
          // context.pushReplacement("/committee/mod");
        },
      },
      {
        "type": "Change GSL Time",
        "icon": Icons.timelapse,
        "widgets": ["duration"],
        "onPass": (motion) {
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
        }

        // TODO: Push
        // context.pushReplacement("/committee/mod");
      },
      // TODO: Extend Caucus
      // {
      //   "type": "Extend Caucus",
      //   "icon": Icons.more_time,
      //   "widgets": ["caucus", "duration"],
      //   "onPass": (motion) {},
      // },
      {
        "type": "Prayer",
        "icon": Icons.church,
        "widgets": ["topic", "duration"],
        "topic": {"Cause": "Your Cause"},
        "onPass": (motion) {
          if (Get.isRegistered<SpeechController>(tag: "prayer")) {
            Get.delete<SpeechController>(tag: "prayer");
          }

          final SpeechController _speechController =
              Get.put(SpeechController("prayer"), tag: "prayer");

          _speechController.subtopic = motion["topic"] as Map<String, String>;
          _speechController.duration = Duration(
            seconds: (motion["duration"] as String).toInt,
          );

          // TODO: Push
          // context.pushReplacement("/committee/mod");
        },
      },

      {
        "type": "End Meeting",
        "icon": Icons.stop,
        "onPass": (motion) {
          // TODO: Sure Dialog

          LocalStorage.clearData();
          context.pushReplacement("/setup");
        },
      },
      {
        "type": "Set Agenda",
        "icon": Icons.tune,
        "widgets": ["topic"],
        "topic": {"Agenda": Get.find<CommitteeController>().committee.agenda},
        "onPass": (motion) {
          final CommitteeController _committeeController =
              Get.find<CommitteeController>();

          _committeeController.setAgenda(
            (motion["topic"] as Map<String, String>).values.first,
          );

          // TODO: Snackbar
        },
      },
      {
        "type": "Tour de Table",
        "icon": Icons.autorenew,
        "widgets": ["topic", "duration"],
        "topic": {"Topic": "Your Topic"},
        "onPass": (motion) {
          if (Get.isRegistered<SpeechController>(tag: "tourdetable")) {
            Get.delete<SpeechController>(tag: "tourdetable");
          }

          final SpeechController _speechController =
              Get.put(SpeechController("tourdetable"), tag: "tourdetable");

          _speechController.subtopic = motion["topic"] as Map<String, String>;
          _speechController.duration = Duration(
            seconds: (motion["duration"] as String).toInt,
          );

          // TODO: Push
          // context.pushReplacement("/committee/mod");
        },
      },
      {
        "type": "Appeal Chair's Decision",
        "icon": Icons.block,
        "widgets": ["topic"],
        "topic": {"Decision": "Your Decision"},
        "onPass": (motion) {
          // TODO: Disscuss Here
          // TODO: Snackbar
        },
      },
      {
        "type": "Custom",
        "icon": Icons.edit,
        "widgets": ["topic", "duration"],
        "topic": {"Title": "Your Title"},
        "onPass": (motion) {
          if (Get.isRegistered<SpeechController>(tag: "custom")) {
            Get.delete<SpeechController>(tag: "custom");
          }

          final SpeechController _speechController =
              Get.put(SpeechController("custom"), tag: "custom");

          _speechController.subtopic = motion["topic"] as Map<String, String>;
          _speechController.duration = Duration(
            seconds: (motion["duration"] as String).toInt,
          );

          // TODO: Push
          // context.pushReplacement("/committee/mod");
        },
      },
    ];

    return Expanded(
      child: Card(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: context.height * 0.9,
          ),
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Motion",
                style: context.textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: motions.length,
                  itemBuilder: (_, index) {
                    final Map<String, dynamic> _motion = motions[index];

                    return Container(
                      margin: const EdgeInsets.all(8),
                      child: RoundedButton(
                        style: RoundedButtonStyle.border,
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => MotionDialog(
                            motion: {
                              "type": _motion["type"],
                              "topic": _motion["topic"] ?? <String, String>{},
                              "widgets": _motion["widgets"] ?? <String>[],
                              "onPass": _motion["onPass"],
                              "time":
                                  _motion["time"] ?? DateTime.now().to12Hour,
                            },
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_motion["icon"]),
                            const VerticalDivider(
                              thickness: 0.5,
                              color: Colors.black,
                            ),
                            Text(
                              _motion["type"],
                              style: context.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
