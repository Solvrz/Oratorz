import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/pages/home/tabs/export.dart';

class ModeController extends GetxController {
  RxInt tab = 0.obs;

  List<Map<String, dynamic>> tabsInfo = [
    {
      "name": "GSL",
      "icon": Icons.groups,
      "tab": const GSLTab(),
    },
    {
      "name": "Moderated Caucus",
      "icon": Icons.forum,
      "tab": const ModTab(),
    },
    {
      "name": "Unmoderated Caucus",
      "icon": Icons.connect_without_contact,
      "tab": const UnmodTab(),
    },
    {
      "name": "Consulation",
      "icon": Icons.circle_outlined,
      "tab": const UnmodTab(),
    },
    {
      "name": "Prayer",
      "icon": Icons.church,
      "tab": const UnmodTab(),
    },
    {
      "name": "Adjournment",
      "icon": Icons.pause,
      "tab": const UnmodTab(),
    },
    // TODO: Tooltip
    // TODO: Suspend Users
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
      "name": "Single Speaker",
      "icon": Icons.mic,
      "tab": const UnmodTab(),
    },
    {
      "name": "Custom",
      "icon": Icons.edit,
      "tab": const UnmodTab(),
    },
  ];

  int get tabVal => tab.value;
  set tabVal(int newTab) => tab.value = newTab;

  Map<String, dynamic> currentTab() => tabsInfo[tab.value];
}
