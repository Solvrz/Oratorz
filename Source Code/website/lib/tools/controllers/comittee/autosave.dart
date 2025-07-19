import 'dart:async';

import 'package:get/get.dart';

class AutoSaveController extends GetxController {
  final Map<String, Timer> timers = {};
  final Duration delay = const Duration(seconds: 20);

  void debounceSave(String id, void Function() callback) {
    timers[id]?.cancel();
    timers[id] = Timer(delay, () {
      callback();
      timers.remove(id);
    });
  }

  @override
  void onClose() {
    timers.values.forEach((t) => t.cancel());
    super.onClose();
  }
}
