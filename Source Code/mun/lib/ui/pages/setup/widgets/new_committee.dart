import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/config/country_info.dart';
import '/controllers/setup_committee.dart';

class NewCommitteeCard extends StatelessWidget {
  const NewCommitteeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<SetupCommitteeController>(
      init: Get.find<SetupCommitteeController>(),
      builder: (controller) {
        final List<String> data = COUNTRIES.keys.toList();
        data.removeWhere(
          (element) => controller.committee.value.countries.contains(element),
        );

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Set Up New Committee",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    "UN Member States",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[600]),
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.grey[600],
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintMaxLines: 1,
                            hintStyle: Theme.of(context).textTheme.bodyText1,
                            hoverColor: Colors.transparent,
                            fillColor: Colors.transparent,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => ListTile(
                      hoverColor: Colors.grey[100],
                      onTap: () => controller.add(data[index]),
                      leading: CircleAvatar(
                        radius: 20,
                        child: SvgPicture.asset(
                          "flags/${data[index]}.svg",
                        ),
                      ),
                      title: Text(
                        COUNTRIES[data[index]]!,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
