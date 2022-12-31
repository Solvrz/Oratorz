import 'package:get/get.dart';

class MotionsController extends GetxController {
  final RxMap<String, dynamic> _currentMotion = <String, dynamic>{}.obs;

  final RxList<Map<Map<String, dynamic>, bool>> _pastMotions =
      <Map<Map<String, dynamic>, bool>>[].obs;
  final RxList<Map<String, dynamic>> _nextMotions =
      <Map<String, dynamic>>[].obs;

  final RxInt _mode = 0.obs;

  Map<String, dynamic> get currentMotion => _currentMotion;

  List<Map<String, dynamic>> get nextMotions => _nextMotions;
  List<Map<Map<String, dynamic>, bool>> get pastMotions => _pastMotions;

  int get mode => _mode.value;
  set mode(int newMode) => _mode.value = newMode;

  void reorder(int oldIndex, int newIndex) {
    final Map<String, dynamic> _old = _nextMotions[oldIndex];

    _nextMotions.removeAt(oldIndex);
    _nextMotions.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, _old);
  }

  void addMotion(Map<String, dynamic> motion) {
    if (_currentMotion.isEmpty) {
      _currentMotion.value = motion;
      return;
    }

    _nextMotions.add(motion);
  }

  void removeMotion(Map<String, dynamic> motion) => _nextMotions.remove(motion);

  void nextMotion({required bool passed, bool add = true}) {
    if (_currentMotion.isEmpty) return;

    if (add) _pastMotions.add({_currentMotion: passed});

    if (_nextMotions.isEmpty) {
      _currentMotion.value = {};
    } else {
      _currentMotion.value = _nextMotions.first;
      _nextMotions.removeAt(0);
    }
  }
}
