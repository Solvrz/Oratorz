import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/app.dart';
import '/tools/functions.dart';
import '/ui/widgets/input_field.dart';
import '/ui/widgets/rounded_button.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account",
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          const Text("Manage your profile"),
          Divider(
            height: 48,
            color: Colors.grey.shade300,
          ),
          Row(
            children: [
              //FIXME: Hero widget not working
              Hero(
                tag: "profile",
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade800,
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[400],
                    size: 42,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile Picture",
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "PNG, JPG upto 5MB",
                    style: context.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  OutlinedButton(
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                      padding: WidgetStateProperty.all(
                        EdgeInsets.zero,
                      ),
                      side: WidgetStateProperty.all(
                        BorderSide.none,
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Update",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.amber.shade400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // Hero(
              //   tag: "name",
              //   child: Text(
              //     FirebaseAuth.instance.currentUser!.displayName!,
              //     style: context.textTheme.bodyLarge,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 36),
          Text(
            "Details",
            style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InputField(
                  padding: EdgeInsets.zero,
                  hintText: "First Name",
                  text: controller.user!.firstName.obs,
                  error: "".obs,
                  textInputType: TextInputType.name,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: InputField(
                  padding: EdgeInsets.zero,
                  hintText: "Last Name",
                  text: controller.user!.lastName.obs,
                  error: "".obs,
                  textInputType: TextInputType.name,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Text(
                  "Role: ",
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  child: DropdownButton(
                    value: 0,
                    borderRadius: BorderRadius.circular(16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    underline: const SizedBox(),
                    focusColor: Colors.transparent,
                    iconEnabledColor: Colors.grey.shade400,
                    items: const [
                      DropdownMenuItem(value: 0, child: Text("Option 1")),
                      DropdownMenuItem(value: 1, child: Text("Option 2")),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const Spacer(),
                RoundedButton(
                  onPressed: () {},
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
          Divider(
            height: 48,
            color: Colors.grey.shade300,
          ),
          Text(
            "Authentication",
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.sendPasswordResetEmail(
                email: FirebaseAuth.instance.currentUser!.email!,
              );

              if (context.mounted) {
                snackbar(
                  context,
                  const Center(
                    child: Text(
                      "A password reset link has been sent to your email",
                    ),
                  ),
                );
              }
            },
            child: const Text("Reset Password"),
          ),
        ],
      ),
    );
  }
}
