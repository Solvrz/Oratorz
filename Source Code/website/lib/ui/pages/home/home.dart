import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './widgets/committees_section.dart';
import './widgets/profile_card.dart';
import '/tools/controllers/home.dart';
import '/ui/widgets/oratorz_banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<HomeController>(HomeController());

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: context.mediaQuerySize.width,
              height: context.mediaQuerySize.height / 9,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/Banner.png"),
                  repeat: ImageRepeat.repeatX,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3),
                child: const Text(""),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileCard(),
                  SizedBox(width: 60),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OratorzBanner(),
                        SizedBox(height: 30),
                        CommitteesSection(),
                      ],
                    ),
                  ),
                  SizedBox(width: 44),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
