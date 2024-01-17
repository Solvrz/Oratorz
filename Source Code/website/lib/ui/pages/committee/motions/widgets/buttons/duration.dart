import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/extensions.dart';
import '/ui/pages/committee/widgets/timer_button.dart';

class DurationButton extends StatefulWidget {
  final String title;
  final void Function(String) onChanged;

  final String? duration;

  const DurationButton({
    super.key,
    required this.title,
    required this.onChanged,
    this.duration,
  });

  @override
  State<DurationButton> createState() => _DurationButtonState();
}

class _DurationButtonState extends State<DurationButton> {
  late Duration _duration;

  @override
  void initState() {
    super.initState();

    _duration = Duration(seconds: (widget.duration ?? "60").toInt);
    widget.onChanged(_duration.inSeconds.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: context.textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TimerButton(
                value: _duration.inMinutes,
                change: (value) {
                  if (_duration.inMinutes + value <= 60) {
                    _duration += Duration(minutes: value);
                  }

                  setState(() {});
                  widget.onChanged(_duration.inSeconds.toString());
                },
                subtitle: "minutes",
              ),
              const SizedBox(width: 16),
              TimerButton(
                value: _duration.inSeconds - _duration.inMinutes * 60,
                change: (value) {
                  _duration += Duration(seconds: value);

                  setState(() {});
                  widget.onChanged(_duration.inSeconds.toString());
                },
                subtitle: "seconds",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
