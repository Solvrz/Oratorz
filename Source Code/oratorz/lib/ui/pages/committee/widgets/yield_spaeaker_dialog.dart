import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';

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
  Widget build(BuildContext context) {
    return DialogBox(
      heading: "Yield to Speaker",
      content: SizedBox(
        height: context.height / 2,
        child: widget.delegates.isNotEmpty
            ? ListView.builder(
                itemCount: widget.delegates.length,
                itemBuilder: (_, index) {
                  final String _delegate = widget.delegates[index];

                  return DelegateTile(
                    delegate: widget.delegates[index],
                    onTap: () {
                      setState(() => selected = index);

                      widget.controller.currentSpeaker = _delegate;
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

                          widget.controller.currentSpeaker = _delegate;
                          widget.controller.nextSpeakers.remove(_delegate);
                        }
                      }),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  "Conduct a roll call before yielding speakers",
                  style: context.textTheme.bodyText1,
                ),
              ),
      ),
      actions: [
        SizedBox(
          width: context.width / 3,
          child: RoundedButton(
            onPressed: () => context.pop(),
            child: const Text("DONE"),
          ),
        ),
      ],
    );
  }
}
