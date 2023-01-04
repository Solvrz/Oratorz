import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lazy_data_table/lazy_data_table.dart';

import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/scorecard.dart';
import '/tools/extensions.dart';
import '/ui/widgets/delegate_tile.dart';
import './parameter.dart';

class ScoreTable extends StatelessWidget {
  const ScoreTable({super.key});

  @override
  Widget build(BuildContext context) {
    final ScorecardController _scorecardController =
        Get.find<ScorecardController>();

    return Obx(() {
      final List<String> delegates =
          Get.find<CommitteeController>().committee.delegates;
      // TODO: Improve Code

      return Expanded(
        child: Obx(
          () => LazyDataTable(
            columns: _scorecardController.parameters.length + 2,
            rows: delegates.length,
            tableTheme: LazyDataTableTheme(
              columnHeaderColor: context.theme.colorScheme.secondary,
            ),
            tableDimensions: const LazyDataTableDimensions(
              cellWidth: 200,
              leftHeaderWidth: 75,
            ),
            topHeaderBuilder: (column) {
              if (column == 0) {
                return Center(
                  child: Text(
                    "Delegate",
                    style: context.textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                );
              } else if (column == _scorecardController.parameters.length + 1) {
                return Center(
                  child: Text(
                    "Total",
                    style: context.textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                );
              }

              return Center(
                child: Obx(
                  () => Parameter(
                    index: column - 1,
                    key: ValueKey(_scorecardController.parameters[column - 1]),
                    mode: _scorecardController.mode.value,
                  ),
                ),
              );
            },
            dataCellBuilder: (row, column) {
              final String _delegate = delegates[row];

              if (column == 0) {
                return DelegateTile(delegate: _delegate);
              } else if (column == _scorecardController.parameters.length + 1) {
                return Obx(() {
                  return Center(
                    child: Text(
                      _scorecardController.scores[_delegate]!.sum.toString(),
                    ),
                  );
                });
              }

              return _ScoreField(
                index: column,
                delegate: _delegate,
              );
            },
          ),
        ),
      );
    });
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
