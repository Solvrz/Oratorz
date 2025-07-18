import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '/models/scorecard.dart';
import '/services/local_storage.dart';
import './committee.dart';
import 'autosave.dart';

class ScorecardController extends GetxController {
  late final Rx<Scorecard> _scorecard;
  final RxInt mode = 0.obs;
  final RxInt sort = 0.obs;
  final RxString query = "".obs;

  Scorecard get scorecard => _scorecard.value;
  int get sortIndex => scorecard.parameters
      .indexWhere((element) => element.id == sort.value.abs());

  void toggleMode() => mode.value = mode.value == 0 ? 1 : 0;

  final RxList<dynamic> selected = ["", 0].obs;

  ScorecardController([Scorecard? scorecard]) {
    _scorecard =
        (scorecard ?? Scorecard(Get.find<CommitteeController>().committee)).obs;

    ever(_scorecard, (value) {
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
        .doc("0")
        .update({"scorecard": _scorecard.value.toJson()});
  }

  void addParameter(String title, int maxScore) {
    _scorecard.update((val) {
      if (val != null) {
        val.parameters.add(Parameter(title, maxScore));
        val.scores.values.forEach((score) => score.add(0));
      }
    });

    _saveScores();
  }

  void deleteParameter(int index) {
    _scorecard.update((val) {
      if (val != null) {
        val.parameters.removeAt(index);
        val.scores.values.forEach((score) => score.removeAt(index));
      }
    });

    _saveScores();
  }

  void reorderParameter(int index) {
    _scorecard.update((val) {
      if (val != null) {
        val.parameters.insert(index + 1, val.parameters.removeAt(index));

        val.scores.values.forEach(
          (score) => score.insert(index + 1, score.removeAt(index)),
        );
      }
    });

    _saveScores();
  }

  void updateParameter(Parameter parameter, String title, int maxScore) {
    _scorecard.update((val) {
      if (val != null) {
        parameter.title = title;
        parameter.maxScore = maxScore;
      }
    });

    _saveScores();
  }

  void _saveScores() {
    LocalStorage.updateScore(
      "parameters",
      scorecard.parameters.map<String>((e) => e.title).toList(),
    );

    LocalStorage.updateScore(
      "maxScores",
      scorecard.parameters.map<int>((e) => e.maxScore).toList(),
    );

    LocalStorage.updateScore("scores", scorecard.scores);
  }

  void updateScore(String delegate, int index, double score) {
    _scorecard.update((val) {
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

    _saveScores();
  }
}
