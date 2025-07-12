import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/widgets/rounded_button.dart';

class MembersCard extends StatefulWidget {
  const MembersCard({super.key});

  @override
  State<MembersCard> createState() => _MembersCardState();
}

class _MembersCardState extends State<MembersCard> {
  List<String> members = [""];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: context.mediaQuerySize.height / 3,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Set EB Members",
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    members.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade800,
                            foregroundColor: Colors.grey.shade400,
                            child: Text("${index + 1}"),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Member's Email",
                                border: UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(),
                                fillColor: Colors.white,
                                hoverColor: Colors.transparent,
                                isDense: true,
                              ),
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 24),
                          RoundedButton(
                            onPressed: () =>
                                setState(() => members.removeAt(index)),
                            padding: EdgeInsets.zero,
                            tooltip: "Remove Member",
                            color: Colors.red.shade400,
                            child: const Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            RoundedButton(
              style: RoundedButtonStyle.border,
              color: Colors.amber.shade400,
              padding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 8,
              ),
              onPressed: () => setState(() => members.add("")),
              child: Text(
                "+ Add a new EB Member",
                style: context.textTheme.bodyLarge?.copyWith(
                  color: Colors.amber.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
