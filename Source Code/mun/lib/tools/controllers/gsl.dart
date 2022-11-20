import 'package:get/get.dart';

class GSLController extends GetxController {
  RxString currentSpeaker = "".obs;
  RxList<String> nextSpeakers = <String>[].obs;
  RxList<Map<String, Duration>> pastSpeakers = <Map<String, Duration>>[].obs;
  Rx<Stopwatch> stopwatch = Stopwatch().obs;

  bool isAdded(String country) =>
      currentSpeaker.value == country || nextSpeakers.contains(country);

  void reorder(int oldIndex, int newIndex) {
    final String temp = nextSpeakers[oldIndex];

    nextSpeakers.removeAt(oldIndex);
    nextSpeakers.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, temp);
  }

  void addSpeaker(String country) {
    if (currentSpeaker.value == "") {
      currentSpeaker.value = country;
      return;
    }

    nextSpeakers.add(country);
  }

  void removeSpeaker(String country) => nextSpeakers.remove(country);

  void nextSpeaker() {
    if (currentSpeaker.value == "") return;

    pastSpeakers.add({currentSpeaker.value: stopwatch.value.elapsed});

    if (nextSpeakers.isEmpty) {
      currentSpeaker.value = "";
    } else {
      currentSpeaker.value = nextSpeakers.first;
      nextSpeakers.removeAt(0);
    }

    stopwatch.value.reset();
  }
}
