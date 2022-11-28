import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/gsl.dart';
import '/ui/widgets/country_tile.dart';

class PastSpeakersCard extends StatelessWidget {
  const PastSpeakersCard({super.key});

  @override
  Widget build(BuildContext context) {
    final GSLController _gslController = Get.find<GSLController>();

    return Expanded(
      child: Card(
        child: Container(
          height: MediaQuery.of(context).size.height / 2.5,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Past Speakers",
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 8),
              Obx(
                () => _gslController.pastSpeakers.isEmpty
                    ? Text(
                        "No past speakers have been recorded",
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              _gslController.pastSpeakers.length * 2 - 1,
                              (index) {
                                if (index % 2 == 1) {
                                  return Divider(
                                    height: 6,
                                    color: Colors.grey.shade400,
                                  );
                                }

                                final Map<String, Duration> speaker =
                                    _gslController.pastSpeakers[index ~/ 2];
                                final int inMinutes =
                                    speaker.values.first.inMinutes;
                                final int inSeconds =
                                    speaker.values.first.inSeconds;

                                return CountryTile(
                                  country: speaker.keys.first,
                                  contentPadding: EdgeInsets.zero,
                                  trailing: Text(
                                    "$inMinutes:${(inSeconds - inMinutes * 60).toString().padLeft(2, '0')}",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
