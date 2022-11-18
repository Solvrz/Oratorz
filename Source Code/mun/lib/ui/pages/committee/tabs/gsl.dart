import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/committee.dart';
import '/controllers/gsl.dart';
import '/ui/widgets/country_tile.dart';
import '../widgets/stopwatch.dart';

class GSLPage extends StatefulWidget {
  const GSLPage({super.key});

  @override
  State<GSLPage> createState() => _GSLPageState();
}

class _GSLPageState extends State<GSLPage> {
  final CommitteeController controller = Get.find<CommitteeController>();
  final GSLController gslController = Get.put(GSLController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: "Agenda:",
              style: Theme.of(context).textTheme.headline5,
              children: [
                TextSpan(
                  text:
                      " Deliberation upon Human Rights Violation due to Russia-Ukraine War",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2.5,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StopwatchWidget(onTimeEnd: () {}),
                              const SizedBox(width: 48),
                              Expanded(
                                child: SpeakersInfoWidget(
                                  gslController: gslController,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Card(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2.5,
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Past Speakers",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                const SizedBox(height: 8),
                                Obx(
                                  () => gslController.pastSpeakers.isEmpty
                                      ? Text(
                                          "No past speakers have been recorded",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        )
                                      : Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: List.generate(
                                                gslController.pastSpeakers
                                                            .length *
                                                        2 -
                                                    1,
                                                (index) {
                                                  if (index % 2 == 1) {
                                                    return Divider(
                                                      height: 6,
                                                      color:
                                                          Colors.grey.shade400,
                                                    );
                                                  }

                                                  final Map<String, Duration>
                                                      speaker = gslController
                                                              .pastSpeakers[
                                                          index ~/ 2];
                                                  final int inMinutes = speaker
                                                      .values.first.inMinutes;
                                                  final int inSeconds = speaker
                                                      .values.first.inSeconds;

                                                  return CountryTile(
                                                    country: speaker.keys.first,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    trailing: Text(
                                                      "$inMinutes:${(inSeconds - inMinutes * 60).toString().padLeft(2, '0')}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 36),
                Expanded(
                  child: AddSpeakerCard(
                    controller: controller,
                    gslController: gslController,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpeakersInfoWidget extends StatelessWidget {
  const SpeakersInfoWidget({
    Key? key,
    required this.gslController,
  }) : super(key: key);

  final GSLController gslController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Current Speaker",
              style: Theme.of(context).textTheme.headline5,
            ),
            TextButton(
              onPressed: gslController.nextSpeaker,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue.shade400),
                side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(color: Colors.blue.shade400),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                overlayColor: MaterialStateProperty.all<Color>(Colors.white12),
              ),
              child: const Text("Next"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(
          () => gslController.currentSpeaker.value != ""
              ? CountryTile(
                  country: gslController.currentSpeaker.value,
                  contentPadding: EdgeInsets.zero,
                )
              : Text(
                  "No speaker currently added",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
        ),
        const Divider(height: 16),
        const SizedBox(height: 16),
        Text(
          "Upcoming Speakers",
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(height: 8),
        Obx(
          () => gslController.nextSpeakers.isNotEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        gslController.nextSpeakers.length * 2 - 1,
                        (index) => index % 2 == 0
                            ? CountryTile(
                                country: gslController.nextSpeakers[index ~/ 2],
                                contentPadding: EdgeInsets.zero,
                                trailing: InkWell(
                                  onTap: () => gslController.removeSpeaker(
                                    gslController.nextSpeakers[index ~/ 2],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red.shade400,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              )
                            : Divider(
                                height: 6,
                                color: Colors.grey.shade400,
                              ),
                      ),
                    ),
                  ),
                )
              : Text(
                  "No upcoming speakers",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 2),
      ],
    );
  }
}

class AddSpeakerCard extends StatelessWidget {
  const AddSpeakerCard({
    Key? key,
    required this.controller,
    required this.gslController,
  }) : super(key: key);

  final CommitteeController controller;
  final GSLController gslController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Speaker",
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 8),
            Obx(
              () {
                final List<String> speakers =
                    controller.committee.value.countries
                        .where(
                          (element) => controller.rollCall[element]! > 0,
                        )
                        .toList();

                return speakers.isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              speakers.length * 2 - 1,
                              (index) {
                                final bool isAdded =
                                    gslController.isAdded(speakers[index ~/ 2]);

                                return index % 2 == 0
                                    ? Opacity(
                                        opacity: isAdded ? 0.6 : 1,
                                        child: CountryTile(
                                          country: speakers[index ~/ 2],
                                          onTap: isAdded
                                              ? null
                                              : () => gslController.addSpeaker(
                                                    speakers[index ~/ 2],
                                                  ),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      )
                                    : Divider(
                                        height: 6,
                                        color: Colors.grey.shade400,
                                      );
                              },
                            ),
                          ),
                        ),
                      )
                    : Text(
                        "Conduct a roll call before adding speakers",
                        style: Theme.of(context).textTheme.bodyText1,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
