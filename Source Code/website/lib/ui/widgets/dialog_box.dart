import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class DialogBox extends StatelessWidget {
  final String heading;
  final Widget? content;
  final List<Widget>? actions;
  final MainAxisAlignment? actionsAlignment;
  final bool barrierDismissible;

  const DialogBox({
    super.key,
    required this.heading,
    this.content,
    this.actions,
    this.actionsAlignment,
    this.barrierDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: actionsAlignment,
      actionsPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                heading,
                style: context.textTheme.headlineSmall,
              ),
              if (barrierDismissible) ...[
                const SizedBox(width: 24),
                const Spacer(),
                InkWell(
                  onTap: () => context.pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.close,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Divider(height: 2, color: Colors.grey.shade400),
        ],
      ),
      content: content,
      actions: actions,
    );
  }
}
