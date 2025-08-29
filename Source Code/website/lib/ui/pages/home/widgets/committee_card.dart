import 'package:flutter/material.dart' hide Router, Route;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/models/committee.dart';
import '/models/router.dart';
import '/services/cloud_storage.dart';
import '/tools/controllers/app.dart';
import '/tools/controllers/route.dart';
import '/tools/extensions.dart';

class CommitteeCard extends StatefulWidget {
  final Committee committee;

  const CommitteeCard({
    super.key,
    required this.committee,
  });

  @override
  State<CommitteeCard> createState() => _CommitteeCardState();
}

class _CommitteeCardState extends State<CommitteeCard>
    with SingleTickerProviderStateMixin {
  final Map<String, Color> colors = const {
    "AIPPM": Color(0xB1E9370A),
    "ASEAN": Color(0xB1ED2939),
    "AU": Color(0xB1C0A265),
    "Custom": Color(0xff0d1520),
    "ECOSOC": Color(0xB1D69D36),
    "EU": Color(0xFF003A94),
    "G20": Color(0xB1536A7D),
    "NATO": Color(0xB100247D),
    "UNGA": Color(0xB12486CD),
    "UNHCR": Color(0xB1736EB0),
    "UNHRC": Color(0xD71971B1),
    "UNICEF": Color(0xB14788C8),
    "UNSC": Color(0xB173C5FF),
    "WHO": Color(0xB10798FF),
  };

  late final AnimationController controller;
  bool isDeleting = false;

  @override
  void initState() {
    controller = AnimationController(
      lowerBound: 1,
      upperBound: 1.05,
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 100),
    )..addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String datePlaceholder(List<DateTime?> days) {
    for (int i = 0; i < days.length; i++) {
      if (DateTime.now().isAfter(days[i]!)) {
        if (DateTime.now().isBefore(days[i]!.add(const Duration(days: 1)))) {
          return "Continue Day ${i + 1}";
        }
      } else {
        return "Day ${i + 1} starts on ${days[i]!.dateFormat}";
      }
    }

    return "Ended on ${days.last!.dateFormat}";
  }

  @override
  Widget build(BuildContext context) {
    final double animationStatus = (controller.value - controller.lowerBound) /
        (controller.upperBound - controller.lowerBound);

    final bool showOptions =
        widget.committee.days.first!.isAfter(DateTime.now());

    return MouseRegion(
      onEnter: (_) => controller.forward(),
      onExit: (_) => controller.reverse(),
      child: Transform.scale(
        scale: controller.value,
        child: SizedBox(
          height: 180,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: isDeleting || widget.committee.lastDay == -1
                    ? null
                    : () {
                        final Route route = Router.modes.first;
                        final controller = Get.find<RouteController>();

                        controller.path = route.path;
                        controller.args = {"id": widget.committee.id};

                        context.go("${route.path}?id=${widget.committee.id}");
                      },
                child: Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: colors[widget.committee.type],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      if (controller.value > 1)
                        BoxShadow(
                          color: Colors.grey.shade300
                              .withValues(alpha: animationStatus),
                          offset: const Offset(2, 2),
                          blurRadius: 3,
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Positioned(
                          right: 100 * (controller.value) - 200,
                          child: Image.asset(
                            "logos/${widget.committee.type}.png",
                            height: 185,
                            opacity: const AlwaysStoppedAnimation(0.4),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.committee.name,
                                  style: context.textTheme.headlineSmall!
                                      .copyWith(color: Colors.white),
                                ),
                                Text(
                                  datePlaceholder(widget.committee.days),
                                  style: context.textTheme.bodyLarge!
                                      .copyWith(color: Colors.white),
                                ),
                                const Spacer(),
                                Text(
                                  widget.committee.type,
                                  style: context.textTheme.titleLarge!.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isDeleting)
                          Container(
                            width: 260,
                            height: 180,
                            color: Colors.white54,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (showOptions)
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  width: 50 * animationStatus,
                  height: 189 * animationStatus,
                  child: Opacity(
                    opacity: animationStatus,
                    child: _EditOptions(
                      committee: widget.committee,
                      onDelete: ({required status}) =>
                          setState(() => isDeleting = status),
                    ),
                  ),
                )
              else
                const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditOptions extends StatelessWidget {
  final Committee committee;
  final void Function({required bool status}) onDelete;

  const _EditOptions({required this.committee, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              hoverColor: Colors.transparent,
              onTap: () {
                const Route route = Router.setup;
                final controller = Get.find<RouteController>();

                controller.path = route.path;
                controller.args = {"id": committee.id};

                context.push("${route.path}?id=${committee.id}");
              },
              child: const Icon(Icons.edit, size: 26),
            ),
            Divider(
              color: Colors.grey.shade400,
            ),
            InkWell(
              hoverColor: Colors.transparent,
              onTap: () async {
                onDelete(status: true);

                final AppController appController = Get.find<AppController>();

                appController.user!.deleteCommittee(committee);

                await CloudStorage.deleteCommittee(committee);
                onDelete(status: false);

                appController.update();
              },
              child: Icon(Icons.delete, color: Colors.red.shade400, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}
