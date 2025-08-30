import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/data.dart';
import '/tools/controllers/setup.dart';
import '/tools/functions.dart';
import '/ui/widgets/rounded_button.dart';

class SetupDelegateTile extends StatefulWidget {
  final String delegate;
  final int index;

  const SetupDelegateTile({
    super.key,
    required this.delegate,
    required this.index,
  });

  @override
  State<SetupDelegateTile> createState() => _SetupDelegateTileState();
}

class _SetupDelegateTileState extends State<SetupDelegateTile> {
  bool hovering = false;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: ListTile(
        // onTap: () => setState(() => isExpanded = !isExpanded),
        leading: flag(widget.delegate),
        // subtitle: isExpanded
        //     ? const Row(
        //         children: [
        //           Text("Delegate E-mail:"),
        //           SizedBox(width: 12),
        //           Expanded(
        //             child: TextField(
        //               decoration: InputDecoration(
        //                 border: UnderlineInputBorder(),
        //                 focusedBorder: UnderlineInputBorder(),
        //                 fillColor: Colors.white,
        //                 hoverColor: Colors.transparent,
        //                 isDense: true,
        //               ),
        //               style: TextStyle(fontSize: 12),
        //             ),
        //           ),
        //           SizedBox(width: 36),
        //         ],
        //       )
        //     : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        title: Row(
          children: [
            Text(
              DELEGATES[widget.delegate]!,
              style: context.textTheme.bodyLarge,
            ),
          ],
        ),
        trailing: RoundedButton(
          onPressed: () {
            final SetupController controller = Get.find<SetupController>();

            controller.removeAt(widget.index);
            controller.update();
          },
          padding: EdgeInsets.zero,
          tooltip: "Remove Delegate",
          color: Colors.red.shade400,
          child: const Icon(Icons.remove),
        ),
      ),
    );
  }
}
