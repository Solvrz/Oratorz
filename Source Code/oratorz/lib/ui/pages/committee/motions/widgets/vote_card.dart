import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/vote.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/rounded_button.dart';
import 'vote_settings.dart';

class VoteCard extends StatelessWidget {
  const VoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    late final VoteController _voteController;

    if (!Get.isRegistered<VoteController>(tag: "motions")) {
      final VoteController _controller = VoteController();
      _controller.voters =
          Get.find<CommitteeController>().committee.presentAndVotingDelegates;

      _voteController = Get.put(_controller, tag: "motions");
    } else {
      _voteController = Get.find<VoteController>(tag: "motions");
    }

    return Expanded(
      child: Card(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: context.height * 0.9,
          ),
          margin: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Vote on Motion",
                style: context.textTheme.headline5,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "${_voteController.inFavor}\nIn Favor",
                                textAlign: TextAlign.center,
                                style: context.textTheme.bodyText1,
                              ),
                              Text(
                                "${_voteController.against}\nAgainst",
                                textAlign: TextAlign.center,
                                style: context.textTheme.bodyText1,
                              ),
                              Text(
                                "${_voteController.majorityVal()}\nMajority",
                                textAlign: TextAlign.center,
                                style: context.textTheme.bodyText1,
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 12),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(width: 3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Obx(
                            () => Stack(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      flex: _voteController.inFavor + 1,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: _voteController.against + 1,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: _voteController.majority == 0
                                      ? Alignment.center
                                      : Alignment.centerRight,
                                  widthFactor:
                                      _voteController.majority == 1 ? 15 : null,
                                  child: const VerticalDivider(
                                    thickness: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 52),
                  Column(
                    children: [
                      RoundedButton(
                        color: Colors.amber.shade400,
                        onPressed: () async => showDialog(
                          context: context,
                          builder: (_) => const VoeSettingsDialog(),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 8,
                        ),
                        child: const Icon(Icons.settings),
                      ),
                      const SizedBox(height: 8),
                      RoundedButton(
                        color: Colors.blue.shade400,
                        onPressed: () {
                          _voteController.reset();
                          _voteController.update();
                        },
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 8,
                        ),
                        child: const Icon(Icons.restart_alt),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              _voteController.voters.isNotEmpty
                  ? SizedBox(
                      height: context.height / 3,
                      child: ListView.separated(
                        itemCount: _voteController.voters.length,
                        itemBuilder: (_, index) => DelegateTile(
                          delegate: _voteController.voters[index],
                          trailing: Obx(
                            // TODO: Past Voters not Retaining & Voters Increasing
                            () => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RoundedButton(
                                  border: _voteController.voteVal(
                                    _voteController.voters[index],
                                    invert: true,
                                  ),
                                  color: Colors.green,
                                  onPressed: () => _voteController.vote(
                                    vote: true,
                                    remove: false,
                                    voter: _voteController.voters[index],
                                  ),
                                  child: const Icon(Icons.thumb_up),
                                ),
                                const SizedBox(width: 4),
                                RoundedButton(
                                  border: _voteController.voteVal(
                                    _voteController.voters[index],
                                  ),
                                  color: Colors.red,
                                  onPressed: () => _voteController.vote(
                                    vote: false,
                                    remove: false,
                                    voter: _voteController.voters[index],
                                  ),
                                  child: const Icon(Icons.thumb_down),
                                ),
                              ],
                            ),
                          ),
                        ),
                        separatorBuilder: (_, __) => Divider(
                          height: 6,
                          color: Colors.grey.shade400,
                        ),
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
                                  style: context.textTheme.headline5?.copyWith(
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
            ],
          ),
        ),
      ),
    );
  }
}
