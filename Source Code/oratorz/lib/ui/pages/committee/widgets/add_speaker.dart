import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/gsl.dart';
import '/ui/widgets/country_tile.dart';
import '../../../../tools/controllers/comittee/committee.dart';

class AddSpeakerCard extends StatelessWidget {
  const AddSpeakerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final CommitteeController _committeeController =
        Get.find<CommitteeController>();
    final GSLController _gslController = Get.find<GSLController>();

    return Expanded(
      child: Card(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Speaker",
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 8),
              Obx(() {
                final List<String> speakers =
                    _committeeController.committee.value.countries
                        .where(
                          (element) =>
                              _committeeController.rollCall[element]! > 0,
                        )
                        .toList();

                return speakers.isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              speakers.length * 2 - 1,
                              (index) {
                                final bool isAdded = _gslController
                                    .isAdded(speakers[index ~/ 2]);

                                return index % 2 == 0
                                    ? Opacity(
                                        opacity: isAdded ? 0.6 : 1,
                                        child: CountryTile(
                                          country: speakers[index ~/ 2],
                                          onTap: isAdded
                                              ? null
                                              : () => _gslController.addSpeaker(
                                                    speakers[index ~/ 2],
                                                  ),
                                          contentPadding: EdgeInsets.zero,
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
                        "Conduct a roll call before adding speakers",
                        style: Theme.of(context).textTheme.bodyText1,
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
