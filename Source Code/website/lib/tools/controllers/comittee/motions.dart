import 'package:get/get.dart';

import 'autosave.dart';
import 'committee.dart';

class MotionsController extends GetxController {
  final RxMap<String, dynamic> _currentMotion = <String, dynamic>{}.obs;

  final RxList<Map<String, dynamic>> _pastMotions =
      <Map<String, dynamic>>[].obs;

  final RxInt _mode = 0.obs;

  Map<String, dynamic> get currentMotion => _currentMotion;
  set currentMotion(Map<String, dynamic> motion) =>
      _currentMotion.value = motion;

  List<Map<String, dynamic>> get nextMotions => _pastMotions;
  set nextMotions(List<Map<String, dynamic>> motions) =>
      _pastMotions.value = motions;

  int get mode => _mode.value;
  set mode(int newMode) => _mode.value = newMode;

  @override
  void onInit() {
    super.onInit();

    everAll([
      _currentMotion,
    ], (value) {
      //TODO: Implement save motions to cloud storage
      Get.find<AutoSaveController>()
          .debounceSave("motions", () => print(toJson()));
    });

    Get.find<CommitteeController>().trackController(this);
  }

  bool isCurrentMotion(Map<String, dynamic> motion) {
    return _currentMotion["type"] == motion["type"] &&
        _currentMotion["delegate"] == _currentMotion["delegate"];
  }

  void reorder(int oldIndex, int newIndex) {
    final Map<String, dynamic> _old = _pastMotions[oldIndex];

    _pastMotions.removeAt(oldIndex);
    _pastMotions.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, _old);
  }

  void addMotion(Map<String, dynamic> motion) {
    if (_currentMotion.isEmpty) {
      _currentMotion.value = motion;

      return;
    }

    _pastMotions.add(motion);
  }

  void removeMotion(Map<String, dynamic> motion) {
    _pastMotions.remove(motion);
  }

  void nextMotion({required bool passed}) {
    if (_currentMotion.isEmpty) return;

    if (_pastMotions.isEmpty) {
      _currentMotion.value = {};
    } else {
      _currentMotion.value = _pastMotions.first;
      _pastMotions.removeAt(0);
    }
  }

  Map<String, dynamic> toJson() => {
        "mode": _mode.value,
        "current": _currentMotion,
        "next": _pastMotions,
      };
}
