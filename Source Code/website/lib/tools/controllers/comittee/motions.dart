// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';

import '/services/cloud_storage.dart';

class MotionsController extends GetxController {
  final RxMap<String, dynamic> _currentMotion = <String, dynamic>{}.obs;

  final RxList<Map<String, dynamic>> _pastMotions =
      <Map<String, dynamic>>[].obs;

  final RxInt _mode = 0.obs;

  Map<String, dynamic> get currentMotion => _currentMotion;
  set currentMotion(Map<String, dynamic> motion) =>
      _currentMotion.value = motion;

  List<Map<String, dynamic>> get pastMotions => _pastMotions;
  set pastMotions(List<Map<String, dynamic>> motions) =>
      _pastMotions.value = motions;

  int get mode => _mode.value;
  set mode(int newMode) => _mode.value = newMode;

  bool isCurrentMotion(Map<String, dynamic> motion) {
    return _currentMotion["type"] == motion["type"] &&
        _currentMotion["delegate"] == _currentMotion["delegate"];
  }

  void removeMotion(Map<String, dynamic> motion) {
    _pastMotions.remove(motion);
  }

  void addMotion({required bool passed}) {
    if (_currentMotion.isEmpty) return;

    _currentMotion["status"] = passed;

    final Map<String, dynamic> temp = Map.from(_currentMotion.value);

    _pastMotions.add(temp);
    CloudStorage.addMotion(temp);

    currentMotion = {};
  }
}
