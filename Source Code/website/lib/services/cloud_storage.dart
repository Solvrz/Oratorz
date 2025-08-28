// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../config/constants.dart';
import '../models/committee.dart';
import '../models/router.dart';
import '../models/scorecard.dart';
import '../tools/controllers/app.dart';
import '../tools/controllers/comittee/autosave.dart';
import '../tools/controllers/comittee/committee.dart';
import '../tools/controllers/comittee/motions.dart';
import '../tools/controllers/comittee/scorecard.dart';
import '../tools/controllers/comittee/speech.dart';
import '../tools/controllers/comittee/vote.dart';
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

    if (committee.currDay == -1) return false;

    if (!controller.hasData("scorecard") || !controller.hasData("rollCall")) {
      final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection("committees")
          .doc(committee.id)
          .collection("days")
          .doc(controller.selectedDay.toString())
          .get();

      if (doc.exists) {
        if (!controller.hasData("rollCall")) {
          committee.rollCall = Map<String, int>.from(doc.data()!["rollCall"]);
        }

        if (!controller.hasData("scorecard")) {
          committee.scorecard =
              Scorecard.fromJson(doc.data()!["scorecard"]).obs;
        }
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

      controller.addData("rollCall", committee.rollCall);
      controller.addData("scorecard", committee.scorecard!.toJson());

      if (Get.isRegistered<ScorecardController>()) {
        Get.find<AutoSaveController>().timers.remove("scorecard");
        Get.find<ScorecardController>().onInit();
      }
    } else {
      committee.rollCall = controller.fetchData("rollCall") as Map<String, int>;
      committee.scorecard =
          Scorecard.fromJson(controller.fetchData("scorecard")).obs;
    }

    return true;
  }

  static Future<void> saveRollCall() async {
    final CommitteeController controller = Get.find<CommitteeController>();

    controller.addData("rollCall", controller.committee.rollCall);

    await FirebaseFirestore.instance
        .collection("committees")
        .doc(controller.committee.id)
        .collection("days")
        .doc(controller.selectedDay.toString())
        .update({"rollCall": controller.committee.rollCall});
  }

  static Future<void> saveScorecard({Map<String, dynamic>? data}) async {
    final CommitteeController controller = Get.find<CommitteeController>();

    controller.addData(
      "scorecard",
      data ?? controller.committee.scorecard!.value.toJson(),
    );

    print("SAVING SCORECARD\tDAY: ${controller.selectedDay.value + 1}");

    await FirebaseFirestore.instance
        .collection("committees")
        .doc(controller.committee.id)
        .collection("days")
        .doc(controller.selectedDay.toString())
        .update({
      "scorecard": data ?? controller.committee.scorecard!.value.toJson(),
    });
  }

  static Future<bool> fetchCaucus(String tag) async {
    final CommitteeController controller = Get.find<CommitteeController>();

    if (!Get.isRegistered<SpeechController>(tag: tag)) {
      Get.put<SpeechController>(SpeechController(tag), tag: tag);
    }

    if (controller.hasData(tag)) {
      Get.find<SpeechController>(tag: tag)
          .updateFromJson(controller.fetchData(tag));
      return true;
    }

    final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection("committees")
        .doc(controller.committee.id)
        .collection("days")
        .doc(controller.selectedDay.toString())
        .collection("caucus")
        .doc(tag)
        .get();

    if (doc.exists) {
      Get.find<SpeechController>(tag: tag).updateFromJson(doc.data()!);
    } else {
      Get.find<SpeechController>(tag: tag)
          .updateFromJson(SpeechController(tag).toJson());
      await saveCaucus(tag);
    }

    controller.addData(tag, Get.find<SpeechController>(tag: tag).toJson());

    return true;
  }

  static Future<void> saveCaucus(String tag) async {
    final CommitteeController controller = Get.find<CommitteeController>();
    final SpeechController speechController =
        Get.find<SpeechController>(tag: tag);

    controller.addData(tag, speechController.toJson());

    print("SAVING CAUCUS-$tag");

    await FirebaseFirestore.instance
        .collection("committees")
        .doc(controller.committee.id)
        .collection("days")
        .doc(controller.selectedDay.toString())
        .collection("caucus")
        .doc(tag)
        .set(speechController.toJson());
  }

  static Future<void> addMotion(Map<String, dynamic> motion) async {
    final CommitteeController controller = Get.find<CommitteeController>();

    await FirebaseFirestore.instance
        .collection("committees")
        .doc(controller.committee.id)
        .collection("days")
        .doc(controller.committee.currDay.toString())
        .collection("motions")
        .add(motion);
  }

  static Future<List<Map<String, dynamic>>> fetchPastMotions() async {
    final CommitteeController controller = Get.find<CommitteeController>();
    final MotionsController motionsController = Get.find<MotionsController>();

    if (motionsController.pastMotions.isNotEmpty) {
      return motionsController.pastMotions;
    }

    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection("committees")
            .doc(controller.committee.id)
            .collection("days")
            .doc(controller.committee.currDay.toString())
            .collection("motions")
            .get();

    querySnapshot.docs.forEach(
      (docSnapshot) {
        final Map<String, dynamic> data = docSnapshot.data();
        data["id"] = docSnapshot.id;

        motionsController.pastMotions.add(data);
      },
    );

    return motionsController.pastMotions;
  }

  static Future<void> uploadVote() async {
    final CommitteeController controller = Get.find<CommitteeController>();
    final VoteController voteController = Get.find<VoteController>(tag: "vote");

    final Map<String, dynamic> data = voteController.toJson();

    data["timestamp"] = Timestamp.now().millisecondsSinceEpoch;
    data["result"] = voteController.inFavor >= voteController.majorityVal();

    await FirebaseFirestore.instance
        .collection("committees")
        .doc(controller.committee.id)
        .collection("days")
        .doc(controller.committee.currDay.toString())
        .collection("votes")
        .add(data);

    voteController.addVoteData(data);
  }

  static Future<List<Map<String, dynamic>>> fetchPastVotes() async {
    final CommitteeController controller = Get.find<CommitteeController>();
    final VoteController voteController = Get.find<VoteController>(tag: "vote");

    if (voteController.pastVotes.isNotEmpty) {
      return voteController.pastVotes;
    }

    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection("committees")
            .doc(controller.committee.id)
            .collection("days")
            .doc(controller.committee.currDay.toString())
            .collection("votes")
            .get();

    querySnapshot.docs.forEach(
      (docSnapshot) {
        final Map<String, dynamic> data = docSnapshot.data();
        data["id"] = docSnapshot.id;

        voteController.pastVotes.add(data);
      },
    );

    return voteController.pastVotes;
  }
}
