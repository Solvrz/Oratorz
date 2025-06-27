import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';

import '/services/auth.dart';
import '/tools/functions.dart';

class ProfileCard extends StatelessWidget {
  final bool isHome;

  const ProfileCard({super.key, required this.isHome});

  Widget _tile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Function onTap,
  }) {
    return ListTile(
      onTap: () => onTap(),
      horizontalTitleGap: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      leading: Icon(
        icon,
        color: const Color(0xff2a313b),
      ),
      title: Text(
        title,
        style: context.textTheme.bodyLarge,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        width: context.mediaQuerySize.width / 6,
        child: Column(
          children: [
            //FIXME: Fix Hero widget animation
            if (isHome) ...[
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
              const SizedBox(height: 16),
              Text(
                "Welcome Back,",
                style: context.textTheme.bodyLarge!.copyWith(fontSize: 14),
              ),
              Hero(
                tag: "name",
                child: Text(
                  FirebaseAuth.instance.currentUser!.displayName!,
                  style: context.textTheme.titleLarge!.copyWith(fontSize: 21),
                ),
              ),
            ] else
              _tile(
                context: context,
                icon: Icons.home_work,
                title: "Home",
                onTap: () => context.push("/home"),
              ),
            const Spacer(),
            if (isHome)
              _tile(
                context: context,
                icon: Icons.settings,
                title: "Settings",
                onTap: () => context.push("/settings"),
              ),
            _tile(
              context: context,
              icon: Icons.help,
              title: "Help",
              onTap: () => snackbar(
                context,
                const Center(
                  child: Text(
                    "This feature is under devlopent. Please try again later...",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              onTap: () => Auth.signout(context),
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
                "Sign Out",
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
