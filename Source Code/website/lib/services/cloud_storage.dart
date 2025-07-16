// ignore_for_file: avoid_classes_with_only_static_members

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/committee.dart';
import '../tools/controllers/app.dart';
import '../tools/controllers/comittee/committee.dart';
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
}
