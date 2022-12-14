import 'package:flutter/material.dart';

import '/ui/pages/committee/modes/gsl.dart';
import '/ui/pages/export.dart';

const List<Map<String, dynamic>> COMMITTEE_TABS = [
  {
    "route": "/committee/gsl",
    "title": "Committee",
    "icon": Icons.groups_outlined,
    "tab": CommitteePage(),
  },
  {
    "route": "/committee/motions",
    "title": "Motions",
    "icon": Icons.ballot_outlined,
    "tab": MotionsPage(),
  },
];

const List<Map<String, dynamic>> COMMITTEE_MODES = [
  {
    "route": "/committee/gsl",
    "name": "GSL",
    "icon": Icons.groups,
    "tab": GSLTab(),
  },
  {
    "route": "/committee/mod",
    "name": "Moderated Caucus",
    "icon": Icons.forum,
    "tab": Text("Moderated Caucus"),
  },
  {
    "route": "/committee/unmod",
    "name": "Unmoderated Caucus",
    "icon": Icons.workspaces,
    "tab": Text("Unmoderated Caucus"),
  },
  {
    "route": "/committee/consulation",
    "name": "Consulation",
    "icon": Icons.circle_outlined,
    "tab": Text("Consulation"),
  },
  {
    "route": "/committee/prayer",
    "name": "Prayer",
    "icon": Icons.church,
    "tab": Text("Prayer"),
  },
  {
    "route": "/committee/adjournment",
    "name": "Adjourn Meeting",
    "icon": Icons.pause,
    "tab": Text("Adjourn Meeting"),
  },
  {
    "route": "/committee/resolution",
    "name": "Resolution Vote",
    "icon": Icons.ballot,
    "tab": Text("Resolution Vote"),
  },
  {
    "route": "/committee/amendmant",
    "name": "Amendment",
    "icon": Icons.published_with_changes,
    "tab": Text("Amendment"),
  },
  {
    "route": "/committee/single",
    "name": "Single Speaker",
    "icon": Icons.mic,
    "tab": Text("Single Speaker"),
  },
  {
    "route": "/committee/custom",
    "name": "Custom",
    "icon": Icons.edit,
    "tab": Text("Custom"),
  },
];
