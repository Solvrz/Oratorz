import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '/config/constants/constants.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/filled_button.dart';

class StopwatchWidget extends StatefulWidget {
  final Function() onTimeEnd;
  final String tag;
  final bool canYield;

  const StopwatchWidget({
    super.key,
    required this.onTimeEnd,
    required this.tag,
    this.canYield = true,
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
              widget.onTimeEnd();
              _speechController.stopwatch.value.stop();

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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 250,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircularPercentIndicator(
              radius: 100,
              percent: (timeLeft.inSeconds /
                      _speechController.duration.value.inSeconds) *
                  0.975,
              progressColor: theme.colorScheme.secondary.withAlpha(200),
              backgroundColor: theme.colorScheme.secondary.withAlpha(135),
              circularStrokeCap: CircularStrokeCap.round,
              lineWidth: 16,
              center: Text(
                "${timeLeft.inMinutes}:${(timeLeft.inSeconds - timeLeft.inMinutes * 60).toString().padLeft(2, "0")}",
                style: theme.textTheme.headline5!.copyWith(fontSize: 32),
              ),
            ),
            const SizedBox(width: 24),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  onPressed: () {
                    _speechController.isSpeaking.value ||
                            timeLeft.inSeconds == 0
                        ? _speechController.stopwatch.value.stop()
                        : _speechController.stopwatch.value.start();

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
                    _speechController.stopwatch.value.reset();
                    timer.cancel();

                    setupTimer();
                  },
                  color: Colors.blue.shade400,
                  child: const Icon(Icons.restart_alt),
                ),
                FilledButton(
                  onPressed: () {
                    _speechController.stopwatch.value.stop();
                    _speechController.stopwatch.value.reset();

                    showDialog(
                      context: context,
                      builder: (context) => DialogBox(
                        heading: "Set Speaker Time",
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TimerButton(
                                    value: _speechController
                                        .duration.value.inMinutes,
                                    change: (value) {
                                      if (_speechController
                                                  .duration.value.inMinutes +
                                              value <=
                                          60) {
                                        _speechController.duration.value +=
                                            Duration(minutes: value);
                                      }
                                    },
                                    subtitle: "minutes",
                                  ),
                                  TimerButton(
                                    value: _speechController
                                            .duration.value.inSeconds -
                                        _speechController
                                                .duration.value.inMinutes *
                                            60,
                                    change: (value) => _speechController
                                        .duration
                                        .value += Duration(seconds: value),
                                    subtitle: "seconds",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Change"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                  color: Colors.amber.shade400,
                  child: const Icon(Icons.settings),
                ),
                FilledButton(
                  onPressed: () {
                    final CommitteeController _committeeController =
                        Get.find<CommitteeController>();

                    // TODO: Change to Present Speakers & Not Working
                    final List<String> delegates =
                        _committeeController.committee.value.delegates;

                    if (_speechController.currentSpeaker.value != "") {
                      delegates.remove(_speechController.currentSpeaker.value);
                    }

                    return showDialog(
                      context: context,
                      builder: (context) =>
                          YieldSpeakerDialog(delegates: delegates),
                    );
                  },
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.person),
                ),
              ],
            ),
          ],
        ),
      );
}

class YieldSpeakerDialog extends StatefulWidget {
  final List<String> delegates;

  const YieldSpeakerDialog({
    super.key,
    required this.delegates,
  });

  @override
  State<YieldSpeakerDialog> createState() => _YieldSpeakerDialogState();
}

class _YieldSpeakerDialogState extends State<YieldSpeakerDialog> {
  int selected = -1;

  @override
  Widget build(BuildContext context) => DialogBox(
        heading: "Yield to Speaker",
        content: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                widget.delegates.length,
                (index) => DelegateTile(
                  delegate: widget.delegates[index],
                  onTap: () => setState(() => selected = index),
                  trailing: Radio(
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    overlayColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    groupValue: selected,
                    value: index,
                    fillColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade700),
                    onChanged: (value) => setState(() {
                      if (value != null) {
                        selected = value as int;
                      }
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: FilledButton(
              color: theme.colorScheme.secondary,
              onPressed: () => Navigator.pop(context),
              child: const Text("DONE"),
            ),
          ),
        ],
      );
}

class TimerButton extends StatelessWidget {
  final int value;
  final String subtitle;
  final Function(int) change;

  const TimerButton({
    super.key,
    required this.value,
    required this.subtitle,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: value.toString().padLeft(2, '0'));

    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            width: 140,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    cursorColor: Colors.grey.shade700,
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                      hintText: "00",
                      hintStyle: theme.textTheme.headline1!.copyWith(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (text) {
                      if (0 <= int.parse(text) && int.parse(text) < 60) {
                        change(int.parse(text) - value);
                        controller.text = text.padLeft(2, '0');
                      } else {
                        controller.text = value.toString().padLeft(2, '0');
                      }

                      controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: controller.text.length),
                      );
                    },
                    style: theme.textTheme.headline1!.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                Column(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => change(1),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(Icons.add, size: 18),
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => change(-1),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(Icons.remove, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Text(
          subtitle.toUpperCase(),
          style: theme.textTheme.bodyText1!.copyWith(
            fontSize: 12,
            color: Colors.grey.shade600,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
