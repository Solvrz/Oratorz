import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/speech.dart';
import '/tools/extensions.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';
import './dialogs/speech_settings.dart';
import './dialogs/yield_spaeaker.dart';

class Hourglass extends StatefulWidget {
  final String tag;
  final bool canYield;

  final double? height;
  final double? radius;

  const Hourglass({
    super.key,
    required this.tag,
    this.canYield = false,
    this.height,
    this.radius,
  });

  @override
  State<Hourglass> createState() => _HourglassState();
}

class _HourglassState extends State<Hourglass> {
  late Timer timer;
  late final SpeechController _speechController;

  Duration timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();

    _speechController = Get.find<SpeechController>(tag: widget.tag);
    timeLeft = _speechController.duration;
    setupTimer();
  }

  void setupTimer() =>
      timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
        if (mounted) {
          setState(() {
            timeLeft = _speechController.duration -
                _speechController.stopwatch.elapsed;

            if (timeLeft.inMilliseconds < 0) {
              _speechController.stopwatch.stop();
              _speechController.overallStopwatch.stop();

              timeLeft = Duration.zero;
              timer.cancel();
            }
          });
        }
      });

  @override
  Widget build(BuildContext context) {
    Duration? overallTimeLeft;

    if (_speechController.hasOverallDuration) {
      overallTimeLeft = _speechController.overallDuration -
          _speechController.overallStopwatch.elapsed;
    }

    return SizedBox(
      height: widget.height ?? context.height / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_speechController.hasSubtopic) ...[
            RichText(
              text: TextSpan(
                text: "${_speechController.subtopic.keys.first}: ",
                style: context.textTheme.displayMedium,
                children: [
                  TextSpan(
                    text: _speechController.subtopic.values.first,
                    style: context.textTheme.headlineSmall!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          Expanded(
            child: Row(
              children: [
                CircularPercentIndicator(
                  radius: widget.radius ?? 100,
                  percent: (timeLeft.inSeconds /
                          _speechController.duration.inSeconds) *
                      0.975,
                  progressColor: context.theme.colorScheme.secondary.withAlpha(
                    200,
                  ),
                  backgroundColor:
                      context.theme.colorScheme.secondary.withAlpha(
                    135,
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  lineWidth: 16,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (overallTimeLeft != null)
                        Text(
                          overallTimeLeft.time,
                          style: context.textTheme.headlineSmall!.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      Text(
                        timeLeft.time,
                        style: context.textTheme.headlineSmall!.copyWith(
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => RoundedButton(
                        onPressed: () {
                          if (_speechController.isSpeaking ||
                              timeLeft.inSeconds == 0) {
                            _speechController.stopwatch.stop();
                            _speechController.overallStopwatch.stop();
                          } else {
                            _speechController.stopwatch.start();
                            _speechController.overallStopwatch.start();
                          }

                          _speechController.isSpeaking =
                              !_speechController.isSpeaking;
                        },
                        color: Colors.blueGrey.shade600,
                        tooltip:
                            _speechController.isSpeaking ? "Stop" : "Start",
                        child: Icon(
                          _speechController.isSpeaking
                              ? Icons.stop
                              : Icons.play_arrow,
                        ),
                      ),
                    ),
                    RoundedButton(
                      onPressed: () {
                        if (_speechController.stopwatch.elapsed.inSeconds ==
                                0 &&
                            _speechController.overallDuration.inSeconds > 0) {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                _ResetCacusTimeDialog(tag: widget.tag),
                          );

                          return;
                        }

                        _speechController.stopwatch.stop();
                        _speechController.overallStopwatch.stop();

                        _speechController.isSpeaking = false;

                        _speechController.stopwatch.reset();
                        timer.cancel();

                        setupTimer();
                      },
                      tooltip: "Reset Timer",
                      color: context.theme.colorScheme.tertiary,
                      child: const Icon(Icons.restart_alt),
                    ),
                    RoundedButton(
                      onPressed: () {
                        _speechController.stopwatch.stop();
                        _speechController.overallStopwatch.stop();

                        _speechController.stopwatch.reset();

                        showDialog(
                          context: context,
                          builder: (_) => SpeechSettingsDialog(tag: widget.tag),
                        );
                      },
                      color: Colors.amber.shade400,
                      tooltip: "Settings",
                      child: const Icon(Icons.settings),
                    ),
                    if (widget.canYield)
                      RoundedButton(
                        onPressed: () {
                          final List<String> delegates =
                              Get.find<CommitteeController>()
                                  .committee
                                  .presentDelegates;

                          if (_speechController.currentSpeaker.isNotEmpty) {
                            delegates.remove(
                              _speechController.currentSpeaker,
                            );
                          }

                          return showDialog(
                            context: context,
                            builder: (_) => YieldSpeakerDialog(
                              delegates: delegates,
                              tag: widget.tag,
                            ),
                          );
                        },
                        color: Colors.grey.shade800,
                        tooltip: "Yield Speaker",
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

class _ResetCacusTimeDialog extends StatelessWidget {
  final String tag;

  const _ResetCacusTimeDialog({required this.tag});

  @override
  Widget build(BuildContext context) {
    final SpeechController _speechController =
        Get.find<SpeechController>(tag: tag);

    return DialogBox(
      heading: "Reset Caucus Time",
      content: const Text(
        "Do you want to reset the Caucus Time?",
      ),
      actions: [
        RoundedButton(
          style: RoundedButtonStyle.border,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          onPressed: () => context.pop(),
          child: const Text("No"),
        ),
        const SizedBox(width: 5),
        RoundedButton(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          onPressed: () {
            _speechController.stopwatch.stop();
            _speechController.overallStopwatch.stop();

            _speechController.isSpeaking = false;

            _speechController.overallStopwatch.reset();
            _speechController.stopwatch.reset();

            context.pop();
          },
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
