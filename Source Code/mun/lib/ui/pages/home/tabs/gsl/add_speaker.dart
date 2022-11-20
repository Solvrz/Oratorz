import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/gsl.dart';
import '/tools/controllers/home.dart';
import '/ui/widgets/country_tile.dart';

class AddSpeakerCard extends StatefulWidget {
  final GSLController gslController;

  const AddSpeakerCard({
    Key? key,
    required this.gslController,
  }) : super(key: key);

  @override
  State<AddSpeakerCard> createState() => _AddSpeakerCardState();
}

class _AddSpeakerCardState extends State<AddSpeakerCard> {
  @override
  Widget build(BuildContext context) {
    final HomeController? controller = Get.find<HomeController>();

    return Card(
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
            Obx(
              () {
                final List<String> speakers =
                    controller?.committee.value.countries
                            .where(
                              (element) => controller.rollCall[element]! > 0,
                            )
                            .toList() ??
                        [];

                return speakers.isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              speakers.length * 2 - 1,
                              (index) {
                                final bool isAdded = widget.gslController
                                    .isAdded(speakers[index ~/ 2]);

                                return index % 2 == 0
                                    ? Opacity(
                                        opacity: isAdded ? 0.6 : 1,
                                        child: CountryTile(
                                          country: speakers[index ~/ 2],
                                          onTap: isAdded
                                              ? null
                                              : () => widget.gslController
                                                      .addSpeaker(
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
