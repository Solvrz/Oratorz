import 'package:get/get.dart';

import '/services/local_storage.dart';

class MotionsController extends GetxController {
  final RxMap<String, dynamic> _currentMotion = <String, dynamic>{}.obs;

  final RxList<Map<String, dynamic>> _nextMotions =
      <Map<String, dynamic>>[].obs;

  final RxInt _mode = 0.obs;

  Map<String, dynamic> get currentMotion => _currentMotion;
  set currentMotion(Map<String, dynamic> motion) =>
      _currentMotion.value = motion;

  List<Map<String, dynamic>> get nextMotions => _nextMotions;
  set nextMotions(List<Map<String, dynamic>> motions) =>
      _nextMotions.value = motions;

  int get mode => _mode.value;
  set mode(int newMode) => _mode.value = newMode;

  void _saveMotions() {
    LocalStorage.updateMotions("current", _currentMotion);
    LocalStorage.updateMotions("next", _nextMotions);
  }

  bool isCurrentMotion(Map<String, dynamic> motion) {
    return _currentMotion["type"] == motion["type"] &&
        _currentMotion["delegate"] == _currentMotion["delegate"];
  }

  void reorder(int oldIndex, int newIndex) {
    final Map<String, dynamic> _old = _nextMotions[oldIndex];

    _nextMotions.removeAt(oldIndex);
    _nextMotions.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, _old);

    _saveMotions();
  }

  void addMotion(Map<String, dynamic> motion) {
    if (_currentMotion.isEmpty) {
      _currentMotion.value = motion;
      _saveMotions();

      return;
    }

    _nextMotions.add(motion);
    _saveMotions();
  }

  void removeMotion(Map<String, dynamic> motion) {
    _nextMotions.remove(motion);
    _saveMotions();
  }

  void nextMotion({required bool passed}) {
    if (_currentMotion.isEmpty) return;

    if (_nextMotions.isEmpty) {
      _currentMotion.value = {};
    } else {
      _currentMotion.value = _nextMotions.first;
      _nextMotions.removeAt(0);
    }

    _saveMotions();
  }

  Map<String, dynamic> toJson() {
    return {
      "mode": _mode.value,
      "current": _currentMotion,
      "next": _nextMotions,
    };
  }
}
