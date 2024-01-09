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
  Widget build(BuildContext context) {
    // TODO: Not Clearing
    _topicController = TextEditingController(text: widget.topic.values.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.topic.keys.first,
          style: context.textTheme.headlineSmall,
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
