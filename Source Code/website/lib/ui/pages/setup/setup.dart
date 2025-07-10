import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/models/committee.dart';
import '/services/local_storage.dart';
import '/tools/controllers/app.dart';
import '/tools/controllers/route.dart';
import '/tools/controllers/setup.dart';
import '/tools/functions.dart';
import '/ui/widgets/rounded_button.dart';
import 'delegates/delegates.dart';
import 'options/options.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  void dispose() {
    Get.delete<SetupController>();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.find<AppController>();
    final RouteController controller = Get.find<RouteController>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            "Setup Committee",
            style:
                context.textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          actions: [
            RoundedButton(
              child: const Text("Save"),
              onPressed: () {
                LocalStorage.saveSetup();

                snackbar(
                  context,
                  const Center(child: Text("Saved Successfully!")),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: appController.user!.fetchCommittee(controller.args["id"]),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff2a313b),
                ),
              );
            }

            if (!Get.isRegistered<SetupController>()) {
              final Committee? committee = LocalStorage.loadSetup();

              Get.put<SetupController>(
                SetupController(
                  committee: controller.args["id"] == null && committee != null
                      ? committee
                      : snapshot.data!,
                  editing: controller.args["id"] != null,
                ),
              );
            }

            return GetX<SetupController>(
              builder: (controller) => PageTransitionSwitcher(
                reverse: !controller.showOptions.value,
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (
                  child,
                  primaryAnimation,
                  secondaryAnimation,
                ) =>
                    FadeTransition(
                  opacity: primaryAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(primaryAnimation),
                    child: child,
                  ),
                ),
                child: controller.showOptions.value
                    ? const SetupOptionsPage()
                    : const SetupDelegatesPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
