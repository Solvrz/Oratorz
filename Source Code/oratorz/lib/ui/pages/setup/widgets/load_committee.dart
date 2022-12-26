import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/tools/controllers/setup.dart';
import '/tools/extensions.dart';
import '/ui/widgets/dialog_box.dart';

class LoadCommitteeCard extends StatelessWidget {
  const LoadCommitteeCard({super.key});

  List<String> createDelegates(List<List<Data?>> rows) {
    final List<String> _delegates = [];

    for (final List<Data?> row in rows) {
      final String? name = row[0]?.value.toString();
      final String? type = row[1]?.value.toString();

      if (name != null && name.isNotEmpty) {
        if (type?.toLowerCase().trim() == "un") {
          if (COUNTRIES.values
              .where(
                (_delegate) =>
                    _delegate.toLowerCase() == name.toLowerCase().trim(),
              )
              .isNotEmpty) {
            _delegates.add(
              COUNTRIES.entries
                  .where(
                    (_entry) =>
                        _entry.value.toLowerCase() == name.toLowerCase().trim(),
                  )
                  .first
                  .key,
            );
          } else {
            COUNTRIES[name] = name;
            DELEGATES[name] = name;

            _delegates.add(name);
          }
        } else if (type?.toLowerCase().trim() == "aippm") {
          final String? party = row[2]?.value.toString();

          if (party != null && party.isNotEmpty) {
            if (AIPPM.values
                .where(
                  (_delegate) =>
                      _delegate.toLowerCase() == name.toLowerCase().trim(),
                )
                .isNotEmpty) {
              _delegates.add(
                AIPPM.entries
                    .where(
                      (_entry) =>
                          _entry.value.toLowerCase() ==
                          name.toLowerCase().trim(),
                    )
                    .first
                    .key,
              );
            } else {
              AIPPM.entries.toList().forEach((_) {
                if (AIPPM.containsKey("$party 0")) {
                  int _members = 0;

                  _members = AIPPM.keys
                      .where(
                        (_party) => _party.contains(party),
                      )
                      .toList()
                      .last
                      .split(" ")[1]
                      .toInt();

                  AIPPM["$party $_members"] = name;
                  DELEGATES["$party $_members"] = name;

                  if (!_delegates.contains("$party $_members")) {
                    _delegates.add("$party $_members");
                  }
                } else {
                  AIPPM["$party 0"] = name;
                  DELEGATES["$party 0"] = name;

                  _delegates.add("$party 0");
                }
              });
            }
          }
        } else {
          return [];
        }
      } else {
        return [];
      }
    }

    return _delegates;
  }

  @override
  Widget build(BuildContext context) {
    final SetupController _setupController = Get.find<SetupController>();

    return SizedBox(
      height: context.height / 6,
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Load Committee",
                style: context.textTheme.headline5,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      child: const Text("From File"),
                      onPressed: () async {
                        try {
                          final FilePickerResult? _result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ["xlsx", "xls"],
                          );

                          if (_result != null) {
                            final Excel excel =
                                Excel.decodeBytes(_result.files.single.bytes!);

                            for (final String table in excel.tables.keys) {
                              final Sheet? sheet = excel.tables[table];

                              if (sheet != null && sheet.maxCols == 3) {
                                final List<List<Data?>> rows = sheet.rows;
                                final List<String> _delegates =
                                    createDelegates(rows..removeAt(0));

                                if (_delegates.isNotEmpty) {
                                  _delegates.forEach(
                                    (_delegate) {
                                      if (!_setupController.committee.delegates
                                          .contains(_delegate)) {
                                        _setupController.add(_delegate);
                                      }
                                    },
                                  );
                                  _setupController.update();

                                  return;
                                }
                              }
                            }

                            throw Exception([
                              "The file is invalid. Please check the file & Try again..."
                            ]);
                          } else {
                            throw Exception([
                              "An unkown error occured. Please check the file & Try again..."
                            ]);
                          }
                        } catch (e) {
                          // TODO: Show Error
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextButton(
                      child: const Text("From Template"),
                      onPressed: () {
                        final List<String> templates = COMMITTEES.keys.toList();
                        final SetupController _setupController =
                            Get.find<SetupController>();

                        showDialog(
                          context: context,
                          builder: (_) => DialogBox(
                            heading: "Select Template",
                            content: SizedBox(
                              height: context.height / 2,
                              width: context.width / 2.5,
                              child: ListView.builder(
                                itemCount: COMMITTEES.length * 2 - 1,
                                itemBuilder: (_, index) => index % 2 == 0
                                    ? ListTile(
                                        hoverColor: Colors.grey[100],
                                        onTap: () {
                                          _setupController.setName(
                                            templates[index ~/ 2],
                                          );
                                          _setupController.setAs(
                                            COMMITTEES[templates[index ~/ 2]]!
                                                .toList(),
                                          );

                                          Navigator.pop(context);
                                        },
                                        title: Text(
                                          "${templates[index ~/ 2]} (${COMMITTEES[templates[index ~/ 2]]!.length})",
                                          style: context.textTheme.bodyText1,
                                        ),
                                      )
                                    : Divider(
                                        height: 2,
                                        color: Colors.grey[300],
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
