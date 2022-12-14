import 'package:get/get.dart';

import '../../../config/constants/committee.dart';

class ModeController extends GetxController {
  late RxInt mode;

  ModeController({int modeVal = 0}) {
    mode = RxInt(modeVal);
  }

  int get modeVal => mode.value;
  set modeVal(int newMode) => mode.value = newMode;

  Map<String, dynamic> currentTab() => COMMITTEE_MODES[mode.value];
}
