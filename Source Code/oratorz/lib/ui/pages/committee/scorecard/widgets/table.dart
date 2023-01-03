import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/scorecard.dart';
import '/tools/extensions.dart';
import '/ui/widgets/delegate_tile.dart';
import './parameter.dart';

class Table extends StatelessWidget {
  const Table({super.key});

  @override
  Widget build(BuildContext context) {
    final ScorecardController _scorecardController =
        Get.find<ScorecardController>();

    // TODO: Next Load

    return Obx(
      () {
        final List<DataColumn> _columns = [
          const DataColumn(label: Text("Delegate")),
          ...List.generate(
            _scorecardController.parameters.length,
            (index) => DataColumn(
              numeric: true,
              label: Parameter(
                key: ValueKey(_scorecardController.parameters[index]),
                index: index,
                mode: _scorecardController.mode.value,
              ),
            ),
          ),
          const DataColumn(
            label: Text("Total"),
            numeric: true,
          ),
        ];

        final List<DataRow> _rows = Get.find<CommitteeController>()
            .committee
            .delegates
            .map<DataRow>(
              (delegate) => DataRow(
                cells: List<DataCell>.generate(
                  _scorecardController.parameters.length + 2,
                  (index) {
                    if (index == 0) {
                      return DataCell(
                        DelegateTile(delegate: delegate),
                      );
                    } else if (index ==
                        _scorecardController.parameters.length + 1) {
                      return DataCell(
                        Text(
                          _scorecardController.scores[delegate]!.sum.toString(),
                        ),
                      );
                    }

                    return DataCell(
                      _ScoreField(delegate: delegate, index: index),
                    );
                  },
                ).toList(),
              ),
            )
            .toList();

        return Expanded(
          child: SingleChildScrollView(
            child: DataTable(columns: _columns, rows: _rows),
          ),
        );
      },
    );
  }
}

class _ScoreField extends StatelessWidget {
  final String delegate;
  final int index;

  const _ScoreField({
    required this.delegate,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ScorecardController _scorecardController =
        Get.find<ScorecardController>();

    final double score = _scorecardController.scores[delegate]![index - 1];
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
      textAlign: TextAlign.right,
      decoration: const InputDecoration(
        hintText: "0",
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'(^-?\d*\.?\d*)'),
        )
      ],
      onChanged: (text) {
        if (text.trim() == "") {
          _scorecardController.updateScore(
            delegate,
            index - 1,
            0,
          );
        }

        if (double.tryParse(text) == null) return;

        if (text.toDouble <= _scorecardController.maxScores[index - 1]) {
          _scorecardController.updateScore(
            delegate,
            index - 1,
            text.toDouble,
          );
        } else {
          final String score =
              _scorecardController.scores[delegate]![index - 1].toString();

          textController.text = score;

          textController.selection = TextSelection.fromPosition(
            TextPosition(offset: score.length),
          );
        }
      },
    );
  }
}
