import 'package:get/get.dart';

import '/services/local_storage.dart';
import './committee.dart';

class Parameter {
  String title;
  int maxScore;

  Parameter(this.title, this.maxScore);

  @override
  String toString() => "$title ($maxScore)";
}

class ScorecardController extends GetxController {
  final RxList<Parameter> parameters = [
    Parameter("GSL", 10),
    Parameter("Mod", 10),
    Parameter("POI", 10),
    Parameter("Chits", 5),
  ].obs;

  final RxMap<String, List<double>> scores = <String, List<double>>{}.obs;

  final RxInt mode = 0.obs;
  final RxInt sort = 0.obs;
  final RxString query = "".obs;

  int get sortIndex => sort.value.abs() - 1;

  void toggleMode() => mode.value = mode.value == 0 ? 1 : 0;

  final RxList<dynamic> selected = ["", 0].obs;

  ScorecardController() {
    for (final String delegate
        in Get.find<CommitteeController>().committee.delegates) {
      scores[delegate] = parameters.map<double>((_) => 0).toList();
    }
  }

  void addParameter(String title, int maxScore) {
    if (sortIndex == parameters.length) {
      sort.value += sort.value > 0 ? 1 : -1;
    }

    parameters.add(Parameter(title, maxScore));

    scores.keys.forEach((delegate) => scores[delegate]!.add(0));
    _saveScores();
  }

  void deleteParameter(int index) {
    if (sortIndex == parameters.length) {
      sort.value += sort.value > 0 ? -1 : 1;
    }

    parameters.removeAt(index);

    scores.keys.forEach((delegate) => scores[delegate]!.removeAt(index));
    _saveScores();
  }

  void reorderParameter(int index) {
    if (index == sortIndex) {
      sort.value += sort.value > 0 ? 1 : -1;
    } else if (index == sortIndex - 1) {
      sort.value += sort.value > 0 ? -1 : 1;
    }

    parameters.insert(index + 1, parameters.removeAt(index));

    scores.keys.forEach(
      (delegate) => scores[delegate]!
          .insert(index + 1, scores[delegate]!.removeAt(index)),
    );
    _saveScores();
  }

  void updateParameter(int index, String title, int maxScore) {
    parameters[index].title = title;
    parameters[index].maxScore = maxScore;

    update();
  }

  void _saveScores() {
    LocalStorage.updateScore(
      "parameters",
      parameters.map<String>((e) => e.title).toList(),
    );

    LocalStorage.updateScore(
      "maxScores",
      parameters.map<int>((e) => e.maxScore).toList(),
    );

    LocalStorage.updateScore("scores", scores);
  }

  void updateScore(String delegate, int index, double score) {
    scores.update(
      delegate,
      (value) {
        value[index] = score;
        return value;
      },
    );
    _saveScores();
  }

  Map<String, dynamic> toJson() {
    return {
      "parameters": parameters.map<String>((e) => e.title).toList(),
      "maxScores": parameters.map<int>((e) => e.maxScore).toList(),
      "scores": scores,
    };
  }
}
