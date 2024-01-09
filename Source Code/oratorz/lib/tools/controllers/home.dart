import 'package:get/get.dart';

import '/services/local_storage.dart';

class HomeController extends GetxController {
  final RxList<String> committees = <String>[].obs;
  final RxList<String> pinned = <String>[].obs;

  HomeController() {
    committees.value = LocalStorage.committees;
    pinned.value = LocalStorage.pinned;
  }

  void addCommittee(String id) => committees.add(id);
  void deleteCommittee(String id) => committees.remove(id);
  void addPin(String id) => pinned.add(id);
  void removePin(String id) => pinned.remove(id);
}
