import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/config/constants/data.dart';
import '/tools/controllers/setup.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';
import './upload_file_dialog.dart';

class LoadCommitteeCard extends StatelessWidget {
  const LoadCommitteeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Load Committee",
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: RoundedButton(
                    style: RoundedButtonStyle.border,
                    color: Colors.amber.shade400,
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 8,
                    ),
                    child: Text(
                      "From File",
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: Colors.amber.shade400,
                      ),
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => const UploadFileDialog(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: RoundedButton(
                    style: RoundedButtonStyle.border,
                    color: Colors.amber.shade400,
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 8,
                    ),
                    child: Text(
                      "From Template",
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: Colors.amber.shade400,
                      ),
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => const _TemplateDialog(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateDialog extends StatelessWidget {
  const _TemplateDialog();

  @override
  Widget build(BuildContext context) {
    final List<String> templates = COMMITTEES.keys.toList();
    final SetupController controller = Get.find<SetupController>();

    return DialogBox(
      heading: "Select Template",
      content: SizedBox(
        height: context.height / 2,
        width: context.width / 2.5,
        child: ListView.separated(
          itemCount: COMMITTEES.length,
          itemBuilder: (_, index) {
            final String template = templates[index];

            return ListTile(
              onTap: () {
                controller.fromTemplate(template);
                controller.update();

                context.pop();
              },
              title: Text(
                "$template (${COMMITTEES[template]!.length})",
                style: context.textTheme.bodyLarge,
              ),
            );
          },
          separatorBuilder: (_, __) => Divider(
            height: 2,
            color: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
