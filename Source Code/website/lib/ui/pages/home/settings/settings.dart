import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/pages/home/widgets/profile_card.dart';
import '/ui/widgets/oratorz_banner.dart';
import 'settings_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                  ProfileCard(isHome: false),
                  SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OratorzBanner(),
                        SizedBox(height: 30),
                        Expanded(
                          child: SettingsSection(),
                        ),
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
