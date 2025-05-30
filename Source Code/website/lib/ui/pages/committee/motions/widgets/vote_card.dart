import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/vote.dart';
import '/ui/pages/committee/widgets/dialogs/vote_settings.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/rounded_button.dart';

class VoteCard extends StatelessWidget {
  const VoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    late final VoteController _voteController;

    if (!Get.isRegistered<VoteController>(tag: "motions")) {
      _voteController = Get.put<VoteController>(
        (VoteController()
          ..voters = Get.find<CommitteeController>()
              .committee
              .presentAndVotingDelegates),
        tag: "motions",
      );
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
                style: context.textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  const _Result(),
                  const SizedBox(width: 52),
                  Column(
                    children: [
                      RoundedButton(
                        color: Colors.amber.shade400,
                        tooltip: "Settings",
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => const VoteSettingsDialog(
                            tag: "motions",
                            title: false,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 8,
                        ),
                        child: const Icon(Icons.settings),
                      ),
                      const SizedBox(height: 8),
                      RoundedButton(
                        color: context.theme.colorScheme.tertiary,
                        tooltip: "Reset Vote",
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
              Expanded(
                child: Obx(
                  () => _voteController.voters.isNotEmpty
                      ? const _Voting()
                      : _voteController.pastVoters.isEmpty
                          ? Text(
                              "Conduct a roll call before voting",
                              style: context.textTheme.bodyLarge,
                            )
                          : Center(
                              child: RichText(
                                text: TextSpan(
                                  text: "Vote Completed",
                                  style: context.textTheme.displayMedium,
                                  children: [
                                    TextSpan(
                                      text:
                                          "\nResult: Vote ${_voteController.inFavor >= _voteController.majorityVal() ? "Passed" : "Failed"}!",
                                      style: context.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontSize: 30,
                                        color: _voteController.inFavor >=
                                                _voteController.majorityVal()
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
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

class _Voting extends StatelessWidget {
  const _Voting();

  @override
  Widget build(BuildContext context) {
    final ItemScrollController _scrollController = ItemScrollController();
    final VoteController _voteController =
        Get.find<VoteController>(tag: "motions");

    final List<String> _voters = _voteController.voters.toList();

    return SizedBox(
      height: context.height / 1.95,
      child: ScrollablePositionedList.separated(
        itemCount: _voters.length,
        itemScrollController: _scrollController,
        itemBuilder: (_, index) {
          final String _delegate = _voters[index];

          return DelegateTile(
            delegate: _delegate,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => RoundedButton(
                    style: _voteController.voteVal(
                      delegate: _delegate,
                      invert: true,
                    )
                        ? RoundedButtonStyle.border
                        : RoundedButtonStyle.empty,
                    color: Colors.green,
                    onPressed: () {
                      _voteController.vote(
                        vote: true,
                        voter: _delegate,
                      );
                      if (index < _voters.length - 7) {
                        _scrollController.scrollTo(
                          index: index + 1,
                          duration: const Duration(milliseconds: 250),
                        );
                      }
                    },
                    child: const Icon(Icons.thumb_up),
                  ),
                ),
                const SizedBox(width: 4),
                Obx(
                  () => RoundedButton(
                    style: _voteController.voteVal(
                      invert: false,
                      delegate: _delegate,
                    )
                        ? RoundedButtonStyle.border
                        : RoundedButtonStyle.empty,
                    color: Colors.red,
                    onPressed: () {
                      _voteController.vote(
                        vote: false,
                        voter: _delegate,
                      );

                      if (index < _voters.length - 7) {
                        _scrollController.scrollTo(
                          index: index + 1,
                          duration: const Duration(milliseconds: 250),
                        );
                      }
                    },
                    child: const Icon(Icons.thumb_down),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => Divider(
          height: 6,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result();

  @override
  Widget build(BuildContext context) {
    final VoteController _voteController =
        Get.find<VoteController>(tag: "motions");

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${_voteController.inFavor}\nIn Favor",
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge,
                ),
                Text(
                  "${_voteController.against}\nAgainst",
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge,
                ),
                Text(
                  "${_voteController.majorityVal()}\nMajority",
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                    widthFactor: _voteController.majority == 1 ? 15 : null,
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
    );
  }
}
