import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/config/constants/committee.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/route.dart';
import '../widgets/body.dart';

class CommitteePage extends StatefulWidget {
  final Widget child;

  const CommitteePage({super.key, required this.child});

  @override
  State<CommitteePage> createState() => _CommitteePageState();
}

class _CommitteePageState extends State<CommitteePage> {
  final CommitteeController committeeController =
      Get.find<CommitteeController>();

  int mode = 0;

  @override
  void initState() {
    mode = COMMITTEE_MODES.indexWhere(
      (mode) => mode["route"] == Get.find<RouteController>().path,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Body(
      trailing: PopupMenuButton<int>(
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
              Row(
                children: [
                  Icon(
                    COMMITTEE_MODES[mode]["icon"],
                    color: context.theme.colorScheme.tertiary,
                  ),
                  const VerticalDivider(),
                  Text(
                    COMMITTEE_MODES[mode]["name"],
                    style: context.textTheme.bodyLarge,
                  ),
                ],
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
          setState(() => mode = index);

          context.go(
            "${COMMITTEE_MODES[index]["route"]}?id=${committeeController.committee.id}",
          );
        },
      ),
      child: widget.child,
    );
  }
}
