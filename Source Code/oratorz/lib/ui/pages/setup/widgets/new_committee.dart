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
      height: context.height / 1.415,
      width: context.width / 2,
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Set Up New Committee",
                style: context.textTheme.headline5,
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
    final SetupController _setupController = Get.find<SetupController>();
    final TextEditingController _searchController = TextEditingController();

    return GetBuilder<SetupController>(
      builder: (_) {
        final bool _open = _setupController.committeeType == index;

        return SizedBox(
          height: _open ? context.height / 1.9 : 65,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  _setupController.committeeType = index;
                  _setupController.update();
                },
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        _open ? Icons.arrow_right : Icons.arrow_drop_down,
                      ),
                      Text(
                        title,
                        style: context.textTheme.headline6,
                      ),
                    ],
                  ),
                ),
              ),
              if (_open) ...[
                Container(
                  margin: const EdgeInsets.all(12),
                  child: TextField(
                    autofocus: true,
                    controller: _searchController,
                    onChanged: (_) => _setupController.update(),
                    decoration: const InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Builder(
                  builder: (_) {
                    final List<String> _delegates = [];

                    delegates.forEach((_delegate) {
                      final String _search = _searchController.toText;

                      if (_search.isNotEmpty) {
                        if (DELEGATES[_delegate]!
                            .toLowerCase()
                            .contains(_search.toLowerCase())) {
                          _delegates.add(_delegate);
                        }
                      } else {
                        _delegates.add(_delegate);
                      }
                    });

                    return Expanded(
                      child: _delegates.isNotEmpty
                          ? ListView.separated(
                              itemCount: _delegates.length,
                              itemBuilder: (_, index) {
                                final String _delegate = _delegates[index];

                                return Opacity(
                                  opacity: _setupController.committee.delegates
                                          .contains(_delegate)
                                      ? 0.6
                                      : 1,
                                  child: DelegateTile(
                                    delegate: _delegates[index],
                                    onTap: () {
                                      if (!_setupController.committee.delegates
                                          .contains(_delegate)) {
                                        _setupController.add(_delegate);
                                        _setupController.update();
                                      }
                                    },
                                    trailing: Icon(
                                      Icons.add,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (_, index) => Divider(
                                indent: 65,
                                height: 5,
                                thickness: 0.5,
                                color: Colors.grey.shade400,
                              ),
                            )
                          : Center(
                              child: Text(
                                "Member matching your search not found.",
                                style: context.textTheme.bodyText1,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
