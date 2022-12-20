import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/data.dart';
import '/tools/controllers/setup.dart';
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
                title: "UN Memeber States",
                delegates: COUNTRIES.keys.toList()
                  ..removeWhere(
                    (_delegate) => _setupController.committee.value.delegates
                        .contains(_delegate),
                  ),
              ),
              CommitteeType(
                title: "AIPPM Memebers",
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
  bool open = false;

  // TODO: Search not Working

  @override
  Widget build(BuildContext context) => SizedBox(
        height: open ? context.height / 2.1 : 65,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => open = !open),
                    icon:
                        Icon(open ? Icons.arrow_right : Icons.arrow_drop_down),
                  ),
                  Text(
                    widget.title,
                    style: context.textTheme.headline6,
                  ),
                ],
              ),
            ),
            if (open) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
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
                builder: (_) => Expanded(
                  child: ListView.separated(
                    itemCount: widget.delegates.length,
                    itemBuilder: (context, index) {
                      final String _delegate = widget.delegates[index];

                      return DelegateTile(
                        delegate: _delegate,
                        onTap: () {
                          _setupController.add(_delegate);
                          _setupController.update();
                        },
                        trailing: Icon(Icons.add, color: Colors.grey[400]),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      indent: 65,
                      height: 5,
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
}
