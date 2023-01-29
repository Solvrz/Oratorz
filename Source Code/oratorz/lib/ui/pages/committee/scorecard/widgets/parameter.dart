import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/tools/controllers/comittee/scorecard.dart';
import '/tools/extensions.dart';
import '/ui/widgets/dialog_box.dart';

class Parameter extends StatefulWidget {
  final int index;
  final int mode;

  const Parameter({
    super.key,
    required this.index,
    required this.mode,
  });

  @override
  State<Parameter> createState() => ParameterState();
}

class ParameterState extends State<Parameter> {
  final ScorecardController controller = Get.find<ScorecardController>();
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    if (widget.mode == 0) {
      return Center(
        child: Text(
          "${controller.parameters[widget.index]} (${controller.maxScores[widget.index]})",
          style: context.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              "${controller.parameters[widget.index]} (${controller.maxScores[widget.index]})",
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          if (hovering) ...[
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (context) => _EditParameterDialog(index: widget.index),
              ),
              child: Icon(Icons.edit, color: Colors.grey[600]),
            ),
            if (widget.index != controller.parameters.length - 1)
              GestureDetector(
                onTap: () => controller.reorderParameter(widget.index),
                child: Icon(Icons.arrow_forward, color: Colors.grey[600]),
              ),
            GestureDetector(
              onTap: () => controller.deleteParameter(widget.index),
              child: Icon(
                Icons.delete_forever_outlined,
                color: Colors.red[400],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EditParameterDialog extends StatelessWidget {
  final int index;

  const _EditParameterDialog({required this.index});

  @override
  Widget build(BuildContext context) {
    final ScorecardController _scorecardController =
        Get.find<ScorecardController>();

    final TextEditingController parameterController = TextEditingController(
      text: _scorecardController.parameters[index],
    );
    final TextEditingController scoreController = TextEditingController(
      text: _scorecardController.maxScores[index].toString(),
    );

    void submit() {
      _scorecardController.parameters[index] = parameterController.text.trim();
      _scorecardController.maxScores[index] = scoreController.text.toInt;

      context.pop();
    }

    return DialogBox(
      heading: "Edit Parameter",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Name",
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: TextField(
              autofocus: true,
              controller: parameterController,
              onSubmitted: (_) => submit(),
              decoration: const InputDecoration(hintText: "Name"),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Max Score",
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: TextField(
              controller: scoreController,
              onSubmitted: (_) => submit(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: "Max Score"),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Change"),
          onPressed: () => submit(),
        ),
      ],
    );
  }
}
