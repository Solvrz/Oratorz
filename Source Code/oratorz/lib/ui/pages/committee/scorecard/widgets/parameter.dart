import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/models/scorecard.dart';
import '/tools/controllers/comittee/scorecard.dart';
import '/tools/extensions.dart';
import '/ui/widgets/dialog_box.dart';

class ParameterWidget extends StatefulWidget {
  final Parameter parameter;
  final int mode;
  final bool isTotal;

  const ParameterWidget({
    super.key,
    required this.parameter,
    required this.mode,
    this.isTotal = false,
  });

  @override
  State<ParameterWidget> createState() => ParameterWidgetState();
}

class ParameterWidgetState extends State<ParameterWidget> {
  final ScorecardController controller = Get.find<ScorecardController>();
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final Scorecard scorecard = controller.scorecard;

    double total = 0;
    scorecard.parameters.forEach((e) => total += e.maxScore);

    final String title =
        widget.isTotal ? "Total ($total)" : widget.parameter.toString();

    if (widget.mode == 0) {
      return Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () {
              final bool isSortParameter =
                  widget.parameter.id == controller.sort.value.abs();

              return InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  if (!isSortParameter) {
                    controller.sort.value = -widget.parameter.id;
                  } else if (controller.sort.value < 0) {
                    controller.sort.value *= -1;
                  } else {
                    controller.sort.value = 0;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color:
                        isSortParameter ? Colors.grey[700] : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RotatedBox(
                        quarterTurns: 3,
                        child: Icon(
                          Icons.play_arrow,
                          color: isSortParameter
                              ? controller.sort.value > 0
                                  ? Colors.grey[200]
                                  : Colors.grey[500]
                              : Colors.grey[400],
                          size: 16,
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.play_arrow,
                          color: isSortParameter
                              ? controller.sort.value < 0
                                  ? Colors.white
                                  : Colors.grey[500]
                              : Colors.grey[400],
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
    }

    if (widget.isTotal) {
      return Center(
        child: Text(
          title,
          style: context.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    final int index = scorecard.parameters.indexOf(widget.parameter);

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          if (hovering) ...[
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (context) =>
                    _EditParameterDialog(parameter: widget.parameter),
              ),
              child: Icon(Icons.edit, color: Colors.grey[600]),
            ),
            if (index != scorecard.parameters.length - 1)
              GestureDetector(
                onTap: () => controller.reorderParameter(index),
                child: Icon(Icons.arrow_forward, color: Colors.grey[600]),
              ),
            GestureDetector(
              onTap: () => controller.deleteParameter(index),
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
  final Parameter parameter;

  const _EditParameterDialog({required this.parameter});

  @override
  Widget build(BuildContext context) {
    final ScorecardController _scorecardController =
        Get.find<ScorecardController>();

    final TextEditingController titleController =
        TextEditingController(text: parameter.title);

    final TextEditingController scoreController =
        TextEditingController(text: parameter.maxScore.toString());

    void submit() {
      _scorecardController.updateParameter(
        parameter,
        titleController.text.trim(),
        scoreController.text.toInt,
      );

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
              controller: titleController,
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
