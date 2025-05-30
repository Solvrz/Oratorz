// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/services/local_storage.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/route.dart';
import '/ui/pages/committee/modes/modes/export.dart';
import '/ui/pages/export.dart';

class Route {
  final String path;
  final String? title;
  final IconData? icon;
  final Widget Function()? builder;

  const Route({
    required this.path,
    this.title,
    this.icon,
    this.builder,
  });
}

class Router {
  static const Route root = Route(path: "/");
  static const Route home = Route(path: "/home", title: "Home");
  static const Route setup = Route(path: "/setup", title: "Setup");
  static const Route signin = Route(path: "/signin", title: "Sign In");
  static const Route signup = Route(path: "/signup", title: "Sign Up");

  static List<Route> tabs = [
    const Route(
      path: "/gsl",
      title: "Committee",
      icon: Icons.groups_outlined,
    ),
    Route(
      path: "/vote",
      title: "Vote",
      icon: Icons.how_to_vote,
      builder: () => const VotePage(),
    ),
    Route(
      path: "/motions",
      title: "Motions",
      icon: Icons.ballot_outlined,
      builder: () => const MotionsPage(),
    ),
    Route(
      path: "/score",
      title: "Scorecard",
      icon: Icons.scoreboard_outlined,
      builder: () => const ScorecardPage(),
    ),
  ];

  static List<Route> modes = [
    Route(
      path: "/gsl",
      title: "GSL",
      icon: Icons.groups,
      builder: () => const GSLMode(),
    ),
    Route(
      path: "/mod",
      title: "Moderated Caucus",
      icon: Icons.forum,
      builder: () => const ModMode(),
    ),
    Route(
      path: "/unmod",
      title: "Unmoderated Caucus",
      icon: Icons.workspaces,
      builder: () => const UnmodMode(),
    ),
    Route(
      path: "/consultation",
      title: "Consultation",
      icon: Icons.circle_outlined,
      builder: () => const ConsultationMode(),
    ),
    Route(
      path: "/prayer",
      title: "Prayer",
      icon: Icons.church,
      builder: () => const PrayerMode(),
    ),
    Route(
      path: "/adjournment",
      title: "Adjourn Meeting",
      icon: Icons.pause,
      builder: () => const AdjournMode(),
    ),
    Route(
      path: "/tourdetable",
      title: "Tour de Table",
      icon: Icons.autorenew,
      builder: () => const TourDeTableMode(),
    ),
    Route(
      path: "/single",
      title: "Single Speaker",
      icon: Icons.mic,
      builder: () => const SingleMode(),
    ),
    Route(
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
          path: state.matchedLocation,
          args: state.uri.queryParameters,
        ),
      );
    } else {
      final RouteController controller = Get.find<RouteController>();

      controller.args = state.uri.queryParameters;
      controller.path = state.matchedLocation;
    }
  }

  static GoRouter get router {
    return GoRouter(
      initialLocation: "/",
      errorBuilder: (_, state) {
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
        GoRoute(
          path: signup.path,
          builder: (_, state) {
            _putRouteController(state);
            return const SignUpPage();
          },
        ),
        GoRoute(
          path: signin.path,
          builder: (_, state) {
            _putRouteController(state);
            return const SigninPage();
          },
        ),
        ShellRoute(
          builder: (_, state, child) {
            _putRouteController(state);

            if (!Get.isRegistered<CommitteeController>()) {
              LocalStorage.loadCommittee(
                state.uri.queryParameters["id"]!,
              );
            }

            return CommitteePage(child: child);
          },
          routes: [
            ShellRoute(
              builder: (_, state, child) {
                _putRouteController(state);

                if (!Get.isRegistered<CommitteeController>()) {
                  LocalStorage.loadCommittee(
                    state.uri.queryParameters["id"]!,
                  );
                }

                return ModesPage(child: child);
              },
              routes: modes
                  .map<GoRoute>(
                    (route) => GoRoute(
                      path: route.path,
                      pageBuilder: (_, state) {
                        _putRouteController(state);

                        // if (!Get.isRegistered<CommitteeController>()) {
                        //   LocalStorage.loadCommittee(
                        //     state.uri.queryParameters["id"]!,
                        //   );
                        // }

                        return NoTransitionPage(child: route.builder!());
                      },
                      redirect: (_, state) => LocalStorage.committeeExists(
                        state.uri.queryParameters["id"] ?? "null",
                      )
                          ? null
                          : home.path,
                    ),
                  )
                  .toList(),
            ),
            ...List.generate(tabs.length - 1, (index) {
              final Route route = tabs[index + 1];

              return GoRoute(
                path: route.path,
                pageBuilder: (_, state) {
                  _putRouteController(state);

                  if (!Get.isRegistered<CommitteeController>()) {
                    LocalStorage.loadCommittee(
                      state.uri.queryParameters["id"]!,
                    );
                  }

                  return NoTransitionPage(child: route.builder!());
                },
                redirect: (context, state) => LocalStorage.committeeExists(
                  state.uri.queryParameters["id"] ?? "null",
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
