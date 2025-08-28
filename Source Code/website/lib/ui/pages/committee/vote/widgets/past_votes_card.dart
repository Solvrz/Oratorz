import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/services/cloud_storage.dart';
import '/tools/controllers/comittee/vote.dart';
import '/tools/extensions.dart';

class PastVotesCard extends StatelessWidget {
  const PastVotesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final VoteController voteController = Get.find<VoteController>(tag: "vote");

    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Past Votes",
                style: context.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder(
                  future: CloudStorage.fetchPastVotes(),
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

                    final List<Map<String, dynamic>> pastVotes =
                        voteController.pastVotes.sorted(
                      (a, b) => a["timestamp"].compareTo(b["timestamp"]) * -1,
                    );

                    return pastVotes.isNotEmpty
                        ? ListView.separated(
                            itemCount: pastVotes.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 6,
                              color: Colors.grey.shade400,
                            ),
                            itemBuilder: (_, index) => ListTile(
                              title: RichText(
                                text: TextSpan(
                                  text: "Topic: ",
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: pastVotes[index]["topic"],
                                      style: context.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Text(
                                Timestamp.fromMillisecondsSinceEpoch(
                                  pastVotes[index]["timestamp"],
                                ).toDate().to12Hour,
                                style: context.textTheme.bodySmall,
                              ),
                              trailing: CircleAvatar(
                                radius: 5,
                                backgroundColor: pastVotes[index]["result"]
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          )
                        : Text(
                            "No motions added yet.",
                            style: context.textTheme.bodyLarge,
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
