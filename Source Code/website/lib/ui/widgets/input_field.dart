// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class InputField extends StatefulWidget {
  final TextInputType textInputType;
  final String hintText;
  final RxString text;
  final RxString error;

  const InputField({
    super.key,
    required this.hintText,
    required this.text,
    required this.error,
    this.textInputType = TextInputType.emailAddress,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: widget.textInputType,
          cursorColor: context.theme.colorScheme.secondary,
          onChanged: (value) => widget.text.value = value.trim(),
          decoration: InputDecoration(
            fillColor: context.theme.colorScheme.primary,
            focusColor: context.theme.colorScheme.primary,
            hoverColor: context.theme.colorScheme.primary,
            hintText: widget.hintText,
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
