import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/setup.dart';
import '/ui/widgets/rounded_button.dart';

class MembersCard extends StatelessWidget {
  const MembersCard({super.key});

  @override
  Widget build(BuildContext context) {
    final SetupController controller = Get.find<SetupController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Set Members",
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: GetBuilder<SetupController>(
                  builder: (controller) => Column(
                    children: List.generate(
                      controller.committee.members.length,
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
                            Expanded(
                              child: TextField(
                                enabled: index != 0,
                                controller: TextEditingController(
                                  text: controller.committee.members[index],
                                ),
                                onChanged: (value) =>
                                    controller.committee.members[index] = value,
                                decoration: const InputDecoration(
                                  hintText: "Member's Email",
                                  border: UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(),
                                  fillColor: Colors.white,
                                  hoverColor: Colors.transparent,
                                  isDense: true,
                                ),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            const SizedBox(width: 24),
                            if (index != 0)
                              RoundedButton(
                                onPressed: () {
                                  controller.committee.members.removeAt(index);
                                  controller.update();
                                },
                                padding: EdgeInsets.zero,
                                tooltip: "Remove Member",
                                color: Colors.red.shade400,
                                child: const Icon(Icons.remove),
                              ),
                            const SizedBox(width: 12),
                            if (index != 0)
                              RoundedButton(
                                onPressed: () {
                                  controller.committee.members.removeAt(index);
                                  controller.update();
                                },
                                padding: EdgeInsets.zero,
                                tooltip: "Send Mail to Member",
                                color: Colors.grey.shade800,
                                child: const Icon(Icons.send),
                              ),
                          ],
                        ),
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
              onPressed: () {
                controller.committee.members.add("");
                controller.update();
              },
              child: Text(
                "+ Add a new Member",
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
