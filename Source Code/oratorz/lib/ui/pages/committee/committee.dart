import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/models/router.dart';
import '/tools/controllers/comittee/committee.dart';
import './widgets/dialogs/roll_call.dart';

class CommitteeMainPage extends StatefulWidget {
  final Widget child;

  const CommitteeMainPage({super.key, required this.child});

  @override
  State<CommitteeMainPage> createState() => _CommitteeMainPageState();
}

class _CommitteeMainPageState extends State<CommitteeMainPage> {
  final CommitteeController controller = Get.find<CommitteeController>();

  @override
  Widget build(BuildContext context) {
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
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
                      ...List.generate(
                        AppRouter.tabs.length,
                        (index) {
                          final AppRoute route = AppRouter.tabs[index];

                          return Obx(
                            () => _SidebarTile(
                              title: route.title ?? "",
                              icon: route.icon,
                              onTap: () {
                                if (controller.tab == index) return;

                                context.go(
                                  "${route.path}?id=${controller.committee.id}",
                                );

                                controller.tab = index;
                              },
                              selected: controller.tab == index,
                            ),
                          );
                        },
                      ),
                      _SidebarTile(
                        title: "Roll Call",
                        icon: Icons.fact_check_outlined,
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => const RollCallDialog(),
                        ),
                      ),
                      const Spacer(),
                      _SidebarTile(
                        title: "Home",
                        icon: Icons.home,
                        onTap: () {
                          Get.deleteAll();
                          context.pushReplacement(AppRouter.home.path);
                        },
                      ),
                      const OratorzSection(),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OratorzSection extends StatelessWidget {
  const OratorzSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              height: 32,
              width: 32,
              "images/Logo.svg",
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "Oratorz",
                style: context.textTheme.headlineSmall!
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        Text(
          "A Unit of Solvrz Inc.",
          style: context.textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Function() onTap;
  final bool selected;

  const _SidebarTile({
    required this.title,
    required this.onTap,
    this.icon,
    this.selected = false,
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          leading: Icon(icon, color: Colors.white, size: 24),
          title: Text(
            title,
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
