import 'package:advanced_navigator/advanced_navigator.dart';
import 'package:flutter/material.dart' hide TabController;
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

import '/tools/controllers/home.dart';
import '/tools/controllers/tabs.dart';
import './roll_call_dialog.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.find<HomeController>();
    final TabController _tabController = Get.find<TabController>();

    return SizedBox(
      width: MediaQuery.of(context).size.width / 8,
      child: Card(
        margin: EdgeInsets.zero,
        color: const Color(0xff0d1520),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            children: [
              Text(
                _homeController.committee.value.name,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ...List.generate(_tabController.tabs.length, (index) {
                final Map<String, dynamic> _tab = _tabController.tabs[index];

                return Obx(
                  () => _Tile(
                    title: _tab["title"],
                    icon: _tab["icon"],
                    onTap: () {
                      _tabController.tabVal = index;
                      html.window.history.pushState(
                        null,
                        "tab",
                        _tabController.tabs[index]["route"],
                      );
                    },
                    selected: _tabController.tabVal == index,
                    iconColor: _tab["color"],
                  ),
                );
              }),

              _Tile(
                title: "Roll Call",
                icon: Icons.fact_check_outlined,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => const RollCallDialog(),
                ),
              ),
              const Spacer(),
              _Tile(
                title: "Setup",
                icon: Icons.settings_outlined,
                onTap: () => AdvancedNavigator.openNamed(context, "/setup"),
              ),
              // _Tile(
              //   title: "Log Out",
              //   icon: Icons.power_settings_new,
              //   iconColor: Colors.redAccent,
              //   onTap: () => Auth.logout(
              //     context,
              //     () => AdvancedNavigator.openNamed(context, "/"),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;
  final bool selected;
  final Color? iconColor;

  const _Tile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.selected = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          horizontalTitleGap: 8,
          onTap: onTap,
          hoverColor: selected ? Colors.transparent : Colors.white12,
          tileColor:
              selected ? const Color(0xff2a313b) : const Color(0xff0d1520),
          leading: Icon(icon, color: iconColor ?? Colors.white, size: 24),
          title: Text(title, style: Theme.of(context).textTheme.bodyText2),
        ),
      );
}
