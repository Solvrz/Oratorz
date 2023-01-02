import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/scorecard.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';
import '../../../../services/local_storage.dart';
import '../widgets/body.dart';

class ScorecardPage extends StatelessWidget {
  const ScorecardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScorecardController controller;

    final CommitteeController committeeController =
        Get.find<CommitteeController>();

    if (!Get.isRegistered<ScorecardController>()) {
      final bool exists = LocalStorage.loadScore();

      if (exists) {
        controller = Get.find<ScorecardController>();
      } else {
        controller = Get.put<ScorecardController>(ScorecardController());
        LocalStorage.saveScore(controller);
      }
    } else {
      controller = Get.find<ScorecardController>();
    }

    return Body(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(
            () => Row(
              children: [
                Text(
                  "Scorecard",
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Spacer(),
                if (controller.mode.value == 1)
                  Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: RoundedButton(
                      onPressed: () => controller.addParameter("Test", 10),
                      border: true,
                      child: const Text("Add Parameter"),
                    ),
                  ),
                RoundedButton(
                  onPressed: controller.toggleMode,
                  child: Text(
                    controller.mode.value == 0 ? "Edit Parameters" : "Done",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text("Delegate")),
                    ...List.generate(
                      controller.parameters.length,
                      (index) => DataColumn(
                        label: _ParameterWidget(
                          key: ValueKey(controller.parameters[index]),
                          index: index,
                          mode: controller.mode.value,
                        ),
                        numeric: true,
                      ),
                    ),
                    const DataColumn(
                      label: Text("Total"),
                      numeric: true,
                    ),
                  ],
                  rows: committeeController.committee.delegates.map<DataRow>(
                    (delegate) {
                      return DataRow(
                        cells: List<DataCell>.generate(
                          controller.parameters.length + 2,
                          (index) {
                            if (index == 0) {
                              return DataCell(
                                DelegateTile(
                                  delegate: delegate,
                                ),
                              );
                            }

                            if (index == controller.parameters.length + 1) {
                              return DataCell(
                                Text(
                                  controller.scores[delegate]!.sum.toString(),
                                ),
                              );
                            }

                            final double score =
                                controller.scores[delegate]![index - 1];

                            final TextEditingController textController =
                                TextEditingController(
                              text: score != 0 ? score.toString() : null,
                            );

                            if (score != 0) {
                              textController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(offset: score.toString().length),
                              );
                            }

                            return DataCell(
                              TextField(
                                controller: textController,
                                textAlign: TextAlign.right,
                                cursorColor: Colors.grey[700],
                                decoration: const InputDecoration(
                                  hintText: "0",
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'(^-?\d*\.?\d*)'),
                                  )
                                ],
                                onChanged: (text) {
                                  if (text.trim() == "") {
                                    controller.updateScore(
                                      delegate,
                                      index - 1,
                                      0,
                                    );
                                  }

                                  if (double.tryParse(text) == null) return;

                                  if (double.parse(text) <=
                                      controller.maxScores[index - 1]) {
                                    controller.updateScore(
                                      delegate,
                                      index - 1,
                                      double.parse(text),
                                    );
                                  } else {
                                    final String score = controller
                                        .scores[delegate]![index - 1]
                                        .toString();

                                    textController.text = score;

                                    textController.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(offset: score.length),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ).toList(),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParameterWidget extends StatefulWidget {
  final int index;
  final int mode;

  const _ParameterWidget({
    required key,
    required this.index,
    required this.mode,
  }) : super(key: key);

  @override
  State<_ParameterWidget> createState() => __ParameterWidgetState();
}

class __ParameterWidgetState extends State<_ParameterWidget> {
  final ScorecardController controller = Get.find<ScorecardController>();

  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    if (widget.mode == 0) {
      return Text(
        "${controller.parameters[widget.index]} (${controller.maxScores[widget.index]})",
      );
    }

    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () {},
      onHover: (val) {
        setState(() => hovering = val);
      },
      child: Row(
        children: [
          Text(
            "${controller.parameters[widget.index]} (${controller.maxScores[widget.index]})",
          ),
          if (hovering) ...[
            GestureDetector(
              onTap: () {
                final TextEditingController parameterController =
                    TextEditingController(
                  text: controller.parameters[widget.index],
                );

                final TextEditingController scoreController =
                    TextEditingController(
                  text: controller.maxScores[widget.index].toString(),
                );

                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogBox(
                      heading: "Change Parameter",
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Parameter Name",
                            style: context.textTheme.headline6,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: TextField(
                              autofocus: true,
                              controller: parameterController,
                              onSubmitted: (value) {
                                controller.parameters[widget.index] =
                                    parameterController.text.trim();
                                controller.maxScores[widget.index] =
                                    int.parse(scoreController.text);
                                context.pop();
                              },
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.grey[600],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: "Parameter Name",
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Max Score",
                            style: context.textTheme.headline6,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: scoreController,
                              onSubmitted: (value) {
                                controller.parameters[widget.index] =
                                    parameterController.text.trim();
                                controller.maxScores[widget.index] =
                                    int.parse(scoreController.text);
                                context.pop();
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              cursorColor: Colors.grey[600],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: "Max Score",
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Change"),
                          onPressed: () {
                            controller.parameters[widget.index] =
                                parameterController.text.trim();
                            controller.maxScores[widget.index] =
                                int.parse(scoreController.text);
                            context.pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
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
                color: Colors.redAccent.shade100,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
