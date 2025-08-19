import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '/config/constants.dart';
import '/config/theme.dart';
import '/firebase_options.dart';
import '/models/router.dart';
import '/models/user.dart';
import '/tools/controllers/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await ANALYTICS.setAnalyticsCollectionEnabled(!TESTING);
  await ANALYTICS.logAppOpen();

  await GetStorage.init();

  usePathUrlStrategy();

  if (FirebaseAuth.instance.currentUser != null) {
    final Map<String, dynamic> data = (await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .get())
        .data()!;

    Get.put<AppController>(AppController(user: User.fromJson(data)));
  } else {
    Get.put<AppController>(AppController());
  }

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
