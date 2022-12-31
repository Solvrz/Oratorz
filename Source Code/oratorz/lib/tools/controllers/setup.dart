import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/models/committee.dart';

class SetupController extends GetxController {
  final Rx<Committee> _committee = Committee().obs;
  final RxInt _committeeType = 0.obs;

  Committee get committee => _committee.value;

  int get committeeType => _committeeType.value;
  set committeeType(int newCommitteeType) =>
      _committeeType.value = newCommitteeType;

  void setAs(String name, List<String> delegates) =>
      _committee.update((committee) {
        committee?.name = name;
        committee?.delegates = delegates;

        sort();
      });

  void add(String delegate) => _committee.update((committee) {
        committee?.delegates.add(delegate);
        sort();
      });

  void remove(String delegate) => _committee.update((committee) {
        committee?.delegates.remove(delegate);
        sort();
      });

  void removeAt(int index) => _committee.update((committee) {
        committee?.delegates.removeAt(index);
        sort();
      });

  void clear() => _committee.update((committee) {
        committee?.delegates.clear();
        committee?.name = "Your Committee";
      });

  void sort() => _committee.value.delegates
      .sort((a, b) => DELEGATES[a]!.compareTo(DELEGATES[b]!));
}
