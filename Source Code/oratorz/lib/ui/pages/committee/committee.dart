import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final int mode;
  final int tab;

  const CommitteeMainPage({super.key, this.mode = 0, this.tab = 0});

  @override
  State<CommitteeMainPage> createState() => _CommitteeMainPageState();
}

class _CommitteeMainPageState extends State<CommitteeMainPage> {
  late final String id;
  late final CommitteeController controller;

  @override
  void initState() {
    super.initState();

    final RouteController routeController = Get.find<RouteController>();

    if (routeController.args['id'] != null) {
      id = routeController.args['id']!;

      if (!Get.isRegistered<CommitteeController>()) {
        LocalStorage.loadCommittee(routeController.args['id']!);
      }

      analytics.logEvent(name: "committe_loaded");

      controller = Get.find<CommitteeController>()..tab = widget.tab;
    } else {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => context.pushReplacement("/home"));

      return;
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
                        style: context.textTheme.displayMedium!
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
                                  "${controller.currentTabDetails["route"]}?id=$id",
                                );
                              } else {
                                tab["onTap"]();
                                return;
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
                            child: SvgPicture.asset(
                              height: 35,
                              width: 35,
                              "images/Logo.svg",
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Oratorz",
                            style: context.textTheme.headlineSmall!
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Text(
                        "A Unit of Solvrz Inc.",
                        style: context.textTheme.bodyLarge!
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
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
