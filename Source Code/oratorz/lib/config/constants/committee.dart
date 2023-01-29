import 'package:flutter/material.dart';

import '/ui/pages/committee/export.dart';
import '/ui/pages/committee/modes/modes/export.dart';

const List<Map<String, dynamic>> COMMITTEE_TABS = [
  {
    "route": "/mode/gsl",
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
  {
    "route": "/score",
    "title": "Scorecard",
    "icon": Icons.scoreboard_outlined,
    "tab": ScorecardPage(),
  },
];

const List<Map<String, dynamic>> COMMITTEE_MODES = [
  {
    "route": "/mode/gsl",
    "name": "GSL",
    "icon": Icons.groups,
    "tab": GSLTab(),
  },
  {
    "route": "/mode/mod",
    "name": "Moderated Caucus",
    "icon": Icons.forum,
    "tab": ModTab(),
  },
  {
    "route": "/mode/unmod",
    "name": "Unmoderated Caucus",
    "icon": Icons.workspaces,
    "tab": UnmodTab(),
  },
  {
    "route": "/mode/consultation",
    "name": "Consultation",
    "icon": Icons.circle_outlined,
    "tab": ConsultationTab(),
  },
  {
    "route": "/mode/prayer",
    "name": "Prayer",
    "icon": Icons.church,
    "tab": PrayerTab(),
  },
  {
    "route": "/mode/adjournment",
    "name": "Adjourn Meeting",
    "icon": Icons.pause,
    "tab": AdjournTab(),
  },
  {
    "route": "/mode/tourdetable",
    "name": "Tour de Table",
    "icon": Icons.autorenew,
    "tab": TourDeTableTab(),
  },
  {
    "route": "/mode/single",
    "name": "Single Speaker",
    "icon": Icons.mic,
    "tab": SingleTab(),
  },
  {
    "route": "/mode/custom",
    "name": "Custom",
    "icon": Icons.edit,
    "tab": CustomTab(),
  },
];
