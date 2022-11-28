import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/config/constants.dart';
import '/config/theme.dart';
import '/firebase_options.dart';
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

  final FirebaseApp app = await Firebase.initializeApp(
    name: "Oratorz",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  auth = FirebaseAuth.instanceFor(app: app);
  firestore = FirebaseFirestore.instanceFor(app: app);
  storage = FirebaseStorage.instanceFor(app: app);
  analytics = FirebaseAnalytics.instanceFor(app: app);

  await auth.setPersistence(Persistence.LOCAL);

  if (TESTING) {
    await auth.useAuthEmulator(IP, 9099);
    firestore.settings = const Settings(host: "$IP:9080");
    await storage.useStorageEmulator(IP, 9199);
    await analytics.setAnalyticsCollectionEnabled(false);
  }

  runApp(const Oratorz());
}

// TODO: Tooltip
// TODO: Restoration
// TODO: Responsive
// TODO: Suspend Users
// TODO: Unkown Routes
// TODO: Migrate to go_router
class Oratorz extends StatelessWidget {
  const Oratorz({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: "Oratorz",
        theme: OratorzTheme.of(context),
        builder: (context, widget) {
          theme = OratorzTheme.of(context);

          return widget!;
        },
        routerConfig: GoRouter(
          // TODO: Change This
          initialLocation: "/home/committee/gsl",
          errorBuilder: (context, args) {
            Get.put(RouteController(arguments: args));

            // TODO: Error Page
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
              path: "/home/:tab",
              builder: (context, args) {
                Get.put(RouteController(arguments: args));

                return const HomePage();
              },
            ),
            GoRoute(
              path: "/home/:tab/:mode",
              builder: (context, args) {
                Get.put(RouteController(arguments: args));

                return const HomePage();
              },
            ),
          ],
        ),
      );
}
