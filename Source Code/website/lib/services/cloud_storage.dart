// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../config/constants.dart';
import '../models/committee.dart';
import '../models/router.dart';
import '../models/scorecard.dart';
import '../tools/controllers/app.dart';
import '../tools/controllers/comittee/committee.dart';
import '../tools/controllers/comittee/scorecard.dart';
import '../tools/controllers/route.dart';
import '../tools/controllers/setup.dart';

class CloudStorage {
  static AppController get appController => Get.find<AppController>();

  static Future<void> updateUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(appController.user!.email)
        .set(appController.user!.toJson());
  }

  static Future<void> createCommittee() async {
    final Committee committee = Get.find<SetupController>().committee;

    await FirebaseFirestore.instance
        .collection("committees")
        .doc(committee.id)
        .set(committee.toJson());

    await updateUser();
  }

  static Future<void> deleteCommittee(Committee committee) async {
    await FirebaseFirestore.instance
        .collection("committees")
        .doc(committee.id)
        .delete();

    await updateUser();
  }

  static Future<void> updateCommitte() async {
    final Committee committee = Get.find<CommitteeController>().committee;

    await FirebaseFirestore.instance
        .collection("committees")
        .doc(committee.id)
        .set(committee.toJson());
  }

  static Future<Committee?> fetchCommittee(String? id) async {
    final Committee? committee =
        await Get.find<AppController>().user!.fetchCommittee(id);

    if (committee == null) return null;

    if (!Get.isRegistered<CommitteeController>()) {
      final CommitteeController controller =
          CommitteeController(committee: committee);
      controller.tab = Router.tabs.indexWhere(
        (route) => route.path == Get.find<RouteController>().path,
      );

      Get.put<CommitteeController>(controller);

      unawaited(ANALYTICS.logEvent(name: "committe_loaded"));
    }

    await fetchDayData();

    return committee;
  }

  static Future<bool> fetchDayData() async {
    final CommitteeController controller = Get.find<CommitteeController>();
    final Committee committee = controller.committee;

    if (committee.rollCall.isEmpty ||
        committee.scorecard == null ||
        controller.refetch) {
      final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection("committees")
          .doc(committee.id)
          .collection("days")
          .doc(controller.selectedDay.toString())
          .get();

      if (doc.exists) {
        if (!controller.refetch) {
          committee.rollCall = Map<String, int>.from(doc.data()!["rollCall"]);
        }
        committee.scorecard = Scorecard.fromJson(doc.data()!["scorecard"]).obs;
      } else {
        committee.initRollCall();
        committee.scorecard = Scorecard(committee).obs;

        await FirebaseFirestore.instance
            .collection("committees")
            .doc(committee.id)
            .collection("days")
            .doc(controller.selectedDay.toString())
            .set({
          "rollCall": committee.rollCall,
          "scorecard": committee.scorecard!.toJson(),
        });
      }

      if (Get.isRegistered<ScorecardController>()) {
        Get.find<ScorecardController>().onInit();
      }
    }

    controller.refetch = false;
    return true;
  }

  static Future<void> saveRollCall() async {
    final CommitteeController controller = Get.find<CommitteeController>();

    await FirebaseFirestore.instance
        .collection("committees")
        .doc(controller.committee.id)
        .collection("days")
        .doc(controller.selectedDay.toString())
        .update({"rollCall": controller.committee.rollCall});
  }

  static Future<void> saveScorecard({Map<String, dynamic>? data}) async {
    final CommitteeController controller = Get.find<CommitteeController>();

    if (data != null) {
      await FirebaseFirestore.instance
          .collection("committees")
          .doc(controller.committee.id)
          .collection("days")
          .doc(controller.selectedDay.toString())
          .update({"scorecard": data});
    } else {
      await FirebaseFirestore.instance
          .collection("committees")
          .doc(controller.committee.id)
          .collection("days")
          .doc(controller.selectedDay.toString())
          .update({
        "scorecard": controller.committee.scorecard!.value.toJson(),
      });
    }
  }
}
