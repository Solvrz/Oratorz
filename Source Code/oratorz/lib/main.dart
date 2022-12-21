import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/config/constants/constants.dart';
import '/config/theme.dart';
import '/tools/controllers/route.dart';
import '/tools/extensions.dart';
import '/ui/pages/export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = LOCALE.code();

  setUrlStrategy(PathUrlStrategy());

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  runApp(const Oratorz());
}

class Oratorz extends StatelessWidget {
  const Oratorz({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: "Oratorz",
        theme: OratorzTheme.of(context),
        routerConfig: GoRouter(
          initialLocation: "/setup",
          errorBuilder: (context, args) {
            Get.put(RouteController(arguments: args));

            return const Text("Error");
          },
          routes: [
            GoRoute(
              path: "/setup",
              builder: (context, args) {
                Get.put(RouteController(arguments: args));

                return const SetupPage();
              },
            ),
            GoRoute(
              path: "/home",
              builder: (context, args) {
                Get.put(RouteController(arguments: args));

                return const HomePage();
              },
            ),
            GoRoute(
              path: "/committee/:mode",
              builder: (context, args) {
                Get.put(RouteController(arguments: args));

                return const CommitteeMainPage();
              },
            ),
          ],
        ),
      );
}
