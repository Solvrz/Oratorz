import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/tools/controllers/comittee/scorecard.dart';
import '/tools/extensions.dart';
import '/ui/widgets/dialog_box.dart';

class ParameterWidget extends StatefulWidget {
  final int index;
  final int mode;
  final bool isTotal;

  const ParameterWidget({
    super.key,
    required this.index,
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
    double total = 0;
    controller.parameters.forEach((e) => total += e.maxScore);

    final String title = widget.isTotal
        ? "Total ($total)"
        : controller.parameters[widget.index].toString();

    if (widget.mode == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: context.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 8),
          Obx(
            () {
              final bool isSortParameter =
                  widget.index == (controller.sort.value.abs() - 1);

              return InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  if (!isSortParameter) {
                    controller.sort.value = -(widget.index + 1);
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

    final TextEditingController titleController = TextEditingController(
      text: _scorecardController.parameters[index].title,
    );

    final TextEditingController scoreController = TextEditingController(
      text: _scorecardController.parameters[index].maxScore.toString(),
    );

    void submit() {
      _scorecardController.updateParameter(
        index,
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
