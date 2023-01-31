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
    Get.delete<RouteController>();
    Get.put<RouteController>(
      RouteController(path: state.location, args: state.queryParams),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            redirect: (_, state) {
              putRouteController(state);

              return "/home";
            },
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
            path: "/committee",
            redirect: (_, state) {
              putRouteController(state);

              return "/committee/gsl?id=${state.queryParams["id"]}";
            },
          ),
          ...List.generate(
            COMMITTEE_TABS.length - 1,
            (index) => GoRoute(
              path: COMMITTEE_TABS[index + 1]["route"],
              builder: (_, state) {
                putRouteController(state);

                return CommitteeMainPage(tab: index + 1);
              },
            ),
          ),
          ...List.generate(
            COMMITTEE_MODES.length,
            (index) => GoRoute(
              path: COMMITTEE_MODES[index]["route"],
              builder: (_, state) {
                putRouteController(state);

                return CommitteeMainPage(mode: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
