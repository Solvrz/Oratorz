// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:math';

abstract class Uid {
  static bool exists(String id) {
    return false;
  }

  static String generate() {
    String id = _generate();

    while (exists(id)) {
      id = _generate();
    }

    return id;
  }

  static String _generate() =>
      (Random().nextInt(pow(10, 8) as int) + pow(10, 8)).toString();
}
