import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    "images/home-banner-2.png",
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
              padding: const EdgeInsets.all(16),
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
                                  "images/Logo.png",
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
                        Row(
                          children: [
                            const CommitteeCard(code: "UNGA"),
                            const SizedBox(width: 24),
                            const CommitteeCard(code: "AIPPM"),
                            const SizedBox(width: 24),
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
                                      style:
                                          context.textTheme.headline6!.copyWith(
                                        color: Colors.grey.shade500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CommitteeCard extends StatelessWidget {
  const CommitteeCard({
    Key? key,
    required this.code,
  }) : super(key: key);

  final String code;

  static const Map<String, Color> colors = {
    "UNGA": Color.fromRGBO(46, 135, 200, 0.7),
    "AIPPM": Color.fromRGBO(233, 55, 10, 0.7),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 260,
      decoration: BoxDecoration(
        color: colors[code],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned(
            right: -100,
            child: Image.asset(
              "logos/$code.png",
              height: 210,
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
                    code,
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
    );
  }
}
