import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';

class YieldSpeakerDialog extends StatefulWidget {
  final List<String> delegates;
  final String tag;

  const YieldSpeakerDialog({
    super.key,
    required this.delegates,
    required this.tag,
  });

  @override
  State<YieldSpeakerDialog> createState() => _YieldSpeakerDialogState();
}

class _YieldSpeakerDialogState extends State<YieldSpeakerDialog> {
  late final SpeechController _speechController;
  int selected = -1;

  @override
  void initState() {
    super.initState();

    _speechController = Get.find<SpeechController>(tag: widget.tag);
  }

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

                      _speechController.currentSpeaker = _delegate;
                      _speechController.nextSpeakers.remove(_delegate);
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

                          _speechController.currentSpeaker = _delegate;
                          _speechController.nextSpeakers.remove(_delegate);
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
