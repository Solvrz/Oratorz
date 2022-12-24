import 'package:flutter/material.dart';

import '/ui/pages/committee/committee/modes/export.dart';
import '/ui/pages/committee/export.dart';

const List<Map<String, dynamic>> COMMITTEE_TABS = [
  {
    "route": "/committee/gsl",
    "title": "Committee",
    "icon": Icons.groups_outlined,
    "tab": CommitteePage(),
  },
  {
    "route": "/vote",
    "title": "Vote",
    "icon": Icons.how_to_vote,
    "tab": VotePage(),
  },
  {
    "route": "/motions",
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
    "tab": ModTab(),
  },
  {
    "route": "/committee/unmod",
    "name": "Unmoderated Caucus",
    "icon": Icons.workspaces,
    "tab": UnmodTab(),
  },
  {
    "route": "/committee/consultation",
    "name": "Consultation",
    "icon": Icons.circle_outlined,
    "tab": ConsultationTab(),
  },
  {
    "route": "/committee/prayer",
    "name": "Prayer",
    "icon": Icons.church,
    "tab": PrayerTab(),
  },
  {
    "route": "/committee/adjournment",
    "name": "Adjourn Meeting",
    "icon": Icons.pause,
    "tab": AdjournTab(),
  },
  {
    "route": "/committee/tourdetable",
    "name": "Tour de Table",
    "icon": Icons.autorenew,
    "tab": TourDeTableTab(),
  },
  {
    "route": "/committee/single",
    "name": "Single Speaker",
    "icon": Icons.mic,
    "tab": SingleTab(),
  },
  {
    "route": "/committee/custom",
    "name": "Custom",
    "icon": Icons.edit,
    "tab": CustomTab(),
  },
];
