import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '/config/constants/constants.dart';
import '/config/theme.dart';
import '/firebase_options.dart';
import '/tools/controllers/route.dart';
import '/tools/extensions.dart';
import '/ui/pages/export.dart';
import 'config/constants/committee.dart';
import 'services/local_storage.dart';
import 'tools/controllers/comittee/committee.dart';
import 'tools/controllers/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = LOCALE.code;
  await initializeDateFormatting(Intl.defaultLocale);

  await GetStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  analytics = FirebaseAnalytics.instance;

  await analytics.setAnalyticsCollectionEnabled(!kDebugMode);
  await analytics.logAppOpen();

  setUrlStrategy(PathUrlStrategy());
  runApp(const Oratorz());
}

class Oratorz extends StatelessWidget {
  const Oratorz({super.key});

  void putRouteController(GoRouterState state) {
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

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<HomeController>()) {
      Get.put<HomeController>(HomeController());
    }

    return MaterialApp.router(
      title: "Oratorz",
      theme: OratorzTheme.of(context),
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse},
      ),
      routerConfig: GoRouter(
        initialLocation: "/",
        errorBuilder: (_, state) {
          log("[GoRouter]: ${state.error}");

          putRouteController(state);

          return const ErrorPage();
        },
        routes: [
          GoRoute(
            path: "/",
            redirect: (_, __) => "/home",
          ),
          GoRoute(
            path: "/setup",
            builder: (_, state) {
              putRouteController(state);

              return const SetupPage();
            },
          ),
          GoRoute(
            path: "/home",
            builder: (_, state) {
              putRouteController(state);

              return const HomePage();
            },
          ),
          GoRoute(
            path: "/mode",
            redirect: (_, state) => "/mode/gsl?id=${state.queryParams["id"]}",
          ),
          ShellRoute(
            builder: (_, __, child) => CommitteeMainPage(child: child),
            routes: [
              ShellRoute(
                builder: (_, __, child) => CommitteePage(child: child),
                routes: COMMITTEE_MODES
                    .map<GoRoute>(
                      (data) => GoRoute(
                        path: data["route"],
                        pageBuilder: (_, state) {
                          putRouteController(state);

                          if (!Get.isRegistered<CommitteeController>()) {
                            LocalStorage.loadCommittee(
                              state.queryParams["id"]!,
                            );
                          }

                          return NoTransitionPage(child: data["tab"]());
                        },
                        redirect: (_, state) => LocalStorage.committeeExists(
                          state.queryParams["id"] ?? "null",
                        )
                            ? null
                            : "/home",
                      ),
                    )
                    .toList(),
              ),
              ...List.generate(COMMITTEE_TABS.length - 1, (index) {
                final Map<String, dynamic> data = COMMITTEE_TABS[index + 1];

                return GoRoute(
                  path: data["route"],
                  pageBuilder: (_, state) {
                    putRouteController(state);

                    if (!Get.isRegistered<CommitteeController>()) {
                      LocalStorage.loadCommittee(state.queryParams["id"]!);
                    }

                    Get.find<CommitteeController>().tab = COMMITTEE_TABS
                        .indexWhere((tab) => tab["route"] == state.subloc);

                    return NoTransitionPage(child: data["tab"]());
                  },
                  redirect: (context, state) => LocalStorage.committeeExists(
                    state.queryParams["id"] ?? "null",
                  )
                      ? null
                      : "/home",
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
