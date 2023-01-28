import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_html/html.dart' as html;

import '/config/constants/committee.dart';
import '/config/constants/constants.dart';
import '/services/local_storage.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/route.dart';
import './widgets/dialogs/roll_call.dart';

class CommitteeMainPage extends StatefulWidget {
  const CommitteeMainPage({super.key});

  @override
  State<CommitteeMainPage> createState() => _CommitteeMainPageState();
}

class _CommitteeMainPageState extends State<CommitteeMainPage> {
  late final CommitteeController controller;

  @override
  void initState() {
    super.initState();

    if (LocalStorage.selectedCommittee != "") {
      analytics.logEvent(name: "committe_loaded");
      LocalStorage.loadCommittee(LocalStorage.selectedCommittee);

      controller = Get.find<CommitteeController>()
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
          .addPostFrameCallback((_) => context.pushReplacement("/home"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tabs = [
      ...COMMITTEE_TABS,
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
        "title": "Home",
        "icon": Icons.home,
        "onTap": () {
          LocalStorage.deselect();
          Get.deleteAll();

          context.pushReplacement("/home");
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
                        controller.committee.name,
                        style: context.textTheme.headline2!
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ...List.generate(tabs.length, (index) {
                        final Map<String, dynamic> tab = tabs[index];

                        if (tab["title"] == "Spacer") {
                          return const Spacer();
                        }

                        return Obx(
                          () => _SidebarTile(
                            title: tab["title"],
                            icon: tab["icon"],
                            onTap: () {
                              if (tab.containsKey("route")) {
                                controller.tab = index;

                                html.window.history.pushState(
                                  null,
                                  "tab",
                                  controller.currentTabDetails["route"],
                                );
                              } else {
                                tab["onTap"]();
                              }
                            },
                            selected: controller.tab == index,
                            iconColor: tab["color"],
                          ),
                        );
                      }),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              left: 15,
                              right: 5,
                            ),
                            child: Image.asset(
                              height: 35,
                              width: 35,
                              "images/Logo.png",
                            ),
                          ),
                          Text(
                            "Oratorz",
                            style: context.textTheme.headline5!
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Text(
                        "A Unit of Solvrz Inc.",
                        style: context.textTheme.bodyText1!
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(() => controller.currentTab),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Focus(
        canRequestFocus: false,
        descendantsAreFocusable: false,
        child: ListTile(
          onTap: onTap,
          horizontalTitleGap: 8,
          hoverColor: selected ? Colors.transparent : Colors.white12,
          tileColor:
              selected ? const Color(0xff2a313b) : const Color(0xff0d1520),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: Icon(icon, color: iconColor ?? Colors.white, size: 24),
          title: Text(
            title,
            style: context.textTheme.bodyText2?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
