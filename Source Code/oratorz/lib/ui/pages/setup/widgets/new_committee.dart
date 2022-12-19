import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/constants.dart';
import '/config/data.dart';
import '/tools/controllers/setup.dart';
import '/ui/widgets/delegate_tile.dart';

class NewCommitteeCard extends StatelessWidget {
  const NewCommitteeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final SetupController _setupController = Get.find<SetupController>();

    return Expanded(
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Set Up New Committee",
                style: theme.textTheme.headline5,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  "UN Member States",
                  style: theme.textTheme.headline6,
                ),
              ),
              // TODO: Search not Working
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Expanded(
                  child: TextField(
                    cursorColor: Colors.grey[600],
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      hintStyle: theme.textTheme.bodyText1,
                      hoverColor: Colors.transparent,
                      fillColor: Colors.transparent,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              GetBuilder<SetupController>(
                builder: (_) {
                  final List<String> data = DELEGATES.keys.toList()
                    ..removeWhere(
                      (_delegate) => _setupController.committee.value.delegates
                          .contains(_delegate),
                    );

                  return Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) => DelegateTile(
                        delegate: data[index],
                        onTap: () {
                          _setupController.add(data[index]);
                          _setupController.update();
                        },
                        trailing: Icon(Icons.add, color: Colors.grey[400]),
                      ),
                      separatorBuilder: (context, index) => Divider(
                        indent: 66,
                        thickness: 0.5,
                        height: 6,
                        color: Colors.grey[400],
                      ),
                      itemCount: data.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
