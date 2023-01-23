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

  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return InkWell(
          onTap: () {},
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onHover: (val) => setState(() => hovering = val),
          child: hovering
              ? _ScoreCellEditing(
                  delegate: widget.delegate,
                  index: widget.index,
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

  const _ScoreCellEditing({
    required this.delegate,
    required this.index,
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
    );
  }
}
