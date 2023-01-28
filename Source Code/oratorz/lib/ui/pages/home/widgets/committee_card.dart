import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';

import '/models/committee.dart';
import '/services/local_storage.dart';

class CommitteeCard extends StatefulWidget {
  const CommitteeCard({
    Key? key,
    required this.committee,
  }) : super(key: key);

  final Committee committee;

  @override
  State<CommitteeCard> createState() => _CommitteeCardState();
}

class _CommitteeCardState extends State<CommitteeCard>
    with SingleTickerProviderStateMixin {
  final Map<String, Color> colors = {
    "AIPPM": const Color.fromRGBO(233, 55, 10, 0.7),
    "ASEAN": const Color.fromRGBO(237, 41, 57, 0.7),
    "AU": const Color.fromRGBO(192, 162, 101, 0.7),
    "ECOSOC": const Color.fromRGBO(214, 157, 54, 0.7),
    "EU": const Color.fromRGBO(0, 58, 148, 1),
    "G20": const Color.fromRGBO(83, 106, 125, 0.7),
    "NATO": const Color.fromRGBO(0, 36, 125, 0.7),
    "UNGA": const Color.fromRGBO(36, 134, 205, 0.7),
    "UNHCR": const Color.fromRGBO(115, 110, 176, 0.7),
    "UNHRC": const Color.fromRGBO(25, 113, 177, 0.85),
    "UNICEF": const Color.fromRGBO(71, 136, 200, 0.7),
    "UNSC": const Color.fromRGBO(115, 197, 255, 0.7),
    "WHO": const Color.fromRGBO(7, 152, 255, 0.7),
    "Custom": const Color(0xff0d1520),
  };

  late final AnimationController controller;

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

  @override
  Widget build(BuildContext context) {
    final double animationStatus = (controller.value - controller.lowerBound) /
        (controller.upperBound - controller.lowerBound);

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
                onTap: () {
                  LocalStorage.loadCommittee(widget.committee.id);

                  context.pushReplacement("/committee/gsl");
                },
                child: Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: colors[widget.committee.type],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      if (controller.value > 1)
                        BoxShadow(
                          color:
                              Colors.grey.shade300.withOpacity(animationStatus),
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
                                  widget.committee.type,
                                  style: context.textTheme.headline5!
                                      .copyWith(color: Colors.white),
                                ),
                                Text(
                                  "${widget.committee.delegates.length} Delegates",
                                  style: context.textTheme.bodyText1!
                                      .copyWith(color: Colors.white),
                                ),
                                const Spacer(),
                                Text(
                                  "CCS MUN",
                                  style: context.textTheme.headline6!
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 12),
                width: 50 * animationStatus,
                height: 189 * animationStatus,
                child: Opacity(
                  opacity: animationStatus,
                  child: _EditOptions(id: widget.committee.id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditOptions extends StatelessWidget {
  const _EditOptions({Key? key, required this.id}) : super(key: key);

  final String id;

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
              onTap: () {},
              child: const Icon(Icons.edit, size: 26),
            ),
            Divider(
              color: Colors.grey.shade400,
            ),
            InkWell(
              hoverColor: Colors.transparent,
              onTap: () {},
              child: const Icon(Icons.star_border, size: 26),
            ),
            Divider(
              color: Colors.grey.shade400,
            ),
            InkWell(
              hoverColor: Colors.transparent,
              onTap: () => LocalStorage.deleteCommittee(id),
              child: Icon(Icons.delete, color: Colors.red.shade400, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}
