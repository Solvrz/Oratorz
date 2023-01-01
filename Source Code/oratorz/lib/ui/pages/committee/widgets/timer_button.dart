import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TimerButton extends StatelessWidget {
  final int value;
  final String subtitle;
  final Function(int) change;

  const TimerButton({
    super.key,
    required this.value,
    required this.subtitle,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: value.toString().padLeft(2, "0"));

    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            width: 140,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "00",
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                      hintStyle: context.textTheme.headline1!.copyWith(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: context.textTheme.headline1!.copyWith(
                      color: Colors.grey.shade700,
                    ),
                    onChanged: (text) {
                      if (0 <= int.parse(text) && int.parse(text) < 60) {
                        change(int.parse(text) - value);
                        controller.text = text.padLeft(2, "0");
                      } else {
                        controller.text = value.toString().padLeft(2, "0");
                      }

                      controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: controller.text.length),
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () => change(1),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(Icons.add, size: 18),
                      ),
                    ),
                    InkWell(
                      onTap: () => change(-1),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(Icons.remove, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Text(
          subtitle.toUpperCase(),
          style: context.textTheme.bodyText1!.copyWith(
            fontSize: 12,
            color: Colors.grey.shade600,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
