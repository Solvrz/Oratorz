import 'package:get/get.dart';

import '/config/data.dart';
import '/models/committee.dart';

class SetupController extends GetxController {
  SetupController({required Committee committee, required this.editing}) {
    _committee = committee.obs;
  }

  late final Rx<Committee> _committee;
  late bool editing = false;
  final RxInt _selectedType = 0.obs;
  final RxBool status = false.obs;

  Committee get committee => _committee.value;

  int get selectedType => _selectedType.value;
  set selectedType(int newCommitteeType) =>
      _selectedType.value = newCommitteeType;

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
