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
      height: context.height / 1.52,
      child: Card(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Set Up New Committee",
                style: context.textTheme.headline5,
              ),
              CommitteeType(
                title: "UN Member States",
                delegates: COUNTRIES.keys.toList()
                  ..removeWhere(
                    (_delegate) => _setupController.committee.value.delegates
                        .contains(_delegate),
                  ),
              ),
              CommitteeType(
                title: "AIPPM Members",
                delegates: AIPPM.keys.toList()
                  ..removeWhere(
                    (_delegate) => _setupController.committee.value.delegates
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

class CommitteeType extends StatefulWidget {
  final String title;
  final List<String> delegates;

  const CommitteeType({
    super.key,
    required this.title,
    required this.delegates,
  });

  @override
  State<CommitteeType> createState() => _CommitteeTypeState();
}

class _CommitteeTypeState extends State<CommitteeType> {
  final SetupController _setupController = Get.find<SetupController>();
  final TextEditingController _searchController = TextEditingController();

  bool open = false;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: open ? context.height / 2.1 : 65,
        child: Column(
          children: [
            InkWell(
              onTap: () => setState(() => open = !open),
              hoverColor: const Color.fromARGB(255, 250, 250, 250),
              child: Container(
                margin: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(open ? Icons.arrow_right : Icons.arrow_drop_down),
                    Text(
                      widget.title,
                      style: context.textTheme.headline6,
                    ),
                  ],
                ),
              ),
            ),
            if (open) ...[
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _setupController.update(),
                  cursorColor: Colors.grey[600],
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    hintStyle: context.textTheme.bodyText1,
                    hoverColor: Colors.transparent,
                    fillColor: Colors.transparent,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                ),
              ),
              GetBuilder<SetupController>(
                builder: (_) {
                  final List<String> _delegates = [];

                  widget.delegates.forEach(
                    (_delegate) {
                      final String _search = _searchController.toText();

                      if (_search != "") {
                        if (DELEGATES[_delegate]!
                            .toLowerCase()
                            .contains(_search.toLowerCase())) {
                          _delegates.add(_delegate);
                        }
                      } else {
                        _delegates.add(_delegate);
                      }
                    },
                  );

                  return Expanded(
                    child: _delegates.isNotEmpty
                        ? ListView.separated(
                            itemCount: _delegates.length,
                            itemBuilder: (context, index) => DelegateTile(
                              delegate: _delegates[index],
                              onTap: () {
                                _setupController.add(_delegates[index]);
                                _setupController.update();
                              },
                              trailing:
                                  Icon(Icons.add, color: Colors.grey[400]),
                            ),
                            separatorBuilder: (context, index) => Divider(
                              indent: 65,
                              height: 5,
                              thickness: 0.5,
                              color: Colors.grey[400],
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
}
