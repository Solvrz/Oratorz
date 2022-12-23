import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/models/committee.dart';

class SetupController extends GetxController {
  final Rx<Committee> committee = Rx<Committee>(Committee());
  RxInt openType = 0.obs;

  Committee get _value => committee.value;

  void setName(String newName) =>
      committee.update((value) => value?.name = newName);

  void setAs(List<String> delegates) => committee.update((value) {
        value!.delegates = delegates;
        sort();
      });

  void add(String delegate) => committee.update((value) {
        value!.delegates.add(delegate);
        sort();
      });

  void remove(String delegate) => committee.update((value) {
        value!.delegates.remove(delegate);
        sort();
      });

  void removeAt(int index) => committee.update((value) {
        value!.delegates.removeAt(index);
        sort();
      });

  void clear() => committee.update((value) {
        value!.delegates.clear();
        value.name = "Your Committee";
      });

  void sort() =>
      _value.delegates.sort((a, b) => DELEGATES[a]!.compareTo(DELEGATES[b]!));
}
