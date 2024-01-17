import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/models/scorecard.dart';
import '/tools/controllers/comittee/scorecard.dart';
import '/tools/extensions.dart';

class Cell extends StatefulWidget {
  final String delegate;
  final int index;

  const Cell({
    super.key,
    required this.delegate,
    required this.index,
  });

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  final ScorecardController controller = Get.find<ScorecardController>();
  late final FocusNode focusNode;

  bool hovering = false;

  @override
  void initState() {
    focusNode = FocusNode();
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

                    return _CellEditing(
                      delegate: widget.delegate,
                      index: widget.index,
                      focusNode: focusNode,
                    );
                  },
                )
              : Center(
                  child: Text(
                    controller.scorecard.scores[widget.delegate]![widget.index]
                        .toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
        );
      },
    );
  }
}

class _CellEditing extends StatefulWidget {
  final String delegate;
  final int index;
  final FocusNode focusNode;

  const _CellEditing({
    required this.delegate,
    required this.index,
    required this.focusNode,
  });

  @override
  State<_CellEditing> createState() => _CellEditingState();
}

class _CellEditingState extends State<_CellEditing> {
  final ScorecardController controller = Get.find<ScorecardController>();
  late final Scorecard scorecard;
  late final TextEditingController textController;

  @override
  void initState() {
    scorecard = controller.scorecard;
    final double score = scorecard.scores[widget.delegate]![widget.index];

    textController =
        TextEditingController(text: score != 0 ? score.toString() : null);

    if (score != 0) {
      textController.selection = TextSelection.fromPosition(
        TextPosition(offset: score.toString().length),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int delegateIndex =
        scorecard.scores.keys.toList().indexOf(widget.delegate);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter, shift: true): () {
          FocusScope.of(context).unfocus();

          if (delegateIndex != 0) {
            controller.selected[0] =
                scorecard.scores.keys.toList()[delegateIndex - 1];
          }
        },
        const SingleActivator(LogicalKeyboardKey.enter): () {
          FocusScope.of(context).unfocus();

          if (delegateIndex != scorecard.scores.length - 1) {
            controller.selected[0] =
                scorecard.scores.keys.toList()[delegateIndex + 1];
          }
        },
        const SingleActivator(LogicalKeyboardKey.tab, shift: true): () {
          FocusScope.of(context).unfocus();

          if (widget.index == 0 && delegateIndex != 0) {
            controller.selected[0] =
                scorecard.scores.keys.toList()[delegateIndex - 1];

            controller.selected[1] = scorecard.parameters.length - 1;
          } else {
            controller.selected[1] = widget.index - 1;
          }
        },
        const SingleActivator(LogicalKeyboardKey.tab): () {
          FocusScope.of(context).unfocus();

          if (widget.index == scorecard.parameters.length - 1 &&
              delegateIndex != scorecard.scores.length - 1) {
            controller.selected[0] =
                scorecard.scores.keys.toList()[delegateIndex + 1];
            controller.selected[1] = 0;
          } else {
            controller.selected[1] = widget.index + 1;
          }
        },
      },
      child: TextField(
        focusNode: widget.focusNode,
        maxLines: null,
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
          ),
        ],
        onChanged: (text) {
          if (text.trim() == "") {
            controller.updateScore(widget.delegate, widget.index, 0);
          }

          if (double.tryParse(text) == null) return;

          if (text.toDouble <= scorecard.parameters[widget.index].maxScore) {
            controller.updateScore(
              widget.delegate,
              widget.index,
              text.toDouble,
            );
          } else {
            final String score =
                scorecard.scores[widget.delegate]![widget.index].toString();

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
      ),
    );
  }
}
