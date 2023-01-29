import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';

import 'widgets/committees_section.dart';
import 'widgets/oratorz_card.dart';
import 'widgets/profile_card.dart';

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
                    "images/Banner.png",
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
                  const ProfileCard(),
                  const SizedBox(width: 60),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        OratorzCard(),
                        SizedBox(height: 30),
                        CommitteesSection(),
                      ],
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
