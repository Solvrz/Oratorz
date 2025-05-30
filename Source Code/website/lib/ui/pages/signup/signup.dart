import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/input_field.dart';
import '../../widgets/oratorz_banner.dart';
import '../../widgets/password_field.dart';
import '../../widgets/rounded_button.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                                  onPressed: () {},
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
                                  children: [
                                    Expanded(
                                      child: InputField(
                                        hintText: "First Name",
                                        textInputType: TextInputType.name,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: InputField(
                                        hintText: "Last Name",
                                        textInputType: TextInputType.name,
                                      ),
                                    ),
                                  ],
                                ),
                                InputField(hintText: "Email"),
                                PasswordField(),
                              ],
                            ),
                            const SizedBox(height: 24),
                            RoundedButton(
                              color: context.theme.colorScheme.tertiary,
                              onPressed: () {},
                              child: const Text("Sign Up"),
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
