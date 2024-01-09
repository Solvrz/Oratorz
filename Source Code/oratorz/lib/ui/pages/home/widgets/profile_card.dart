import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        width: context.mediaQuerySize.width / 6,
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade800,
              child: Icon(
                Icons.person,
                color: Colors.grey[400],
                size: 42,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Welcome Back,",
              style: context.textTheme.bodyLarge!.copyWith(fontSize: 14),
            ),
            Text(
              "User",
              style: context.textTheme.titleLarge!.copyWith(fontSize: 21),
            ),
            const Spacer(),
            ListTile(
              onTap: () {
                // TODO: Settings
              },
              horizontalTitleGap: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              leading: const Icon(
                Icons.settings,
                color: Color(0xff2a313b),
              ),
              title: Text(
                "Settings",
                style: context.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              onTap: () {
                // TODO: Log Out
              },
              horizontalTitleGap: 8,
              hoverColor: Colors.white12,
              tileColor: const Color(0xff2a313b),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: Text(
                "Log Out",
                style:
                    context.textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
