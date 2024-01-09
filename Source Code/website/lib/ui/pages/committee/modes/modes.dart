import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../widgets/body.dart';
import '/models/router.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/route.dart';

class ModesPage extends StatefulWidget {
  final Widget child;

  const ModesPage({super.key, required this.child});

  @override
  State<ModesPage> createState() => _ModesPageState();
}

class _ModesPageState extends State<ModesPage> {
  final CommitteeController committeeController =
      Get.find<CommitteeController>();

  int selected = 0;

  @override
  void initState() {
    selected = AppRouter.modes.indexWhere(
      (route) => route.path == Get.find<RouteController>().path,
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
                    AppRouter.modes[selected].icon,
                    color: context.theme.colorScheme.tertiary,
                  ),
                  const VerticalDivider(),
                  Text(
                    AppRouter.modes[selected].title ?? "",
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
        itemBuilder: (_) => List.generate(AppRouter.modes.length, (index) {
          final AppRoute route = AppRouter.modes[index];

          return PopupMenuItem(
            value: index,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      route.icon,
                      color: context.theme.colorScheme.tertiary,
                    ),
                    const VerticalDivider(),
                    Text(route.title ?? ""),
                  ],
                ),
              ],
            ),
          );
        }),
        onSelected: (index) {
          setState(() => selected = index);

          context.go(
            "${AppRouter.modes[index].path}?id=${committeeController.committee.id}",
          );
        },
      ),
      child: widget.child,
    );
  }
}
