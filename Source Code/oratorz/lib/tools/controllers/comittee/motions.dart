import 'package:get/get.dart';

class MotionsController extends GetxController {
  final RxList<Map<String, dynamic>> _motions = <Map<String, dynamic>>[].obs;
  final RxInt _mode = 0.obs;

  List<Map<String, dynamic>> get motions => _motions;
  set motions(List<Map<String, dynamic>> newVoters) =>
      _motions.value = newVoters;

  Map<String, dynamic> get currentMotion =>
      _motions.isNotEmpty ? _motions[0] : {};

  int get mode => _mode.value;
  set mode(int newMode) => _mode.value = newMode;

  void add(Map<String, dynamic> motion) => _motions.add(motion);
  void remove(Map<String, dynamic> motion) => _motions.remove(motion);
}
