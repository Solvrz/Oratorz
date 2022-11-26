import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:intl/intl.dart';

import '/config/constants.dart';
import '/config/theme.dart';
import '/firebase_options.dart';
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

  // TODO: Set This & firebase.json (Website & Aler)
  // if (TESTING) {
  //   await auth.useAuthEmulator(IP, 9099);
  //   firestore.settings = const Settings(host: "$IP:9080");
  //   await storage.useStorageEmulator(IP, 9199);
  //   await analytics.setAnalyticsCollectionEnabled(false);
  // }

  runApp(const Oratorz());
}

class Oratorz extends StatelessWidget {
  const Oratorz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: OratorzTheme.of(context),
      title: "Oratorz",
      // TODO: Change after Testing
      // initialRoute: "/setup",
      initialRoute: "/home",
      routes: {
        // TODO: Confrence App
        // "/": (context) => const WelcomePage(),
        "/home": (context) => const HomePage(),
        "/setup": (context) => const SetupPage(),
        // "/home/motion": (context) => const MotionsPage(),
      },
      builder: (context, widget) {
        theme = OratorzTheme.of(context);

        return widget!;
      },
    );
  }
}
