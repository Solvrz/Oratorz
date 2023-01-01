import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_html/html.dart' as html;

import '/config/constants/committee.dart';
import '/services/local_storage.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/route.dart';
import './export.dart';
import './widgets/dialogs/roll_call.dart';

class CommitteeMainPage extends StatefulWidget {
  const CommitteeMainPage({super.key});

  @override
  State<CommitteeMainPage> createState() => _CommitteeMainPageState();
}

class _CommitteeMainPageState extends State<CommitteeMainPage> {
  late final CommitteeController _committeeController;

  @override
  void initState() {
    super.initState();

    if (LocalStorage.committeeExists()) {
      LocalStorage.loadCommittee();

      _committeeController = Get.find<CommitteeController>()
        ..tab = COMMITTEE_TABS
            .indexWhere(
              (tab) => tab["route"]
                  .toString()
                  .contains(Get.find<RouteController>().path),
            )
            .clamp(0, double.infinity)
            .toInt();
    } else {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => context.pushReplacement("/setup"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tabs = [
      {
        "route": "/committee/gsl",
        "title": "Committee",
        "icon": Icons.groups_outlined,
        "tab": const CommitteePage(),
      },
      {
        "route": "/vote",
        "title": "Vote",
        "icon": Icons.how_to_vote,
        "tab": const VotePage(),
      },
      {
        "route": "/motions",
        "title": "Motions",
        "icon": Icons.ballot_outlined,
        "tab": const MotionsPage(),
      },
      {
        "title": "Roll Call",
        "icon": Icons.fact_check_outlined,
        "onTap": () => showDialog(
              context: context,
              builder: (context) => const RollCallDialog(),
            ),
      },
      {
        "title": "Spacer",
      },
      {
        "title": "Setup",
        "icon": Icons.settings_outlined,
        "onTap": () {
          Get.deleteAll();
          LocalStorage.clearData();

          context.pushReplacement("/setup");
        },
      },
    ];

    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: context.width / 8,
              child: Card(
                margin: EdgeInsets.zero,
                color: const Color(0xff0d1520),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Text(
                        _committeeController.committee.name,
                        style: context.textTheme.headline2!
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ...List.generate(tabs.length, (index) {
                        final Map<String, dynamic> _tab = tabs[index];

                        if (_tab["title"] == "Spacer") {
                          return const Spacer();
                        }

                        return Obx(
                          () => _SidebarTile(
                            title: _tab["title"],
                            icon: _tab["icon"],
                            onTap: () {
                              if (_tab.containsKey("route")) {
                                _committeeController.tab = index;
                                html.window.history.pushState(
                                  null,
                                  "tab",
                                  _committeeController
                                      .currentTabDetails["route"],
                                );
                              } else {
                                _tab["onTap"]();
                              }
                            },
                            selected: _committeeController.tab == index,
                            iconColor: _tab["color"],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Obx(
                  () => _committeeController.currentTab,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;
  final bool selected;
  final Color? iconColor;

  const _SidebarTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.selected = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: onTap,
        horizontalTitleGap: 8,
        hoverColor: selected ? Colors.transparent : Colors.white12,
        tileColor: selected ? const Color(0xff2a313b) : const Color(0xff0d1520),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Icon(icon, color: iconColor ?? Colors.white, size: 24),
        title: Text(
          title,
          style: context.textTheme.bodyText2?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
