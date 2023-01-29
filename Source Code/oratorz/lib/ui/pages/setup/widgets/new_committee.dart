import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/tools/controllers/setup.dart';
import '/tools/extensions.dart';
import '/ui/widgets/delegate_tile.dart';

class NewCommitteeCard extends StatelessWidget {
  const NewCommitteeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final SetupController _setupController = Get.find<SetupController>();

    return SizedBox(
      height: context.height / 1.5,
      width: context.width / 2,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Set Up New Committee",
                style: context.textTheme.headlineSmall,
              ),
              _CommitteeType(
                index: 0,
                title: "UN Member States",
                delegates: COUNTRIES.keys.toList()
                  ..removeWhere(
                    (_delegate) => _setupController.committee.delegates
                        .contains(_delegate),
                  ),
              ),
              _CommitteeType(
                index: 1,
                title: "AIPPM Members",
                delegates: AIPPM.keys.toList()
                  ..removeWhere(
                    (_delegate) => _setupController.committee.delegates
                        .contains(_delegate),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommitteeType extends StatelessWidget {
  final int index;
  final String title;
  final List<String> delegates;

  const _CommitteeType({
    required this.index,
    required this.title,
    required this.delegates,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return GetBuilder<SetupController>(
      builder: (setupController) {
        final bool isOpen = setupController.committeeType == index;

        final Widget widget = Column(
          children: [
            InkWell(
              onTap: () {
                setupController.committeeType = index;
                setupController.update();
              },
              child: Container(
                margin: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      isOpen ? Icons.arrow_drop_down : Icons.arrow_right,
                    ),
                    Text(
                      title,
                      style: context.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
            if (isOpen) ...[
              Container(
                margin: const EdgeInsets.all(12),
                child: TextField(
                  autofocus: true,
                  controller: searchController,
                  onChanged: (_) => setupController.update(),
                  decoration: const InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Builder(
                builder: (context) {
                  final List<String> searchResults = [];

                  delegates.forEach((delegate) {
                    final String query = searchController.toText;

                    if (query.isNotEmpty) {
                      if (DELEGATES[delegate]!
                          .toLowerCase()
                          .contains(query.toLowerCase())) {
                        searchResults.add(delegate);
                      }
                    } else {
                      searchResults.add(delegate);
                    }
                  });

                  return Expanded(
                    child: searchResults.isNotEmpty
                        ? ListView.separated(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final String delegate = searchResults[index];
                              final bool hasDelegate = setupController
                                  .committee.delegates
                                  .contains(delegate);

                              return Opacity(
                                opacity: hasDelegate ? 0.6 : 1,
                                child: DelegateTile(
                                  delegate: searchResults[index],
                                  onTap: () {
                                    if (!hasDelegate) {
                                      setupController.add(delegate);
                                      setupController.update();
                                    }
                                  },
                                  trailing: Icon(
                                    Icons.add,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                              indent: 65,
                              height: 5,
                              thickness: 0.5,
                              color: Colors.grey.shade400,
                            ),
                          )
                        : Center(
                            child: Text(
                              "No results matching your search was found.",
                              style: context.textTheme.bodyLarge,
                            ),
                          ),
                  );
                },
              ),
            ],
          ],
        );

        if (isOpen) {
          return Expanded(child: widget);
        }

        return widget;
      },
    );
  }
}
