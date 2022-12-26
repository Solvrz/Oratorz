import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/tools/controllers/comittee/vote.dart';
import '/tools/functions.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/rounded_button.dart';

class VotingCard extends StatelessWidget {
  const VotingCard({super.key});
  @override
  Widget build(BuildContext context) {
    final VoteController _voteController = Get.find<VoteController>();

    // TODO: Voters Not Updating after Roll Call

    return Expanded(
      child: Card(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: context.height * 0.9,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Voting",
                style: context.textTheme.headline5,
              ),
              const SizedBox(height: 8),
              Obx(
                () => Expanded(
                  child: _voteController.voters.isNotEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: context.height / 6,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 25),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.shade400,
                                                  offset: const Offset(1, 1),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                            child: flag(
                                              size: 50,
                                              _voteController.currentVoter
                                                  .split(" ")[0],
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            DELEGATES[
                                                _voteController.currentVoter]!,
                                            style: context.textTheme.headline2,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RoundedButton(
                                            color: Colors.green,
                                            onPressed: () => _voteController
                                                .nextVoter(vote: true),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 56,
                                              vertical: 8,
                                            ),
                                            child: const Text("In Favor"),
                                          ),
                                          const SizedBox(height: 8),
                                          RoundedButton(
                                            color: Colors.red,
                                            onPressed: () => _voteController
                                                .nextVoter(vote: false),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 56,
                                              vertical: 8,
                                            ),
                                            child: const Text("Against"),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              ...List.generate(
                                _voteController.voters.length * 2 - 1,
                                (index) {
                                  return index % 2 == 0
                                      ? DelegateTile(
                                          delegate: _voteController
                                              .voters[index ~/ 2],
                                          contentPadding: EdgeInsets.zero,
                                        )
                                      : Divider(
                                          height: 6,
                                          color: Colors.grey.shade400,
                                        );
                                },
                              ),
                            ],
                          ),
                        )
                      : _voteController.pastVoters.isEmpty
                          ? Text(
                              "Conduct a roll call before adding speakers",
                              style: context.textTheme.bodyText1,
                            )
                          : Center(
                              child: RichText(
                                text: TextSpan(
                                  text: "Vote Completed",
                                  style: context.textTheme.headline2,
                                  children: [
                                    TextSpan(
                                      text:
                                          "\nResult: Vote ${_voteController.inFavor >= _voteController.majorityVal() ? "Passed" : "Failed"}!",
                                      style:
                                          context.textTheme.headline5?.copyWith(
                                        fontSize: 30,
                                        color: _voteController.inFavor >=
                                                _voteController.majorityVal()
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
