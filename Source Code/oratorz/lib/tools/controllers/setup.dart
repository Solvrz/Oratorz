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

  void fromTemplate(String template) => _committee.update((committee) {
        if (committee != null) {
          committee.name = template;
          committee.delegates = COMMITTEES[template]!.toList();

          sort();
        }
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

  void sort() => committee.delegates
      .sort((a, b) => DELEGATES[a]!.compareTo(DELEGATES[b]!));
}
