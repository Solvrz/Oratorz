import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/vote.dart';
import '/ui/widgets/delegate_tile.dart';

class PastVoterCard extends StatelessWidget {
  const PastVoterCard({super.key});

  @override
  Widget build(BuildContext context) {
    final VoteController _voteController = Get.find<VoteController>();

    return SizedBox(
      height: context.height / 2.5,
      width: context.width / 4,
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Voting",
                style: context.textTheme.headline5,
              ),
              const SizedBox(height: 8),
              Obx(
                () => _voteController.pastVoters.isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              _voteController.pastVoters.length * 2 - 1,
                              (index) {
                                return index % 2 == 0
                                    ? DelegateTile(
                                        delegate: _voteController
                                            .pastVoters[index ~/ 2].keys.first,
                                        contentPadding: EdgeInsets.zero,
                                        trailing: CircleAvatar(
                                          radius: 5,
                                          backgroundColor: _voteController
                                                  .pastVoters[index ~/ 2]
                                                  .values
                                                  .first
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      )
                                    : Divider(
                                        height: 6,
                                        color: Colors.grey.shade400,
                                      );
                              },
                            ),
                          ),
                        ),
                      )
                    : Text(
                        "No one has voted yet.",
                        style: context.textTheme.bodyText1,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
