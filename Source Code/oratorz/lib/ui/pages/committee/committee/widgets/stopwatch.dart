import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '/config/constants/constants.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/filled_button.dart';
import './settings_dialog.dart';

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
                  onPressed: () async {
                    _speechController.stopwatch.value.stop();
                    _speechController.stopwatch.value.reset();

                    await showDialog(
                      context: context,
                      builder: (context) =>
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
                      final List<String> delegates =
                          _committeeController.committee.value.presentDelegates;

                      if (_speechController.currentSpeaker.value != "") {
                        delegates
                            .remove(_speechController.currentSpeaker.value);
                      }

                      return showDialog(
                        context: context,
                        builder: (context) => YieldSpeakerDialog(
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
      );
}

class YieldSpeakerDialog extends StatefulWidget {
  final List<String> delegates;
  final SpeechController controller;

  const YieldSpeakerDialog({
    super.key,
    required this.delegates,
    required this.controller,
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
          child: widget.delegates.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      widget.delegates.length,
                      (index) {
                        final String _delegate = widget.delegates[index];

                        return DelegateTile(
                          delegate: widget.delegates[index],
                          contentPadding: const EdgeInsets.all(5),
                          onTap: () {
                            setState(() => selected = index);

                            widget.controller.currentSpeaker.value = _delegate;
                            widget.controller.nextSpeakers.remove(_delegate);
                          },
                          trailing: Radio(
                            value: index,
                            groupValue: selected,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            overlayColor: MaterialStateProperty.all<Color>(
                              Colors.transparent,
                            ),
                            fillColor: MaterialStateProperty.all<Color>(
                              Colors.grey.shade700,
                            ),
                            onChanged: (value) => setState(() {
                              if (value != null) {
                                selected = value as int;

                                widget.controller.currentSpeaker.value =
                                    _delegate;
                                widget.controller.nextSpeakers
                                    .remove(_delegate);
                              }
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    "Conduct a roll call before yielding speakers",
                    style: theme.textTheme.bodyText1,
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
