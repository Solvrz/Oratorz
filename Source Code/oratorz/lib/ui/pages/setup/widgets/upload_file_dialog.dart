import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_html/html.dart' as html;

import '/config/constants/data.dart';
import '/tools/controllers/setup.dart';
import '/tools/extensions.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';

class UploadFileDialog extends StatefulWidget {
  const UploadFileDialog({super.key});

  @override
  State<UploadFileDialog> createState() => UploadFileDialogState();
}

class UploadFileDialogState extends State<UploadFileDialog> {
  final SetupController _setupController = Get.find<SetupController>();

  late final DropzoneViewController _dropController;
  bool _dropzoneHovered = false;

  @override
  Widget build(BuildContext context) {
    return DialogBox(
      heading: "Load File",
      content: Container(
        height: context.height / 6.5,
        width: context.width / 3.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: context.theme.colorScheme.secondary),
          color: _dropzoneHovered
              ? Colors.grey.shade400
              : context.theme.colorScheme.primary,
        ),
        child: Stack(
          children: [
            DropzoneView(
              operation: DragOperation.copy,
              cursor: CursorType.grab,
              onCreated: (controller) => _dropController = controller,
              onDrop: (file) async {
                if (context.canPop()) {
                  context.pop();
                }

                loadData(
                  context: context,
                  data: await _dropController.getFileData(file),
                  extension:
                      (await _dropController.getFileMIME(file)).extension,
                );
              },
              onDropMultiple: (files) async {
                if (context.canPop()) {
                  context.pop();
                }

                if (files != null) {
                  for (final dynamic file in files) {
                    loadData(
                      context: context,
                      data: await _dropController.getFileData(file),
                      extension:
                          (await _dropController.getFileMIME(file)).extension,
                    );
                  }
                }
              },
              onHover: () => setState(() => _dropzoneHovered = true),
              onLeave: () => setState(() => _dropzoneHovered = false),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      Icons.description,
                      size: 45,
                      color: context.theme.colorScheme.secondary,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Drag & Drop Files Here",
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.theme.colorScheme.secondary,
                      ),
                      children: [
                        TextSpan(
                          text: "\n(Suported: .xlsx, .xls or .json)",
                          style: context.textTheme.bodySmall,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        RoundedButton(
          border: true,
          child: const Text("Download Template"),
          onPressed: () {
            final html.AnchorElement anchorElement = html.AnchorElement(
              href: "assets/files/Template.xlsx",
            );

            anchorElement.download = "Template";
            anchorElement.click();

            context.pop();
          },
        ),
        const SizedBox(width: 5),
        RoundedButton(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 20,
          ),
          child: const Text("Upload File"),
          onPressed: () async {
            final FilePickerResult? _result =
                await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ["xlsx", "xls"],
            );

            if (_result != null) {
              final PlatformFile _file = _result.files.first;

              loadData(
                context: context,
                data: _file.bytes,
                extension: ".${_file.extension}",
              );
            }

            if (mounted && context.canPop()) {
              context.pop();
            }
          },
        ),
      ],
    );
  }

  void loadData({
    required BuildContext context,
    required Uint8List? data,
    required String? extension,
  }) {
    try {
      if ([".sheet", ".xlsx", ".xls", ".json"].contains(extension)) {
        final Excel excel = Excel.decodeBytes(data ?? []);

        for (final String table in excel.tables.keys) {
          final Sheet? sheet = excel.tables[table];

          if (sheet != null && sheet.maxCols == 3) {
            final List<List<Data?>> rows = sheet.rows;
            final List<String> _delegates = createDelegates(rows..removeAt(0));

            if (_delegates.isNotEmpty) {
              _delegates.forEach((_delegate) {
                if (!_setupController.committee.delegates.contains(_delegate)) {
                  _setupController.add(_delegate);
                }
              });
              _setupController.update();

              return;
            }
          }
        }
      } else {
        // TODO: Error Not Showing on Upload File
        throw UnsupportedError("Invalid File");
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => _ErrorDialog(
            message: [FormatException, UnsupportedError].contains(e.runtimeType)
                ? "Invalid File"
                : "An Unkown Error",
          ),
        );
      }
    }
  }

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
                  .firstWhere(
                    (_entry) =>
                        _entry.value.toLowerCase() == name.toLowerCase().trim(),
                  )
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
                    .firstWhere(
                      (_entry) =>
                          _entry.value.toLowerCase() ==
                          name.toLowerCase().trim(),
                    )
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
                      .toInt;

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
}

class _ErrorDialog extends StatelessWidget {
  final String? message;

  const _ErrorDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return DialogBox(
      heading: message ?? "",
      content: const Text(
        "An Error Occured while loading the file.\nPlease check the file & Try Again...",
      ),
      actions: [
        RoundedButton(
          child: const Text("Ok"),
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
