import 'package:get/get.dart';

class SpeechController extends GetxController {
  final Duration? overallDuration;

  RxString currentSpeaker = "".obs;
  RxMap<String, String> subtopic = {"": ""}.obs;

  SpeechController({this.overallDuration});

  bool get hasSubtopic => subtopic.keys.first != "";
  RxBool isSpeaking = false.obs;

  RxList<String> nextSpeakers = <String>[].obs;
  RxList<Map<String, Duration>> pastSpeakers = <Map<String, Duration>>[].obs;

  Rx<Duration> duration = const Duration(minutes: 1).obs;
  Rx<Stopwatch> stopwatch = Stopwatch().obs;

  bool isAdded(String delegate) =>
      currentSpeaker.value == delegate || nextSpeakers.contains(delegate);

  void reorder(int oldIndex, int newIndex) {
    final String temp = nextSpeakers[oldIndex];

    nextSpeakers.removeAt(oldIndex);
    nextSpeakers.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, temp);
  }

  void addSpeaker(String delegate) {
    if (currentSpeaker.value == "") {
      currentSpeaker.value = delegate;
      return;
    }

    nextSpeakers.add(delegate);
  }

  void removeSpeaker(String delegate) => nextSpeakers.remove(delegate);

  void nextSpeaker() {
    if (currentSpeaker.value == "") return;

    pastSpeakers.add({currentSpeaker.value: stopwatch.value.elapsed});

    if (nextSpeakers.isEmpty) {
      currentSpeaker.value = "";
    } else {
      currentSpeaker.value = nextSpeakers.first;
      nextSpeakers.removeAt(0);
    }

    isSpeaking.value = false;

    stopwatch.value.stop();
    stopwatch.value.reset();
  }
}
