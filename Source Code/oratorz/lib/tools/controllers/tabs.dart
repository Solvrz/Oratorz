import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/pages/export.dart';

class TabController extends GetxController {
  late RxInt tab;

  TabController({int tabVal = 0}) {
    tab = RxInt(tabVal);
  }

  static final List<Map<String, dynamic>> tabsInfo = [
    {
      "route": "/home/committee/gsl",
      "title": "Committee",
      "icon": Icons.groups_outlined,
      "tab": const CommitteePage(),
    },
    {
      "route": "/home/motions",
      "title": "Motions",
      "icon": Icons.ballot_outlined,
      "tab": const MotionsPage(),
    },
  ];

  List<Map<String, dynamic>> tabs = tabsInfo;

  int get tabVal => tab.value;
  set tabVal(int newTab) => tab.value = newTab;

  Map<String, dynamic> currentTab() => tabsInfo[tab.value];
}
