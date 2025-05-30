// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class InputField extends StatefulWidget {
  final TextInputType textInputType;

  final void Function(String value)? onSubmitted;
  final EdgeInsets? errorPadding;
  final String hintText;

  InputField({
    super.key,
    required this.hintText,
    this.textInputType = TextInputType.emailAddress,
    this.onSubmitted,
    this.errorPadding,
  });

  _InputFieldState _state = _InputFieldState();

  void setError(String? newError) => _state.setError(newError);

  final TextEditingController controller = TextEditingController();

  String get text => _state.text;
  void clear() => _state.clear();

  @override
  _InputFieldState createState() {
    return _state = _InputFieldState();
  }
}

class _InputFieldState extends State<InputField> {
  String? error;

  String get text => widget.controller.text.trim();
  void clear() => widget.controller.clear();

  void setError(String? newError) {
    if (mounted) setState(() => error = newError);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          keyboardType: widget.textInputType,
          cursorColor: context.theme.colorScheme.secondary,
          onSubmitted: widget.onSubmitted,
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
        Padding(
          padding:
              widget.errorPadding ?? const EdgeInsets.fromLTRB(8, 4, 0, 12),
          child: error != null && error != ""
              ? Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: context.theme.colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      error!,
                      style: TextStyle(color: context.theme.colorScheme.error),
                    ),
                  ],
                )
              : Container(),
        ),
      ],
    );
  }
}
