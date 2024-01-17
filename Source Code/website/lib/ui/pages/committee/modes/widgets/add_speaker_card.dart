import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/pages/committee/widgets/add_speaker.dart';

class AddSpeakerCard extends StatelessWidget {
  final String tag;

  const AddSpeakerCard({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: context.height * 0.9,
          ),
          child: AddSpeaker(tag: tag),
        ),
      ),
    );
  }
}
