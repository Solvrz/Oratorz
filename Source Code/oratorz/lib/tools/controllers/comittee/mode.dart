import 'package:get/get.dart';

import '/config/constants/committee.dart';

class ModeController extends GetxController {
  late RxInt _mode;

  ModeController({int mode = 0}) {
    _mode = mode.obs;
  }

  int get mode => _mode.value;
  set mode(int newMode) => _mode.value = newMode;

  dynamic get currentMode => COMMITTEE_MODES[mode]["tab"];
  Map<String, dynamic> get currentModeDetails => COMMITTEE_MODES[mode];
}
