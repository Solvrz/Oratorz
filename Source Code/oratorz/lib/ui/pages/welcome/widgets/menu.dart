import 'package:flutter/material.dart';

import '/ui/widgets/round_button.dart';

class Menu extends StatelessWidget {
  final bool isSignIn;
  final void Function(bool signIn) setSignIn;

  const Menu({
    super.key,
    required this.isSignIn,
    required this.setSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              _Item(title: "About us"),
              _Item(title: "Contact us"),
              _Item(title: "Help"),
            ],
          ),
          Row(
            children: [
              isSignIn
                  ? _Item(title: "Sign In", active: isSignIn)
                  : const RoundButton(title: "Sign In"),
              !isSignIn
                  ? _Item(title: "Register", active: !isSignIn)
                  : const RoundButton(title: "Register"),
            ],
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String title;
  final bool active;

  const _Item({
    required this.title,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 75),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active ? Colors.deepPurple : Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            if (active)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(30),
                ),
              )
            else
              const SizedBox()
          ],
        ),
      ),
    );
  }
}
