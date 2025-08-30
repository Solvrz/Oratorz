import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/tools/extensions.dart';
import '../../tools/controllers/app.dart';
import './dialog_box.dart';
import './rounded_button.dart';

class UploadImageDialog extends StatefulWidget {
  final Function(Image) callback;

  const UploadImageDialog({super.key, required this.callback});

  @override
  State<UploadImageDialog> createState() => UploadImageDialogState();
}

class UploadImageDialogState extends State<UploadImageDialog> {
  late final DropzoneViewController _dropController;
  bool _dropzoneHovered = false;
  bool _error = false;

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
            if (kIsWeb)
              DropzoneView(
                operation: DragOperation.copy,
                cursor: CursorType.grab,
                onCreated: (controller) => _dropController = controller,
                onDropFiles: (files) async {
                  if (files != null && context.mounted) {
                    for (final DropzoneFileInterface file in files) {
                      loadData(
                        context: context,
                        data: await _dropController.getFileData(file),
                        extension:
                            (await _dropController.getFileMIME(file)).extension,
                      );
                    }
                  }

                  context.pop();
                },
                onHover: () => setState(() => _dropzoneHovered = true),
                onLeave: () => setState(() => _dropzoneHovered = false),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      Icons.description,
                      size: 45,
                      color: context.theme.colorScheme.secondary,
                    ),
                  ),
                  if (!_error)
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Drag & Drop Image Here",
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.theme.colorScheme.secondary,
                        ),
                        children: [
                          TextSpan(
                            text: "\n(Supported: .jpg, .jpeg, .png)",
                            style: context.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  if (_error)
                    Text(
                      "An Error Occured,\nPlease Check The File & Try Again",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.theme.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        RoundedButton(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 20,
          ),
          child: const Text("Upload File"),
          onPressed: () async {
            final FilePickerResult? _result =
                await FilePicker.platform.pickFiles(
              type: FileType.image,
            );

            if (_result != null) {
              final PlatformFile _file = _result.files.first;

              if (context.mounted) {
                loadData(
                  context: context,
                  data: _file.bytes,
                  extension: ".${_file.extension}",
                );

                context.pop();
              }
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
      setState(() => _error = false);

      if ([".jpg", ".jpeg", ".png"].contains(extension)) {
        Get.find<AppController>().user!.image = Image.memory(
          data!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );

        context.pop();
      } else {
        throw UnsupportedError("Invalid File");
      }
    } catch (e) {
      setState(() => _error = true);
    }
  }
}
