import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/arguments/committee.dart';
import '/config/country_info.dart';
import '/models/committee.dart';
import '../../../controllers/committee.dart';
import 'tabs/export.dart';
import 'widgets/tab_tile.dart';

class PageController extends GetxController {
  RxInt page = 0.obs;

  List<Map<String, dynamic>> pagesInfo = [
    {'name': 'GSL', 'icon': Icons.groups, 'page': const GSLPage()},
    {'name': 'Motions', 'icon': Icons.ballot, 'page': const MotionsPage()},
    {'name': 'Mod', 'icon': Icons.forum, 'page': const ModPage()},
    {
      'name': 'Unmod',
      'icon': Icons.connect_without_contact,
      'page': const UnmodPage()
    },
    {'name': 'Vote', 'icon': Icons.flaky, 'page': const VotePage()},
    // TODO: Will Design Page Later On
    // {
    //   'name': 'Roll Call',
    //   'icon': Icons.fact_check,
    //   'page': const RollCallPage()
    // },
  ];

  void changePage(int newPage) => page.value = newPage;
}

class CommitteePage extends StatefulWidget {
  const CommitteePage({super.key});

  @override
  State<CommitteePage> createState() => _CommitteePageState();
}

class _CommitteePageState extends State<CommitteePage> {
  final PageController pageController = Get.put(PageController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Sidebar(),
            Expanded(
              child: Obx(
                () =>
                    pageController.pagesInfo[pageController.page.value]["page"],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final PageController pageController = Get.find<PageController>();
  late final CommitteeController committeeController;

  @override
  Widget build(BuildContext context) {
    // final CommitteeArguments args =
    //     ModalRoute.of(context)!.settings.arguments! as CommitteeArguments;

    // TODO: Remove after testing
    final CommitteeArguments args = CommitteeArguments(
      committee: Committee(
        name: "Testing Committee",
        countries: COMMITTEES["UNSC"],
      ),
    );

    committeeController =
        Get.put(CommitteeController(committee: args.committee));

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
                args.committee.name,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Obx(
                  () => Column(
                    children: List.generate(
                      pageController.pagesInfo.length,
                      (index) => TabTile(
                        title: pageController.pagesInfo[index]["name"],
                        icon: pageController.pagesInfo[index]["icon"],
                        onTap: () => pageController.changePage(index),
                        selected: pageController.page.value == index,
                      ),
                    ),
                  ),
                ),
              ),
              TabTile(
                title: "Roll Call",
                icon: Icons.fact_check,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => takeRollCall(context, args),
                ),
              ),
              const Spacer(),
              TabTile(
                title: "Home",
                icon: Icons.home,
                onTap: () => Navigator.popAndPushNamed(context, "/home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
