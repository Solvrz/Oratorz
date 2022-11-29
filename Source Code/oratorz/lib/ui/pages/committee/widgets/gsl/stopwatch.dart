import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oratorz/ui/widgets/filled_button.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '/tools/controllers/comittee/gsl.dart';
import '/tools/controllers/home.dart';
import '/ui/widgets/country_tile.dart';
import '/ui/widgets/dialog_box.dart';
import '../../../../widgets/border_button.dart';

class StopwatchWidget extends StatefulWidget {
  final Function() onTimeEnd;

  const StopwatchWidget({super.key, required this.onTimeEnd});

  @override
  State<StopwatchWidget> createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  // TODO: Extract for Others
  late Timer timer;
  final GSLController _gslController = Get.find<GSLController>();

  Duration timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();

    setupTimer();
    timeLeft = _gslController.duration.value;
  }

  void setupTimer() => timer = Timer.periodic(
        const Duration(milliseconds: 500),
        (_) {
          setState(() {
            timeLeft = _gslController.duration.value -
                _gslController.stopwatch.value.elapsed;

            if (timeLeft.inMilliseconds < 0) {
              widget.onTimeEnd();
              _gslController.stopwatch.value.stop();

              timeLeft = Duration.zero;
              timer.cancel();
            }
          });
        },
      );

  @override
  void dispose() {
    timer.cancel();
    _gslController.stopwatch.value.stop();

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
                      _gslController.duration.value.inSeconds) *
                  0.975,
              progressColor: const Color(0xff0d1520).withAlpha(200),
              backgroundColor: const Color(0xff0d1520).withAlpha(135),
              circularStrokeCap: CircularStrokeCap.round,
              lineWidth: 16,
              center: Text(
                "${timeLeft.inMinutes}:${(timeLeft.inSeconds - timeLeft.inMinutes * 60).toString().padLeft(2, "0")}",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontSize: 32),
              ),
            ),
            const SizedBox(width: 24),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  icon: _gslController.isSpeaking.value
                      ? Icons.stop
                      : Icons.play_arrow,
                  onPressed: () {
                    _gslController.isSpeaking.value || timeLeft.inSeconds == 0
                        ? _gslController.stopwatch.value.stop()
                        : _gslController.stopwatch.value.start();

                    _gslController.isSpeaking.value =
                        !_gslController.isSpeaking.value;
                  },
                  color: Colors.blueGrey.shade600,
                ),
                FilledButton(
                  icon: Icons.restart_alt,
                  onPressed: () {
                    _gslController.stopwatch.value.reset();
                    timer.cancel();

                    setupTimer();
                  },
                  color: Colors.blue.shade400,
                ),
                FilledButton(
                  icon: Icons.settings,
                  onPressed: () {
                    _gslController.stopwatch.value.stop();
                    _gslController.stopwatch.value.reset();

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
                                    value:
                                        _gslController.duration.value.inMinutes,
                                    change: (value) {
                                      if (_gslController
                                                  .duration.value.inMinutes +
                                              value <=
                                          60) {
                                        _gslController.duration.value +=
                                            Duration(minutes: value);
                                      }
                                    },
                                    subtitle: "minutes",
                                  ),
                                  TimerButton(
                                    value: _gslController
                                            .duration.value.inSeconds -
                                        _gslController
                                                .duration.value.inMinutes *
                                            60,
                                    change: (value) => _gslController.duration
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
                ),
                FilledButton(
                  icon: Icons.person,
                  onPressed: () {
                    final HomeController _homeController =
                        Get.find<HomeController>();

                    // TODO: Add Overtime Support
                    // TODO: Change to Present Speakers & Not Working
                    final List<String> countries =
                        _homeController.committee.value.countries;

                    if (_gslController.currentSpeaker.value != "") {
                      countries.remove(_gslController.currentSpeaker.value);
                    }

                    return showDialog(
                      context: context,
                      builder: (context) =>
                          YieldSpeakerDialog(countries: countries),
                    );
                  },
                  color: Colors.grey.shade800,
                ),
              ],
            ),
          ],
        ),
      );
}

class YieldSpeakerDialog extends StatefulWidget {
  const YieldSpeakerDialog({
    super.key,
    required this.countries,
  });

  final List<String> countries;

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
                widget.countries.length,
                (index) => CountryTile(
                  country: widget.countries[index],
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
            child: BorderButton(
              padding: const EdgeInsets.symmetric(vertical: 4),
              text: "DONE",
              color: const Color(0xff0d1520),
              onPressed: () => Navigator.pop(context),
              filled: true,
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
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          color: const Color(0xfffcfcfc),
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
                      hintStyle:
                          Theme.of(context).textTheme.headline1!.copyWith(
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
                    style: Theme.of(context).textTheme.headline1!.copyWith(
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
                          elevation: 4,
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
                          elevation: 4,
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
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 12,
                color: Colors.grey.shade600,
                letterSpacing: 1.5,
              ),
        ),
      ],
    );
  }
}
