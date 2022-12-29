import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/config/constants/constants.dart';
import '/config/theme.dart';
import '/services/local_storage.dart';
import '/tools/controllers/route.dart';
import '/tools/extensions.dart';
import '/ui/pages/export.dart';

void main() async {
  // TODO: Storage remove past voters from current
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = LOCALE.code;

  await GetStorage.init();

  setUrlStrategy(PathUrlStrategy());
  runApp(const Oratorz());
}

class Oratorz extends StatelessWidget {
  const Oratorz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Oratorz",
      theme: OratorzTheme.of(context),
      routerConfig: GoRouter(
        initialLocation: "/",
        errorBuilder: (_, args) {
          Get.put(RouteController(arguments: args));

          return const Text("Error");
        },
        routes: [
          GoRoute(
            path: "/",
            redirect: (_, __) {
              final exists = LocalStorage.loadCommittee();

              return exists ? "/committee/gsl" : "/setup";
            },
          ),
          GoRoute(
            path: "/setup",
            builder: (_, args) {
              Get.put(RouteController(arguments: args));

              return const SetupPage();
            },
          ),
          GoRoute(
            path: "/:tab",
            builder: (_, args) {
              Get.put(RouteController(arguments: args));

              return const CommitteeMainPage();
            },
          ),
          GoRoute(path: "/committee", redirect: (_, __) => "/committee/gsl"),
          GoRoute(
            path: "/committee/:mode",
            builder: (_, args) {
              Get.put(RouteController(arguments: args));

              return const CommitteeMainPage();
            },
          ),
        ],
      ),
    );
  }
}
