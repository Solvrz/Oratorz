import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/filled_button.dart';
import './settings_dialog.dart';
import './yield_spaeaker_dialog.dart';

class StopwatchWidget extends StatefulWidget {
  final String tag;
  final Function()? onTimeEnd;
  final bool canYield;

  const StopwatchWidget({
    super.key,
    required this.tag,
    this.canYield = false,
    this.onTimeEnd,
  });

  @override
  State<StopwatchWidget> createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  late Timer timer;
  late final SpeechController _speechController;

  Duration timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();

    _speechController = Get.find<SpeechController>(tag: widget.tag);
    setupTimer();

    timeLeft = _speechController.duration.value;
  }

  void setupTimer() => timer = Timer.periodic(
        const Duration(milliseconds: 500),
        (_) {
          setState(() {
            timeLeft = _speechController.duration.value -
                _speechController.stopwatch.value.elapsed;

            if (timeLeft.inMilliseconds < 0) {
              (widget.onTimeEnd ?? () {})();

              _speechController.stopwatch.value.stop();
              _speechController.overallStopwatch.value.stop();

              timeLeft = Duration.zero;
              timer.cancel();
            }
          });
        },
      );

  @override
  void dispose() {
    timer.cancel();
    _speechController.stopwatch.value.stop();
    _speechController.overallStopwatch.value.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Duration? overallTimeLeft;

    if (_speechController.overallDuration != null) {
      overallTimeLeft = _speechController.overallDuration!.value -
          _speechController.overallStopwatch.value.elapsed;
    }

    return SizedBox(
      height: context.height / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_speechController.subtopic.keys.first != "") ...[
            RichText(
              text: TextSpan(
                text: "${_speechController.subtopic.keys.first}: ",
                style: context.textTheme.headline2,
                children: [
                  TextSpan(
                    text: _speechController.subtopic.values.first,
                    style: context.textTheme.headline5!
                        .copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          Expanded(
            child: Row(
              children: [
                CircularPercentIndicator(
                  radius: 100,
                  percent: (timeLeft.inSeconds /
                          _speechController.duration.value.inSeconds) *
                      0.975,
                  progressColor:
                      context.theme.colorScheme.secondary.withAlpha(200),
                  backgroundColor:
                      context.theme.colorScheme.secondary.withAlpha(135),
                  circularStrokeCap: CircularStrokeCap.round,
                  lineWidth: 16,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (overallTimeLeft != null)
                        Text(
                          "${overallTimeLeft.inMinutes}:${(overallTimeLeft.inSeconds - overallTimeLeft.inMinutes * 60).toString().padLeft(2, "0")}",
                          style: context.textTheme.headline5!
                              .copyWith(fontSize: 20),
                        ),
                      Text(
                        "${timeLeft.inMinutes}:${(timeLeft.inSeconds - timeLeft.inMinutes * 60).toString().padLeft(2, "0")}",
                        style:
                            context.textTheme.headline5!.copyWith(fontSize: 32),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      onPressed: () {
                        if (_speechController.isSpeaking.value ||
                            timeLeft.inSeconds == 0) {
                          _speechController.stopwatch.value.stop();
                          _speechController.overallStopwatch.value.stop();
                        } else {
                          _speechController.stopwatch.value.start();
                          _speechController.overallStopwatch.value.start();
                        }

                        _speechController.isSpeaking.value =
                            !_speechController.isSpeaking.value;
                      },
                      color: Colors.blueGrey.shade600,
                      child: Icon(
                        _speechController.isSpeaking.value
                            ? Icons.stop
                            : Icons.play_arrow,
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        if (_speechController
                                .stopwatch.value.elapsed.inSeconds ==
                            0) {
                          //TODO: Confirmation Dialog
                          _speechController.overallStopwatch.value.reset();
                          return;
                        }

                        _speechController.stopwatch.value.reset();
                        timer.cancel();

                        setupTimer();
                      },
                      color: Colors.blue.shade400,
                      child: const Icon(Icons.restart_alt),
                    ),
                    FilledButton(
                      onPressed: () async {
                        _speechController.stopwatch.value.stop();
                        _speechController.overallStopwatch.value.stop();

                        _speechController.stopwatch.value.reset();

                        await showDialog(
                          context: context,
                          builder: (_) =>
                              SettingsDialog(controller: _speechController),
                        );
                      },
                      color: Colors.amber.shade400,
                      child: const Icon(Icons.settings),
                    ),
                    if (widget.canYield)
                      FilledButton(
                        onPressed: () {
                          final CommitteeController _committeeController =
                              Get.find<CommitteeController>();
                          final List<String> delegates = _committeeController
                              .committee.value.presentDelegates;

                          if (_speechController.currentSpeaker.value != "") {
                            delegates.remove(
                              _speechController.currentSpeaker.value,
                            );
                          }

                          return showDialog(
                            context: context,
                            builder: (_) => YieldSpeakerDialog(
                              delegates: delegates,
                              controller: _speechController,
                            ),
                          );
                        },
                        color: Colors.grey.shade800,
                        child: const Icon(Icons.person),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
