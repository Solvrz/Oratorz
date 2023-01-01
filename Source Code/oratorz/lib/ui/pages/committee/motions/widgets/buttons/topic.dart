import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopicButton extends StatefulWidget {
  final Map<String, String> topic;
  final void Function(String) onChanged;

  const TopicButton({
    super.key,
    required this.topic,
    required this.onChanged,
  });

  @override
  State<TopicButton> createState() => _TopicButtonState();
}

class _TopicButtonState extends State<TopicButton> {
  late final TextEditingController _topicController;

  @override
  void initState() {
    super.initState();

    _topicController = TextEditingController(text: widget.topic.values.first);
  }

  @override
  void dispose() {
    // TODO: Not Clearing
    _topicController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.topic.keys.first,
          style: context.textTheme.headline5,
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: TextField(
            autofocus: true,
            controller: _topicController,
            decoration: InputDecoration(
              hintText: widget.topic.keys.first,
              prefixIcon: const Icon(Icons.edit_note),
            ),
            onChanged: (value) => widget.onChanged(value.trim()),
          ),
        ),
      ],
    );
  }
}
