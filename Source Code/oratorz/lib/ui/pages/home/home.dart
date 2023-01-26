import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> committees = [
      "AU",
      "UNGA",
      "Custom",
    ];

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: context.mediaQuerySize.width,
              height: context.mediaQuerySize.height / 9,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "images/home-banner.png",
                  ),
                  repeat: ImageRepeat.repeatX,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3),
                child: const Text(""),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      width: context.mediaQuerySize.width / 6,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade800,
                            child: Icon(
                              Icons.person,
                              color: Colors.grey[400],
                              size: 42,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Welcome Back,",
                            style: context.textTheme.bodyText1!
                                .copyWith(fontSize: 14),
                          ),
                          Text(
                            "Taylor Simora",
                            style: context.textTheme.headline6!
                                .copyWith(fontSize: 21),
                          ),
                          const Spacer(),
                          ListTile(
                            onTap: () {},
                            horizontalTitleGap: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: const Icon(
                              Icons.settings,
                              color: Color(0xff2a313b),
                            ),
                            title: Text(
                              "Settings",
                              style: context.textTheme.bodyText1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            onTap: () {},
                            horizontalTitleGap: 8,
                            hoverColor: Colors.white12,
                            tileColor: const Color(0xff2a313b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Log Out",
                              style: context.textTheme.bodyText2
                                  ?.copyWith(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: context.mediaQuerySize.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      height: 35,
                                      width: 35,
                                      "images/Logo-Dark.png",
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Oratorz",
                                      style: context.textTheme.headline5,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                "Your Committees",
                                style: context.textTheme.headline5,
                              ),
                            ),
                            Wrap(
                              spacing: 24,
                              runSpacing: 18,
                              children: [
                                ...List.generate(
                                  committees.length,
                                  (index) =>
                                      CommitteeCard(code: committees[index]),
                                ),
                                InkWell(
                                  onTap: () => context.push("/setup"),
                                  child: DottedBorder(
                                    strokeWidth: 3,
                                    dashPattern: const [10, 4],
                                    borderType: BorderType.RRect,
                                    color: Colors.grey.shade500,
                                    radius: const Radius.circular(10),
                                    child: SizedBox(
                                      height: 174,
                                      width: 150,
                                      child: Center(
                                        child: Text(
                                          "Start a New Committee",
                                          style: context.textTheme.headline6!
                                              .copyWith(
                                            color: Colors.grey.shade500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CommitteeCard extends StatefulWidget {
  const CommitteeCard({
    Key? key,
    required this.code,
  }) : super(key: key);

  final String code;

  @override
  State<CommitteeCard> createState() => _CommitteeCardState();
}

class _CommitteeCardState extends State<CommitteeCard> {
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

  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (val) => setState(() => hovering = val),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        height: 180 * (hovering ? 1.05 : 1),
        width: 260 * (hovering ? 1.05 : 1),
        decoration: BoxDecoration(
          color: colors[widget.code],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (hovering)
              BoxShadow(
                color: Colors.grey.shade300,
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
                right: -100,
                child: Image.asset(
                  "logos/${widget.code}.png",
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
                        widget.code,
                        style: context.textTheme.headline5!
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        "18 Delegates",
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
    );
  }
}
