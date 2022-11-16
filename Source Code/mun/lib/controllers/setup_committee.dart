import 'package:get/get.dart';

import '../config/country_info.dart';
import '../models/committee.dart';

class SetupCommitteeController extends GetxController {
  final Rx<Committee> committee = Rx<Committee>(Committee());

  Committee get _value => committee.value;

  void setName(String newName) =>
      committee.update((value) => value!.name = newName);

  void setAs(List<String> countries) => committee.update((value) {
        value!.countries = countries;
        sort();
      });

  void add(String country) => committee.update((value) {
        value!.countries.add(country);
        sort();
      });

  void remove(String country) => committee.update((value) {
        value!.countries.remove(country);
        sort();
      });

  void removeAt(int index) => committee.update((value) {
        value!.countries.removeAt(index);
        sort();
      });

  void clear() => committee.update((value) {
        value!.countries.clear();
        value.name = "";
      });

  void sort() =>
      _value.countries.sort((a, b) => COUNTRIES[a]!.compareTo(COUNTRIES[b]!));
}
