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

  List<String> toAIPPM(List<List<Data?>> rows) {
    final List<String> _delegates = [];

    for (final List<Data?> row in rows) {
      final String? name = row[0]?.value.toString();
      final String? party = row[1]?.value.toString();

      //TODO: Party Check in list of usual names

      if (party != null &&
          party.isNotEmpty &&
          name != null &&
          name.isNotEmpty) {
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
                      _entry.value.toLowerCase() == name.toLowerCase().trim(),
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
    }

    return _delegates;
  }

  List<String> toUN(List<List<Data?>> rows) {
    final List<String> _delegates = [];

    for (final List<Data?> row in rows) {
      final String? country = row[0]?.value.toString();

      if (country != null && country.isNotEmpty) {
        if (COUNTRIES.values
            .where(
              (_delegate) =>
                  _delegate.toLowerCase() == country.toLowerCase().trim(),
            )
            .isNotEmpty) {
          _delegates.add(
            COUNTRIES.entries
                .where(
                  (_entry) =>
                      _entry.value.toLowerCase() ==
                      country.toLowerCase().trim(),
                )
                .first
                .key,
          );
        } else {
          // TODO: Random String
          COUNTRIES[country] = country;
          DELEGATES[country] = country;

          _delegates.add(country);
        }
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
                        // TODO: Improve Code
                        // TODO: Others Flag
                        // TODO: Make Sure AIPPM & COuntries are not in same committee

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
                              final List<List<Data?>> rows =
                                  excel.tables[table]!.rows;
                              final String type =
                                  rows.removeAt(0)[0]!.value.toString();

                              List<String> _delegates = [];

                              if (type.toLowerCase() == "name") {
                                if (excel.tables[table]!.maxCols != 2) {
                                  return;
                                }

                                _delegates = toAIPPM(rows);
                              } else if (type.toLowerCase() == "country") {
                                if (excel.tables[table]!.maxCols != 1) {
                                  return;
                                }

                                _delegates = toUN(rows);
                              } else {
                                print("Hi");
                                return;
                              }

                              if (_delegates.isNotEmpty) {
                                _delegates.forEach(
                                  (_delegate) =>
                                      _setupController.add(_delegate),
                                );
                                _setupController.update();

                                return;
                              }
                            }

                            print("hi");
                            // TODOD: Check if This Works
                            throw Exception([
                              "The file is invalid. Please Check the file & Try Again."
                            ]);
                          }
                          print("hi");
                        } catch (e, s) {
                          print(e);
                          print(s);
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
                          builder: (context) => DialogBox(
                            heading: "Select Template",
                            content: SizedBox(
                              height: context.height / 2,
                              width: context.width / 2.5,
                              child: ListView.builder(
                                itemCount: COMMITTEES.length * 2 - 1,
                                itemBuilder: (context, index) => index % 2 == 0
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
