import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

import '/config/constants/committee.dart';
import '/tools/controllers/comittee/mode.dart';
import '/tools/controllers/route.dart';
import '../widgets/body.dart';

class CommitteePage extends StatelessWidget {
  const CommitteePage({super.key});

  @override
  Widget build(BuildContext context) {
    final RouteController _routeController = Get.find<RouteController>();

    final ModeController _modeController = Get.put(
      ModeController(
        mode: COMMITTEE_MODES
            .indexWhere(
              (mode) =>
                  mode["route"].toString().contains(_routeController.path),
            )
            .clamp(0, double.infinity)
            .toInt(),
      ),
    );

    return Body(
      trailing: _ModeSelector(),
      child: Obx(() => _modeController.currentMode),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ModeController _modeController = Get.find<ModeController>();

    return PopupMenuButton<int>(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      tooltip: "Select Mode",
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.theme.colorScheme.secondary),
        ),
        child: Row(
          children: [
            Obx(
              () => Row(
                children: [
                  Icon(
                    _modeController.currentModeDetails["icon"],
                    color: context.theme.colorScheme.tertiary,
                  ),
                  const VerticalDivider(),
                  Text(
                    _modeController.currentModeDetails["name"],
                    style: context.textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Icon(
              Icons.arrow_drop_down,
              size: 36,
              color: context.theme.colorScheme.secondary,
            ),
          ],
        ),
      ),
      itemBuilder: (_) => List.generate(COMMITTEE_MODES.length, (index) {
        final Map<String, dynamic> tab = COMMITTEE_MODES[index];

        return PopupMenuItem(
          value: index,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    tab["icon"],
                    color: context.theme.colorScheme.tertiary,
                  ),
                  const VerticalDivider(),
                  Text(tab["name"]),
                ],
              ),
            ],
          ),
        );
      }),
      onSelected: (index) {
        _modeController.mode = index;
        html.window.history.pushState(
          null,
          "mode",
          _modeController.currentModeDetails["route"],
        );
      },
    );
  }
}
