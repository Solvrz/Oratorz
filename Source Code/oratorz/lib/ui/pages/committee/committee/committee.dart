import 'package:flutter/material.dart' hide TabController;
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

import '/config/constants/committee.dart';
import '/config/constants/constants.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/mode.dart';
import '/tools/controllers/route.dart';
import '/ui/widgets/dialog_box.dart';

class CommitteePage extends StatelessWidget {
  const CommitteePage({super.key});

  @override
  Widget build(BuildContext context) {
    final RouteController _routeController = Get.find<RouteController>();

    final ModeController _modeController = Get.put(
      ModeController(
        modeVal: COMMITTEE_MODES
            .indexWhere(
              (mode) =>
                  mode["route"].toString().contains(_routeController.path),
            )
            .clamp(0, double.infinity)
            .toInt(),
      ),
    );

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ModeHeader(),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(
              () => _modeController.currentTab()["tab"],
            ),
          ),
        ],
      ),
    );
  }
}

class ModeHeader extends StatelessWidget {
  const ModeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final CommitteeController _committeeController =
        Get.find<CommitteeController>();
    final ModeController _modeController = Get.find<ModeController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // TODO: Not Updating
        Row(
          children: [
            Obx(
              () => RichText(
                text: TextSpan(
                  text: "Agenda: ",
                  style: theme.textTheme.headline5,
                  children: [
                    TextSpan(
                      text: _committeeController.committee.value.agenda,
                      style: theme.textTheme.headline5!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            InkWell(
              onTap: () {
                final TextEditingController _controller = TextEditingController(
                  text: _committeeController.committee.value.agenda,
                );

                showDialog(
                  context: context,
                  builder: (context) => DialogBox(
                    heading: "Set Committee Name",
                    content: TextField(
                      autofocus: true,
                      controller: _controller,
                      onSubmitted: (value) {
                        _committeeController.committee.value.agenda =
                            _controller.text;

                        Navigator.pop(context);
                      },
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.grey[600],
                      decoration: InputDecoration(
                        fillColor: Colors.grey[200],
                        hintText: "Agenda",
                      ),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    actionsPadding: const EdgeInsets.all(16),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _committeeController.committee.value.agenda =
                              _controller.text;

                          Navigator.pop(context);
                        },
                        child: const Text("Select"),
                      )
                    ],
                  ),
                );
              },
              hoverColor: const Color.fromARGB(255, 250, 250, 250),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade400),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.amber.shade400,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        PopupMenuButton<int>(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.colorScheme.secondary),
            ),
            child: Row(
              children: [
                Obx(
                  () => Row(
                    children: [
                      Icon(
                        _modeController.currentTab()["icon"],
                        color: theme.colorScheme.tertiary,
                      ),
                      const VerticalDivider(),
                      Text(
                        _modeController.currentTab()["name"],
                        style: theme.textTheme.headline5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Icon(
                  Icons.arrow_drop_down,
                  color: theme.colorScheme.secondary,
                  size: 36,
                ),
              ],
            ),
          ),
          itemBuilder: (_) => List.generate(
            COMMITTEE_MODES.length,
            (index) {
              final Map<String, dynamic> tab = COMMITTEE_MODES[index];

              return PopupMenuItem(
                value: index,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          tab["icon"],
                          color: theme.colorScheme.tertiary,
                        ),
                        const VerticalDivider(),
                        Text(tab["name"]),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          onSelected: (index) {
            _modeController.modeVal = index;
            html.window.history.pushState(
              null,
              "mode",
              COMMITTEE_MODES[index]["route"],
            );
          },
        ),
      ],
    );
  }
}
