import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '/config/constants.dart';
import '/config/theme.dart';
import '/tools/extensions.dart';
import '/ui/pages/export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = LOCALE.code();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  // await Firebase.initializeApp(
  //   name: "Website",
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // TODO: Set This & firebase.json (Website & Aler)
  // await FirebaseFirestore.instance
  //     .enablePersistence(const PersistenceSettings(synchronizeTabs: true));
  // await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!TESTING);

  // if (TESTING) {
  //   FirebaseFirestore.instance.settings = const Settings(
  //     host: "$IP:9080",
  //     sslEnabled: false,
  //   );
  // }

  runApp(const Website());
}

class Website extends StatelessWidget {
  const Website({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      title: "MUN",
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "/setup": (context) => const SetupPage(),
      },
    );
  }
}
