import 'package:flutter/material.dart' hide Router;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../models/router.dart';
import '../../../tools/controllers/signin.dart';
import '../../widgets/input_field.dart';
import '../../widgets/oratorz_banner.dart';
import '../../widgets/password_field.dart';
import '../../widgets/rounded_button.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  bool handleErrors(SignInController controller) {
    bool success = true;

    if (controller.email.value == "") {
      controller.errors["email"]!.value = "Required";
      success = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(controller.email.value)) {
      // FIXME: Find a better email id checker
      controller.errors["email"]!.value = "Enter a valid email address";
      success = false;
    } else {
      controller.errors["email"]!.value = "";
    }

    if (controller.password.value == "") {
      controller.errors["password"]!.value = "Required";
      success = false;
    } else if (!RegExp(
      r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{6,}$',
    ).hasMatch(controller.password.value)) {
      controller.errors["password"]!.value =
          "Use atleast 1 digit, 1 special character and min. 6 characters in total";
      success = false;
    } else {
      controller.errors["password"]!.value = "";
    }

    return success;
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SignInController>()) {
      Get.put<SignInController>(SignInController());
    }

    final SignInController controller = Get.find<SignInController>();

    return SafeArea(
      child: Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OratorzBanner(isSmall: true, elevation: 0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 104,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Spacer(),
                            Text(
                              "Welcome Back!",
                              style: context.textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text("No account? "),
                                OutlinedButton(
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                      EdgeInsets.zero,
                                    ),
                                    side: WidgetStateProperty.all(
                                      BorderSide.none,
                                    ),
                                  ),
                                  onPressed: () {
                                    context.pushReplacement(Router.signup.path);
                                    controller.dispose();
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style:
                                        context.textTheme.bodyMedium?.copyWith(
                                      color: context.theme.colorScheme.tertiary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 60),
                            InputField(
                              hintText: "Email",
                              text: controller.email,
                              error: controller.errors["email"]!,
                            ),
                            PasswordField(
                              text: controller.password,
                              error: controller.errors["password"]!,
                            ),
                            const SizedBox(height: 24),
                            RoundedButton(
                              color: context.theme.colorScheme.tertiary,
                              onPressed: () {
                                final bool success = handleErrors(controller);

                                if (success) {
                                  context.pushReplacement(Router.home.path);
                                  controller.dispose();
                                }
                              },
                              child: const Text("Sign In"),
                            ),
                            const Spacer(),
                            const Center(
                              child: Text("2025 Solvrz, All Rights Reserved"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Image.asset(
                "images/Login2.png",
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
