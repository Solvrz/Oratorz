import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/models/committee.dart';
import '/models/router.dart';
import '/tools/controllers/app.dart';
import './committee_card.dart';

class CommitteesSection extends StatelessWidget {
  const CommitteesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Your Committees",
            style: context.textTheme.headlineSmall,
          ),
        ),
        GetBuilder<AppController>(
          builder: (_) {
            final List<Committee> committees =
                Get.find<AppController>().user!.committees;

            return Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 24,
              children: [
                ...List.generate(
                  committees.length,
                  (index) => CommitteeCard(
                    committee: committees[index],
                  ),
                ),
                InkWell(
                  onTap: () => context.push(Router.setup.path),
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      strokeWidth: 3,
                      dashPattern: const [10, 4],
                      color: Colors.grey.shade500,
                      radius: const Radius.circular(10),
                    ),
                    child: SizedBox(
                      height: 174,
                      width: 150,
                      child: Center(
                        child: Text(
                          "Start a New Committee",
                          style: context.textTheme.titleLarge!.copyWith(
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
