import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogBox extends AlertDialog {
  final String heading;

  const DialogBox({
    super.key,
    super.content,
    super.actions,
    super.contentPadding,
    super.actionsPadding,
    super.actionsAlignment,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Column(
        children: [
          Row(
            children: [
              Text(
                heading,
                style: context.textTheme.headline5,
              ),
              const SizedBox(width: 24),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.pop(context),
                hoverColor: const Color.fromARGB(255, 250, 250, 250),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 2, color: Colors.grey[400]),
        ],
      ),
      content: content,
      actions: actions,
      contentPadding: contentPadding,
      actionsPadding: actionsPadding,
      actionsAlignment: actionsAlignment,
    );
  }
}
