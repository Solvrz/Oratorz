import 'package:flutter/material.dart' hide TabController;
import 'package:get/get.dart';

import '/config/constants.dart';
import '/models/committee.dart';
import '/tools/arguments/home.dart';
import '/tools/controllers/home.dart';
import '/tools/controllers/mode.dart';
import '/ui/widgets/dialog_title.dart';
import 'widgets/sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ModeController _tabController = Get.put(ModeController());
  final List<MapEntry<int, Map<String, dynamic>>> _tabs = [];

  @override
  void initState() {
    super.initState();

    // SchedulerBinding.instance.addPostFrameCallback(
    //   (_) {
    //     if (mounted) {
    //       final HomeArguments? args =
    //           ModalRoute.of(context)!.settings.arguments as HomeArguments?;

    //       if (args == null) {
    //         Navigator.popAndPushNamed(context, "/setup");
    //       } else {
    //         Get.put(HomeController(committee: args.committee));
    //       }
    //     }
    //   },
    // );

    _tabController.tabsInfo.asMap().entries.forEach((tab) {
      _tabs.add(tab);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Push to SetUp if Args Null
    // final HomeArguments args =
    //     ModalRoute.of(context)!.settings.arguments! as HomeArguments;

    final HomeArguments args =
        HomeArguments(committee: Committee.fromTemplate("UNSC"));

    Get.put(HomeController(committee: args.committee));

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Sidebar(args: args),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TabHeader(tabs: _tabs),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Obx(
                        () => _tabController.currentTab()["tab"],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabHeader extends StatefulWidget {
  final List<MapEntry<int, Map<String, dynamic>>> tabs;

  const TabHeader({
    super.key,
    required this.tabs,
  });

  @override
  State<TabHeader> createState() => _TabHeaderState();
}

class _TabHeaderState extends State<TabHeader> {
  String agenda = "Your Agenda";

  @override
  Widget build(BuildContext context) {
    final ModeController _tabController = Get.put(ModeController());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                text: "Agenda: ",
                style: Theme.of(context).textTheme.headline5,
                children: [
                  TextSpan(
                    text: agenda,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            InkWell(
              onTap: () {
                final TextEditingController controller =
                    TextEditingController(text: agenda);

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: const DialogTitle(title: "Set Committee Name"),
                    content: TextField(
                      autofocus: true,
                      controller: controller,
                      onSubmitted: (value) {
                        agenda = controller.text;
                        setState(() {});

                        Navigator.of(context).pop();
                      },
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.grey[600],
                      decoration: InputDecoration(
                        fillColor: Colors.grey[200],
                        hintText: "Agenda",
                      ),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    actionsPadding: const EdgeInsets.all(16),
                    actions: [
                      TextButton(
                        onPressed: () {
                          agenda = controller.text;
                          setState(() {});

                          Navigator.of(context).pop();
                        },
                        child: const Text("Select"),
                      )
                    ],
                  ),
                );
              },
              hoverColor: const Color.fromARGB(255, 250, 250, 250),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade400),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.amber.shade400,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        PopupMenuButton<int>(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xff0d1520)),
            ),
            child: Row(
              children: [
                Obx(
                  () => Row(
                    children: [
                      Icon(
                        _tabController.currentTab()["icon"],
                        color: theme.primaryColor,
                      ),
                      const VerticalDivider(),
                      Text(
                        _tabController.currentTab()["name"],
                        style: theme.textTheme.headline5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xff0d1520),
                  size: 36,
                ),
              ],
            ),
          ),
          itemBuilder: (_) => List.generate(
            widget.tabs.length,
            (index) {
              final MapEntry<int, Map<String, dynamic>> tab =
                  widget.tabs[index];

              return PopupMenuItem(
                value: tab.key,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          tab.value["icon"],
                          color: theme.primaryColor,
                        ),
                        const VerticalDivider(),
                        Text(tab.value["name"]),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          onSelected: (index) => _tabController.tabVal = index,
        ),
        // Row(children: [
        //   PieChart(
        //     dataMap: {"Present": controller.rollCall.},
        //     chartType: ChartType.ring,
        //     baseChartColor: Colors.grey[50]!.withOpacity(0.15),
        //     colorList: colorList,
        //     chartValuesOptions: ChartValuesOptions(
        //       showChartValuesInPercentage: true,
        //     ),
        //     totalValue: controller.rollCall.length,
        //   ),
        // ])
      ],
    );
  }
}
