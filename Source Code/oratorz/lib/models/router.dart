// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/services/local_storage.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/route.dart';
import '/ui/pages/committee/modes/modes/export.dart';
import '/ui/pages/export.dart';

class AppRoute {
  final String path;
  final String? title;
  final IconData? icon;
  final Widget Function()? builder;

  const AppRoute({
    required this.path,
    this.title,
    this.icon,
    this.builder,
  });
}

class AppRouter {
  static const AppRoute root = AppRoute(path: "/");
  static const AppRoute home = AppRoute(path: "/home", title: "Home");
  static const AppRoute setup = AppRoute(path: "/setup", title: "Setup");

  static List<AppRoute> tabs = [
    const AppRoute(
      path: "/gsl",
      title: "Committee",
      icon: Icons.groups_outlined,
    ),
    AppRoute(
      path: "/vote",
      title: "Vote",
      icon: Icons.how_to_vote,
      builder: () => const VotePage(),
    ),
    AppRoute(
      path: "/motions",
      title: "Motions",
      icon: Icons.ballot_outlined,
      builder: () => const MotionsPage(),
    ),
    AppRoute(
      path: "/score",
      title: "Scorecard",
      icon: Icons.scoreboard_outlined,
      builder: () => const ScorecardPage(),
    ),
  ];

  static List<AppRoute> modes = [
    AppRoute(
      path: "/gsl",
      title: "GSL",
      icon: Icons.groups,
      builder: () => const GSLMode(),
    ),
    AppRoute(
      path: "/mod",
      title: "Moderated Caucus",
      icon: Icons.forum,
      builder: () => const ModMode(),
    ),
    AppRoute(
      path: "/unmod",
      title: "Unmoderated Caucus",
      icon: Icons.workspaces,
      builder: () => const UnmodMode(),
    ),
    AppRoute(
      path: "/consultation",
      title: "Consultation",
      icon: Icons.circle_outlined,
      builder: () => const ConsultationMode(),
    ),
    AppRoute(
      path: "/prayer",
      title: "Prayer",
      icon: Icons.church,
      builder: () => const PrayerMode(),
    ),
    AppRoute(
      path: "/adjournment",
      title: "Adjourn Meeting",
      icon: Icons.pause,
      builder: () => const AdjournMode(),
    ),
    AppRoute(
      path: "/tourdetable",
      title: "Tour de Table",
      icon: Icons.autorenew,
      builder: () => const TourDeTableMode(),
    ),
    AppRoute(
      path: "/single",
      title: "Single Speaker",
      icon: Icons.mic,
      builder: () => const SingleMode(),
    ),
    AppRoute(
      path: "/custom",
      title: "Custom",
      icon: Icons.edit,
      builder: () => const CustomMode(),
    ),
  ];

  static void _putRouteController(GoRouterState state) {
    if (!Get.isRegistered<RouteController>()) {
      Get.put<RouteController>(
        RouteController(
          path: state.subloc,
          args: state.queryParams,
        ),
      );
    } else {
      final RouteController controller = Get.find<RouteController>();

      controller.args = state.queryParams;
      controller.path = state.subloc;
    }
  }

  static GoRouter get router {
    return GoRouter(
      initialLocation: "/",
      errorBuilder: (_, state) {
        log("[GoRouter]: ${state.error}");
        _putRouteController(state);
        return const ErrorPage();
      },
      routes: [
        GoRoute(
          path: root.path,
          redirect: (_, __) => home.path,
        ),
        GoRoute(
          path: setup.path,
          builder: (_, state) {
            _putRouteController(state);
            return const SetupPage();
          },
        ),
        GoRoute(
          path: home.path,
          builder: (_, state) {
            _putRouteController(state);
            return const HomePage();
          },
        ),
        ShellRoute(
          builder: (_, __, child) => CommitteePage(child: child),
          routes: [
            ShellRoute(
              builder: (_, __, child) => ModesPage(child: child),
              routes: modes
                  .map<GoRoute>(
                    (route) => GoRoute(
                      path: route.path,
                      pageBuilder: (_, state) {
                        _putRouteController(state);

                        if (!Get.isRegistered<CommitteeController>()) {
                          LocalStorage.loadCommittee(
                            state.queryParams["id"]!,
                          );
                        }

                        return NoTransitionPage(child: route.builder!());
                      },
                      redirect: (_, state) => LocalStorage.committeeExists(
                        state.queryParams["id"] ?? "null",
                      )
                          ? null
                          : home.path,
                    ),
                  )
                  .toList(),
            ),
            ...List.generate(tabs.length - 1, (index) {
              final AppRoute route = tabs[index + 1];

              return GoRoute(
                path: route.path,
                pageBuilder: (_, state) {
                  _putRouteController(state);

                  if (!Get.isRegistered<CommitteeController>()) {
                    LocalStorage.loadCommittee(state.queryParams["id"]!);
                  }

                  Get.find<CommitteeController>().tab =
                      tabs.indexWhere((route) => route.path == state.subloc);

                  return NoTransitionPage(child: route.builder!());
                },
                redirect: (context, state) => LocalStorage.committeeExists(
                  state.queryParams["id"] ?? "null",
                )
                    ? null
                    : home.path,
              );
            }),
          ],
        ),
      ],
    );
  }
}
