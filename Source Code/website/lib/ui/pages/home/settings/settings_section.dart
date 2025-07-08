import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/functions.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile",
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              //FIXME: Hero widget not working
              Hero(
                tag: "profile",
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade800,
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[400],
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Hero(
                tag: "name",
                child: Text(
                  FirebaseAuth.instance.currentUser!.displayName!,
                  style: context.textTheme.bodyLarge,
                ),
              ),
            ],
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
