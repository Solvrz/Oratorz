import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '/models/scorecard.dart';
import './committee.dart';
import 'autosave.dart';

class ScorecardController extends GetxController {
  final RxInt mode = 0.obs;
  final RxInt sort = 0.obs;
  final RxString query = "".obs;

  Rx<Scorecard> get scorecard =>
      Get.find<CommitteeController>().committee.scorecard!;

  int get sortIndex => scorecard.value.parameters
      .indexWhere((element) => element.id == sort.value.abs());

  void toggleMode() => mode.value = mode.value == 0 ? 1 : 0;

  final RxList<dynamic> selected = ["", 0].obs;

  ScorecardController() {
    ever(scorecard, (value) {
      Get.find<AutoSaveController>().debounceSave("scorecard", syncToFirebase);
    });
  }

  void syncToFirebase() {
    print("AUTOSAVE SCORECARD");

    final CommitteeController controller = Get.find<CommitteeController>();

    FirebaseFirestore.instance
        .collection("committees")
        .doc(controller.committee.id)
        .collection("days")
        .doc(controller.selectedDay.toString())
        .update({"scorecard": controller.committee.scorecard!.value.toJson()});
  }

  void addParameter(String title, int maxScore) => scorecard.update((val) {
        if (val != null) {
          val.parameters.add(Parameter(title, maxScore));
          val.scores.values.forEach((score) => score.add(0));
        }
      });

  void deleteParameter(int index) => scorecard.update((val) {
        if (val != null) {
          val.parameters.removeAt(index);
          val.scores.values.forEach((score) => score.removeAt(index));
        }
      });

  void reorderParameter(int index) => scorecard.update((val) {
        if (val != null) {
          val.parameters.insert(index + 1, val.parameters.removeAt(index));

          val.scores.values.forEach(
            (score) => score.insert(index + 1, score.removeAt(index)),
          );
        }
      });

  void updateParameter(Parameter parameter, String title, int maxScore) =>
      scorecard.update((val) {
        if (val != null) {
          parameter.title = title;
          parameter.maxScore = maxScore;
        }
      });

  void updateScore(String delegate, int index, double score) =>
      scorecard.update((val) {
        if (val != null) {
          val.scores.update(
            delegate,
            (value) {
              value[index] = score;
              return value;
            },
          );
        }
      });
}
