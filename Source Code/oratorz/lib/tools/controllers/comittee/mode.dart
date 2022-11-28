import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/pages/committee/modes/export.dart';

class ModeController extends GetxController {
  late RxInt mode;

  ModeController({int modeVal = 0}) {
    mode = RxInt(modeVal);
  }

  static final List<Map<String, dynamic>> modesInfo = [
    {
      "route": "/home/committee/gsl",
      "name": "GSL",
      "icon": Icons.groups,
      "tab": const GSLTab(),
    },
    {
      "route": "/home/committee/mod",
      "name": "Moderated Caucus",
      "icon": Icons.forum,
      "tab": Container(),
    },
    {
      "route": "/home/committee/unmod",
      "name": "Unmoderated Caucus",
      "icon": Icons.connect_without_contact,
      "tab": Container(),
    },
    {
      "route": "/home/committee/consulation",
      "name": "Consulation",
      "icon": Icons.circle_outlined,
      "tab": Container(),
    },
    {
      "route": "/home/committee/prayer",
      "name": "Prayer",
      "icon": Icons.church,
      "tab": Container(),
    },
    {
      "route": "/home/committee/adjournment",
      "name": "Adjournment",
      "icon": Icons.pause,
      "tab": Container(),
    },
    // TODO: Confrence App
    // {
    //   "name": "Resolution Vote",
    //   "icon": Icons.restore_page_sharp,
    //   "tab": const UnmodTab(),
    // },
    // {
    //   "name": "Amendment",
    //   "icon": Icons.edit_note,
    //   "tab": const UnmodTab(),
    // },
    {
      "route": "/home/committee/single",
      "name": "Single Speaker",
      "icon": Icons.mic,
      "tab": Container(),
    },
    {
      "route": "/home/committee/custom",
      "name": "Custom",
      "icon": Icons.edit,
      "tab": Container(),
    },
  ];

  List<Map<String, dynamic>> get modes => modesInfo;

  int get modeVal => mode.value;
  set modeVal(int newMode) => mode.value = newMode;

  Map<String, dynamic> currentTab() => modes[mode.value];
}
