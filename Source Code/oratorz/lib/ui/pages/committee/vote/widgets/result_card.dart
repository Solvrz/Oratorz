import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/vote.dart';
import '/ui/widgets/rounded_button.dart';
import './settings_dialog.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    final VoteController _voteController =
        Get.find<VoteController>(tag: "vote");

    return SizedBox(
      height: context.height / 2.5,
      width: context.width / 4,
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Column(
                  children: [
                    RichText(
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
                    const SizedBox(height: 30),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundedButton(
                    color: Colors.amber.shade400,
                    onPressed: () async => showDialog(
                      context: context,
                      builder: (_) => const SettingsDialog(),
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
