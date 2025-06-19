import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:get_storage/get_storage.dart';
import 'package:url_strategy/url_strategy.dart';

import '/config/constants.dart';
import '/config/theme.dart';
import '/firebase_options.dart';
import '/models/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await ANALYTICS.setAnalyticsCollectionEnabled(!TESTING);
  await ANALYTICS.logAppOpen();

  await GetStorage.init();

  setPathUrlStrategy();
  runApp(const Oratorz());
}

class Oratorz extends StatelessWidget {
  const Oratorz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Oratorz",
      theme: OratorzTheme.of(context),
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse},
      ),
      routerConfig: Router.router,
    );
  }
}
