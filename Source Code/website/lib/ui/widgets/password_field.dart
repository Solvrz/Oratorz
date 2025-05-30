// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PasswordField extends StatefulWidget {
  final RxString text;
  final RxString error;

  const PasswordField({
    super.key,
    required this.text,
    required this.error,
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            TextField(
              obscureText: hide,
              cursorColor: context.theme.colorScheme.secondary,
              onChanged: (value) => widget.text.value = value,
              decoration: InputDecoration(
                fillColor: context.theme.colorScheme.primary,
                focusColor: context.theme.colorScheme.primary,
                hoverColor: context.theme.colorScheme.primary,
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: context.theme.colorScheme.tertiary,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            IconButton(
              highlightColor: Colors.transparent,
              color: Colors.grey.shade500,
              icon: hide
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () => setState(() => hide = !hide),
            ),
          ],
        ),
        Obx(
          () => Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
            child: widget.error.value != ""
                ? Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: context.theme.colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.error.value,
                        softWrap: true,
                        style:
                            TextStyle(color: context.theme.colorScheme.error),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ),
      ],
    );
  }
}
