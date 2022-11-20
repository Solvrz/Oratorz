import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '/tools/controllers/gsl.dart';

class StopwatchWidget extends StatefulWidget {
  final Function() onTimeEnd;

  const StopwatchWidget({super.key, required this.onTimeEnd});

  @override
  State<StopwatchWidget> createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  final Duration duration = const Duration(minutes: 1);
  final GSLController gslController = Get.find<GSLController>();

  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        setState(() {
          final Duration timeLeft =
              duration - gslController.stopwatch.value.elapsed;
          if (timeLeft.inSeconds <= 0) {
            widget.onTimeEnd();
            gslController.stopwatch.value.stop();
            timer.cancel();
          }
        });
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    gslController.stopwatch.value.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Duration timeLeft = duration - gslController.stopwatch.value.elapsed;

    return SizedBox(
      height: 250,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircularPercentIndicator(
            radius: 100,
            percent: (timeLeft.inSeconds / duration.inSeconds) * 0.975,
            progressColor: const Color(0xff0d1520).withAlpha(200),
            backgroundColor: const Color(0xff0d1520).withAlpha(135),
            circularStrokeCap: CircularStrokeCap.round,
            lineWidth: 16,
            center: Text(
              "${timeLeft.inMinutes}:${(timeLeft.inSeconds - timeLeft.inMinutes * 60).toString().padLeft(2, "0")}",
              style:
                  Theme.of(context).textTheme.headline5!.copyWith(fontSize: 32),
            ),
          ),
          const SizedBox(width: 24),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StopwatchButton(
                icon: gslController.stopwatch.value.isRunning
                    ? Icons.stop
                    : Icons.play_arrow,
                onPressed: () => gslController.stopwatch.value.isRunning ||
                        timeLeft.inSeconds == 0
                    ? gslController.stopwatch.value.stop()
                    : gslController.stopwatch.value.start(),
                color: Colors.blueGrey.shade600,
              ),
              StopwatchButton(
                icon: Icons.restart_alt,
                onPressed: () {
                  gslController.stopwatch.value.reset();
                  timer.cancel();

                  timer = Timer.periodic(
                    const Duration(seconds: 1),
                    (_) => setState(() {
                      final Duration timeLeft =
                          duration - gslController.stopwatch.value.elapsed;
                      if (timeLeft.inSeconds <= 0) {
                        widget.onTimeEnd();
                        gslController.stopwatch.value.stop();
                        timer.cancel();
                      }
                    }),
                  );
                },
                color: Colors.blue.shade400,
              ),
              StopwatchButton(
                icon: Icons.settings,
                onPressed: () {},
                color: Colors.amber.shade400,
              ),
              StopwatchButton(
                icon: Icons.person,
                onPressed: () {},
                color: Colors.grey.shade800,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StopwatchButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function() onPressed;

  const StopwatchButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        overlayColor: MaterialStateProperty.all<Color>(Colors.white12),
        side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Icon(icon),
      ),
    );
  }
}
