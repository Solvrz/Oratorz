import 'package:flutter/material.dart' hide Router;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/models/router.dart';
import '/services/auth.dart';
import '/tools/controllers/signup.dart';
import '/ui/widgets/input_field.dart';
import '/ui/widgets/oratorz_banner.dart';
import '/ui/widgets/password_field.dart';
import '/ui/widgets/rounded_button.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  bool handleErrors(SignUpController controller) {
    bool success = true;

    if (controller.firstName.value == "") {
      controller.errors["firstName"]!.value = "Required";
      success = false;
    } else if (!RegExp(r'^([a-z]|[A-Z])+$')
        .hasMatch(controller.firstName.value)) {
      controller.errors["firstName"]!.value = "Enter a valid name";
      success = false;
    } else {
      controller.errors["firstName"]!.value = "";
    }

    if (controller.lastName.value == "") {
      controller.errors["lastName"]!.value = "Required";
      success = false;
    } else if (!RegExp(r'^([a-z]|[A-Z])+$')
        .hasMatch(controller.lastName.value)) {
      controller.errors["lastName"]!.value = "Enter a valid name";
      success = false;
    } else {
      controller.errors["lastName"]!.value = "";
    }

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
    if (!Get.isRegistered<SignUpController>()) {
      Get.put<SignUpController>(SignUpController());
    }

    final SignUpController controller = Get.find<SignUpController>();

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
                              "Get Started Now!",
                              style: context.textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text("Have an account? "),
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
                                    context.pushReplacement(Router.signin.path);
                                    controller.dispose();
                                  },
                                  child: Text(
                                    "Sign In",
                                    style:
                                        context.textTheme.bodyMedium?.copyWith(
                                      color: context.theme.colorScheme.tertiary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 60),
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: InputField(
                                        hintText: "First Name",
                                        text: controller.firstName,
                                        error: controller.errors["firstName"]!,
                                        textInputType: TextInputType.name,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: InputField(
                                        hintText: "Last Name",
                                        text: controller.lastName,
                                        error: controller.errors["lastName"]!,
                                        textInputType: TextInputType.name,
                                      ),
                                    ),
                                  ],
                                ),
                                InputField(
                                  hintText: "Email",
                                  text: controller.email,
                                  error: controller.errors["email"]!,
                                ),
                                PasswordField(
                                  text: controller.password,
                                  error: controller.errors["password"]!,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Obx(
                              () => RoundedButton(
                                color: controller.status.value
                                    ? Colors.blueGrey
                                    : context.theme.colorScheme.tertiary,
                                onPressed: controller.status.value
                                    ? null
                                    : () async {
                                        bool success = handleErrors(controller);

                                        if (success) {
                                          controller.status.value = true;
                                          success = await Auth.signup(context);
                                          controller.status.value = false;

                                          //FIXME: Verify how to work around the async gap
                                          if (success && context.mounted) {
                                            context.pushReplacement(
                                              Router.home.path,
                                            );
                                            controller.dispose();
                                          }
                                        }
                                      },
                                child: const Text("Sign Up"),
                              ),
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
