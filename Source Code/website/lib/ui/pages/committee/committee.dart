import 'package:flutter/material.dart' hide Router, Route;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/models/router.dart';
import '/services/cloud_storage.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/route.dart';
import '/tools/functions.dart';
import './widgets/dialogs/roll_call.dart';

class CommitteePage extends StatefulWidget {
  final Widget child;

  const CommitteePage({super.key, required this.child});

  @override
  State<CommitteePage> createState() => _CommitteePageState();
}

class _CommitteePageState extends State<CommitteePage> {
  @override
  void dispose() {
    Get.delete<CommitteeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RouteController routeController = Get.find<RouteController>();

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: CloudStorage.fetchCommittee(routeController.args["id"]),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              if (snapshot.connectionState == ConnectionState.done) {
                context.pushReplacement(Router.home.path);

                WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) => snackbar(
                    context,
                    const Center(
                      child: Text(
                        "Either the committee with the given ID doesn't exist or you don't have the sufficient rights to access it.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }

              return const Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    color: Color(0xff2a313b),
                  ),
                ),
              );
            }

            final CommitteeController controller =
                Get.find<CommitteeController>();

            return Row(
              children: [
                SizedBox(
                  width: context.width / 8,
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: const Color(0xFF0F1825),
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
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              controller.committee.name,
                              style: context.textTheme.displayMedium!
                                  .copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 32),
                          ...List.generate(
                            Router.tabs.length,
                            (index) {
                              final Route route = Router.tabs[index];

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
                            onTap: () =>
                                context.pushReplacement(Router.home.path),
                          ),
                          const SizedBox(height: 20),
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
            );
          },
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
            // TODO: Change color to white
            SvgPicture.asset("images/Logo.svg", height: 32, width: 32),
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
