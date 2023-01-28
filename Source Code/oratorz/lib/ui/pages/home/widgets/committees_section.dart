import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';

import '/services/local_storage.dart';
import 'committee_card.dart';

class CommitteesSection extends StatelessWidget {
  const CommitteesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> committees = LocalStorage.committees;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Your Committees",
            style: context.textTheme.headline5,
          ),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 24,
          runSpacing: 24,
          children: [
            ...List.generate(
              committees.length,
              (index) => CommitteeCard(
                committee: LocalStorage.getCommittee(committees[index]),
              ),
            ),
            InkWell(
              onTap: () => context.push("/setup"),
              child: DottedBorder(
                strokeWidth: 3,
                dashPattern: const [10, 4],
                borderType: BorderType.RRect,
                color: Colors.grey.shade500,
                radius: const Radius.circular(10),
                child: SizedBox(
                  height: 174,
                  width: 150,
                  child: Center(
                    child: Text(
                      "Start a New Committee",
                      style: context.textTheme.headline6!.copyWith(
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
