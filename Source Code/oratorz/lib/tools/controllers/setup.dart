import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/models/committee.dart';

class SetupController extends GetxController {
  final Rx<Committee> _committee = Rx<Committee>(Committee());
  final RxInt _committeeType = 0.obs;

  Committee get committee => _committee.value;

  int get committeeType => _committeeType.value;
  set committeeType(int newCommitteeType) => committeeType = newCommitteeType;

  void setName(String newName) =>
      _committee.update((value) => value?.name = newName);

  void setAs(List<String> delegates) => _committee.update((value) {
        value!.delegates = delegates;
        sort();
      });

  void add(String delegate) => _committee.update((value) {
        value!.delegates.add(delegate);
        sort();
      });

  void remove(String delegate) => _committee.update((value) {
        value!.delegates.remove(delegate);
        sort();
      });

  void removeAt(int index) => _committee.update((value) {
        value!.delegates.removeAt(index);
        sort();
      });

  void clear() => _committee.update((value) {
        value!.delegates.clear();
        value.name = "Your Committee";
      });

  void sort() => committee.delegates
      .sort((a, b) => DELEGATES[a]!.compareTo(DELEGATES[b]!));
}
