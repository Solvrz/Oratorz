import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/pages/home/tabs/export.dart';
import '../../ui/pages/motions/motions.dart';

class TabController extends GetxController {
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
      "name": "Suspension",
      "icon": Icons.pause,
      "tab": const UnmodTab(),
    },
    {
      "name": "Resolution Vote",
      "icon": Icons.restore_page_sharp,
      "tab": const UnmodTab(),
    },
    {
      "name": "Ammendment",
      "icon": Icons.edit_note,
      "tab": const UnmodTab(),
    },
    {
      "name": "Signle Speaker",
      "icon": Icons.mic,
      "tab": const UnmodTab(),
    },
    {
      "name": "Custom",
      "icon": Icons.edit,
      "tab": const UnmodTab(),
    },
    {
      "name": "Motions",
      "icon": Icons.ballot,
      "tab": const MotionsPage(),
    },
  ];

  int get tabVal => tab.value;
  set tabVal(int newTab) => tab.value = newTab;

  Map<String, dynamic> currentTab() => tabsInfo[tab.value];
}
