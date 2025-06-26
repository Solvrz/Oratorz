import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/services/auth.dart';
import '/tools/controllers/home.dart';
import '/ui/pages/home/widgets/profile_card.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/oratorz_banner.dart';
import './widgets/committees_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    if (!FirebaseAuth.instance.currentUser!.emailVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => DialogBox(
            barrierDismissible: false,
            heading: "Account Not Verified!",
            content: SizedBox(
              height: context.height / 2,
              width: context.width / 3.5,
              child: Column(
                children: [
                  const Spacer(),
                  Center(
                    child: Text(
                      "The account for '${FirebaseAuth.instance.currentUser!.email}' is not verified! Check your inbox for the verification email or log in to another account.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        EdgeInsets.zero,
                      ),
                      side: WidgetStateProperty.all(
                        BorderSide.none,
                      ),
                    ),
                    onPressed: () => FirebaseAuth.instance.currentUser!
                        .sendEmailVerification(),
                    child: Text(
                      "Resend Verification Email",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.theme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        EdgeInsets.zero,
                      ),
                      side: WidgetStateProperty.all(
                        BorderSide.none,
                      ),
                    ),
                    onPressed: () => Auth.signout(context),
                    child: Text(
                      "Log In to another account",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.theme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<HomeController>()) {
      Get.put<HomeController>(HomeController());
    }

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
                  SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OratorzBanner(),
                        SizedBox(height: 30),
                        Expanded(
                          child: SingleChildScrollView(
                            child: CommitteesSection(),
                          ),
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
