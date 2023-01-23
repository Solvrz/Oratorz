import 'package:get/get.dart';

import '/services/local_storage.dart';
import './committee.dart';

class ScorecardController extends GetxController {
  final RxList<String> parameters = <String>["GSL", "Mod", "POI", "Chits"].obs;
  final RxList<int> maxScores = <int>[10, 10, 10, 5].obs;

  final RxMap<String, List<double>> scores = <String, List<double>>{}.obs;

  final RxInt mode = 0.obs;
  void toggleMode() => mode.value = mode.value == 0 ? 1 : 0;

  ScorecardController() {
    for (final String delegate
        in Get.find<CommitteeController>().committee.delegates) {
      scores[delegate] = parameters.map<double>((_) => 0).toList();
    }
  }

  void addParameter(String parameter, int maxScore) {
    parameters.add(parameter);
    maxScores.add(maxScore);

    scores.keys.forEach((delegate) => scores[delegate]!.add(0));
    _saveScores();
  }

  void deleteParameter(int index) {
    parameters.removeAt(index);
    maxScores.removeAt(index);

    scores.keys.forEach((delegate) => scores[delegate]!.removeAt(index));
    _saveScores();
  }

  void reorderParameter(int index) {
    parameters.insert(index + 1, parameters.removeAt(index));
    maxScores.insert(index + 1, maxScores.removeAt(index));

    scores.keys.forEach(
      (delegate) => scores[delegate]!
          .insert(index + 1, scores[delegate]!.removeAt(index)),
    );
    _saveScores();
  }

  void _saveScores() {
    LocalStorage.updateScore("parameters", parameters);
    LocalStorage.updateScore("maxScores", maxScores);
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
      "parameters": parameters,
      "maxScores": maxScores,
      "scores": scores,
    };
  }
}
