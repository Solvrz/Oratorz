import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  final String title;

  const DialogTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(width: 24),
            const Spacer(),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.all(8),
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
    );
  }
}
