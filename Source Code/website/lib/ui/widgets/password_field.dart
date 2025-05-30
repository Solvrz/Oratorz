// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PasswordField extends StatefulWidget {
  final void Function(String value)? onSubmitted;
  final EdgeInsets? errorPadding;

  PasswordField({
    super.key,
    this.onSubmitted,
    this.errorPadding,
  });

  _PasswordFieldState _state = _PasswordFieldState();

  void setError(String? newError) => _state.setError(newError);

  final TextEditingController controller = TextEditingController();

  String get pass => _state.pass;
  void clear() => _state.clear();

  @override
  _PasswordFieldState createState() => _state = _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  String? error;

  String get pass => widget.controller.text.trim();
  void clear() => widget.controller.clear();

  void setError(String? newError) {
    if (mounted) setState(() => error = newError);
  }

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
              controller: widget.controller,
              cursorColor: context.theme.colorScheme.secondary,
              onSubmitted: widget.onSubmitted,
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
        Padding(
          padding: widget.errorPadding ?? const EdgeInsets.fromLTRB(8, 4, 0, 8),
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
              : const SizedBox(),
        ),
      ],
    );
  }
}
