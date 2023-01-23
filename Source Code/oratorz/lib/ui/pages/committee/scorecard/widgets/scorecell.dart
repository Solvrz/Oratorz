import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/scorecard.dart';
import '/tools/extensions.dart';

class ScoreCell extends StatefulWidget {
  final String delegate;
  final int index;

  const ScoreCell({
    super.key,
    required this.delegate,
    required this.index,
  });

  @override
  State<ScoreCell> createState() => _ScoreCellState();
}

class _ScoreCellState extends State<ScoreCell> {
  final ScorecardController controller = Get.find<ScorecardController>();
  late final FocusNode focusNode;

  bool hovering = false;

  @override
  void initState() {
    focusNode = FocusNode()
      ..attach(
        context,
        onKey: (node, event) {
          final int delegateIndex =
              controller.scores.keys.toList().indexOf(widget.delegate);

          if (event.isKeyPressed(LogicalKeyboardKey.tab) && !event.repeat) {
            FocusScope.of(context).unfocus();

            if (event.isShiftPressed) {
              if (widget.index == 0 && delegateIndex != 0) {
                controller.selected[0] =
                    controller.scores.keys.toList()[delegateIndex - 1];

                controller.selected[1] = controller.parameters.length - 1;
              } else {
                controller.selected[1] = widget.index - 1;
              }
            } else {
              if (widget.index == controller.parameters.length - 1 &&
                  delegateIndex != controller.scores.length - 1) {
                controller.selected[0] =
                    controller.scores.keys.toList()[delegateIndex + 1];
                controller.selected[1] = 0;
              } else {
                controller.selected[1] = widget.index + 1;
              }
            }

            return KeyEventResult.handled;
          }

          return KeyEventResult.ignored;
        },
      );

    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final bool selected = controller.selected[0] == widget.delegate &&
            controller.selected[1] == widget.index;

        return InkWell(
          onTap: () {},
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onHover: (val) => setState(() => hovering = val),
          onFocusChange: (val) {
            if (val) {
              controller.selected[0] = widget.delegate;
              controller.selected[1] = widget.index;
            } else if (controller.selected[0] == widget.delegate &&
                controller.selected[1] == widget.index) {
              controller.selected[0] = "";
              controller.selected[1] = widget.index;
            }
          },
          child: hovering || selected
              ? Builder(
                  builder: (context) {
                    if (selected) {
                      focusNode.requestFocus();
                    }

                    return _ScoreCellEditing(
                      delegate: widget.delegate,
                      index: widget.index,
                      focusNode: focusNode,
                    );
                  },
                )
              : Center(
                  child: Text(
                    controller.scores[widget.delegate]![widget.index]
                        .toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
        );
      },
    );
  }
}

class _ScoreCellEditing extends StatelessWidget {
  final String delegate;
  final int index;
  final FocusNode focusNode;

  const _ScoreCellEditing({
    required this.delegate,
    required this.index,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final ScorecardController controller = Get.find<ScorecardController>();
    final double score = controller.scores[delegate]![index];
    final TextEditingController textController = TextEditingController(
      text: score != 0 ? score.toString() : null,
    );

    if (score != 0) {
      textController.selection = TextSelection.fromPosition(
        TextPosition(offset: score.toString().length),
      );
    }

    return TextField(
      focusNode: focusNode,
      controller: textController,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        hintText: "0",
        fillColor: Colors.white,
        focusColor: Colors.white,
        hoverColor: Colors.white,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'(^-?\d*\.?\d*)'),
        )
      ],
      onChanged: (text) {
        if (text.trim() == "") {
          controller.updateScore(delegate, index, 0);
        }

        if (double.tryParse(text) == null) return;

        if (text.toDouble <= controller.maxScores[index]) {
          controller.updateScore(delegate, index, text.toDouble);
        } else {
          final String score = controller.scores[delegate]![index].toString();

          if (score != "0") {
            textController.text = score;

            textController.selection = TextSelection.fromPosition(
              TextPosition(offset: score.length),
            );
          } else {
            textController.text = "";
          }
        }
      },
      onSubmitted: (_) {
        FocusScope.of(context).unfocus();

        final int delegateIndex =
            controller.scores.keys.toList().indexOf(delegate);

        if (delegateIndex != controller.scores.length - 1) {
          controller.selected[0] =
              controller.scores.keys.toList()[delegateIndex + 1];
        }
      },
    );
  }
}
