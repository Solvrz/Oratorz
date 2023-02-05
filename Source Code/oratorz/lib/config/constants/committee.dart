import 'package:flutter/material.dart';

import '/ui/pages/committee/export.dart';
import '/ui/pages/committee/modes/modes/export.dart';

final List<Map<String, dynamic>> COMMITTEE_TABS = [
  {
    "route": "/mode/gsl",
    "title": "Committee",
    "icon": Icons.groups_outlined,
  },
  {
    "route": "/vote",
    "title": "Vote",
    "icon": Icons.how_to_vote,
    "tab": () => const VotePage(),
  },
  {
    "route": "/motions",
    "title": "Motions",
    "icon": Icons.ballot_outlined,
    "tab": () => const MotionsPage(),
  },
  {
    "route": "/score",
    "title": "Scorecard",
    "icon": Icons.scoreboard_outlined,
    "tab": () => const ScorecardPage(),
  },
];

final List<Map<String, dynamic>> COMMITTEE_MODES = [
  {
    "route": "/mode/gsl",
    "name": "GSL",
    "icon": Icons.groups,
    "tab": () => const GSLTab(),
  },
  {
    "route": "/mode/mod",
    "name": "Moderated Caucus",
    "icon": Icons.forum,
    "tab": () => const ModTab(),
  },
  {
    "route": "/mode/unmod",
    "name": "Unmoderated Caucus",
    "icon": Icons.workspaces,
    "tab": () => const UnmodTab(),
  },
  {
    "route": "/mode/consultation",
    "name": "Consultation",
    "icon": Icons.circle_outlined,
    "tab": () => const ConsultationTab(),
  },
  {
    "route": "/mode/prayer",
    "name": "Prayer",
    "icon": Icons.church,
    "tab": () => const PrayerTab(),
  },
  {
    "route": "/mode/adjournment",
    "name": "Adjourn Meeting",
    "icon": Icons.pause,
    "tab": () => const AdjournTab(),
  },
  {
    "route": "/mode/tourdetable",
    "name": "Tour de Table",
    "icon": Icons.autorenew,
    "tab": () => const TourDeTableTab(),
  },
  {
    "route": "/mode/single",
    "name": "Single Speaker",
    "icon": Icons.mic,
    "tab": () => const SingleTab(),
  },
  {
    "route": "/mode/custom",
    "name": "Custom",
    "icon": Icons.edit,
    "tab": () => const CustomTab(),
  },
];
