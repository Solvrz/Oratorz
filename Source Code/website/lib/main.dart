import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '/config/constants/constants.dart';
import '/config/theme.dart';
import '/firebase_options.dart';
import '/models/router.dart';
import '/tools/controllers/home.dart';
import '/tools/extensions.dart';

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
      routerConfig: AppRouter.router,
    );
  }
}
