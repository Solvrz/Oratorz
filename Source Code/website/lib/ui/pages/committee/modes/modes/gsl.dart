import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/services/cloud_storage.dart';
import '/tools/controllers/comittee/committee.dart';
import '/ui/pages/committee/modes/widgets/add_speaker_card.dart';
import '/ui/pages/committee/modes/widgets/past_speakers_card.dart';
import '/ui/pages/committee/widgets/hourglass.dart';
import '/ui/pages/committee/widgets/speakers_info.dart';

class GSLMode extends StatelessWidget {
  const GSLMode({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommitteeController>(
      builder: (controller) => FutureBuilder(
        future: CloudStorage.fetchCaucus("gsl"),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                child: CircularProgressIndicator(
                  color: Color(0xff2a313b),
                ),
              ),
            );
          }

          return Obx(() {
            final CommitteeController controller =
                Get.find<CommitteeController>();

            return controller.readOnly
                ? const Row(children: [PastSpeakersCard(tag: "gsl")])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: context.width / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              child: Container(
                                height: context.height / 2.25,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 18,
                                ),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Hourglass(
                                        tag: "gsl",
                                        canYield: true,
                                      ),
                                    ),
                                    SizedBox(width: 48),
                                    SpeakersInfo(tag: "gsl"),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const PastSpeakersCard(tag: "gsl"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 36),
                      const AddSpeakerCard(tag: "gsl"),
                    ],
                  );
          });
        },
      ),
    );
  }
}
