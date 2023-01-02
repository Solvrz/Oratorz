import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/vote.dart';
import '/ui/widgets/rounded_button.dart';
import '../../widgets/dialogs/vote_settings.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    final VoteController _voteController =
        Get.find<VoteController>(tag: "vote");

    return SizedBox(
      height: context.height / 2.6,
      width: context.width / 4,
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              Obx(
                () => Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: "Topic: ",
                          style: context.textTheme.headline2,
                          children: [
                            TextSpan(
                              text: _voteController.topic,
                              style: context.textTheme.headline5!
                                  .copyWith(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
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
                    ),
                  ],
                ),
              ),
              Container(
                height: 30,
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 35,
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Obx(
                  () {
                    final int inFavorFlex = _voteController.pastVoters.isEmpty
                        ? 1
                        : _voteController.inFavor;

                    final int inAgainstFlex = _voteController.pastVoters.isEmpty
                        ? 1
                        : _voteController.against;

                    return Stack(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: inFavorFlex,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: inAgainstFlex == 0
                                      ? BorderRadius.circular(12)
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: inAgainstFlex,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: inFavorFlex == 0
                                      ? BorderRadius.circular(12)
                                      : const BorderRadius.only(
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
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundedButton(
                    color: Colors.amber.shade400,
                    onPressed: () async => showDialog(
                      context: context,
                      builder: (_) => const VoteSettingsDialog(tag: "vote"),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 8,
                    ),
                    child: const Icon(Icons.settings),
                  ),
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
        ),
      ),
    );
  }
}
