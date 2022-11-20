import 'package:flutter/material.dart' hide TabController;
import 'package:get/get.dart';

import '/services/auth.dart';
import '/tools/arguments/home.dart';
import '/tools/controllers/tab.dart';
import './roll_call_dialog.dart';

class Sidebar extends StatefulWidget {
  final HomeArguments? args;

  const Sidebar({
    required this.args,
    super.key,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final TabController _tabController = Get.put(TabController());

  @override
  Widget build(BuildContext context) {
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
                widget.args?.committee.name ?? "Your Committee",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _Tile(
                title: "Home",
                icon: Icons.home_outlined,
                onTap: () => Navigator.popAndPushNamed(context, "/home"),
              ),
              // TODO: Remove from Dropdown & Use /home/motion
              _Tile(
                title: "Motions",
                icon: Icons.ballot_outlined,
                onTap: () => _tabController.tabVal = 1,
              ),
              _Tile(
                title: "Roll Call",
                icon: Icons.fact_check_outlined,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) {
                    return RollCallDialog(args: widget.args);
                  },
                ),
              ),
              const Spacer(),
              // TODO: Log Out
              _Tile(
                title: "Setup",
                icon: Icons.settings_outlined,
                onTap: () => Auth.logout(
                  context,
                  () => Navigator.popAndPushNamed(context, "/setup"),
                ),
              ),
              // _Tile(
              //   title: "Log Out",
              //   icon: Icons.power_settings_new,
              //   iconColor: Colors.redAccent,
              //   onTap: () => Auth.logout(
              //     context,
              //     () => Navigator.popAndPushNamed(context, "/"),
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
  final Color? iconColor;

  const _Tile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        horizontalTitleGap: 8,
        onTap: onTap,
        hoverColor: Colors.white12,
        tileColor: const Color(0xff0d1520),
        leading: Icon(icon, color: iconColor ?? Colors.white, size: 24),
        title: Text(title, style: Theme.of(context).textTheme.bodyText2),
      ),
    );
  }
}
