import 'package:get/get.dart';

class SpeechController extends GetxController {
  final RxMap<String, String> _subtopic = {"": ""}.obs;

  final Rx<Stopwatch> _overallStopwatch = Stopwatch().obs;
  final Rx<Stopwatch> _stopwatch = Stopwatch().obs;

  final Rx<Duration> _duration = const Duration(minutes: 1).obs;
  final Rx<Duration> _overallDuration = Duration.zero.obs;

  final RxString _currentSpeaker = "".obs;
  final RxBool _isSpeaking = false.obs;

  RxList<String> nextSpeakers = <String>[].obs;
  RxList<Map<String, Duration>> pastSpeakers = <Map<String, Duration>>[].obs;

  Map<String, String> get subtopic => _subtopic;
  set subtopic(Map<String, String> newSubtopic) =>
      _subtopic.value = newSubtopic;

  bool get hasSubtopic => subtopic.keys.first.isNotEmpty;
  bool get hasOverallDuration => overallDuration.inSeconds > 0;

  Stopwatch get overallStopwatch => _overallStopwatch.value;
  Stopwatch get stopwatch => _stopwatch.value;

  Duration get overallDuration => _overallDuration.value;
  Duration get duration => _duration.value;
  set overallDuration(Duration newDuration) =>
      _overallDuration.value = newDuration;
  set duration(Duration newDuration) => _duration.value = newDuration;

  String get currentSpeaker => _currentSpeaker.value;
  set currentSpeaker(String newSpeaker) => _currentSpeaker.value = newSpeaker;

  bool get isSpeaking => _isSpeaking.value;
  set isSpeaking(bool newSpeaker) => _isSpeaking.value = newSpeaker;

  bool isAdded(String delegate) =>
      currentSpeaker == delegate || nextSpeakers.contains(delegate);

  void reorder(int oldIndex, int newIndex) {
    final String temp = nextSpeakers[oldIndex];

    nextSpeakers.removeAt(oldIndex);
    nextSpeakers.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, temp);
  }

  void addSpeaker(String delegate) {
    if (currentSpeaker.isEmpty) {
      currentSpeaker = delegate;
      return;
    }

    nextSpeakers.add(delegate);
  }

  void removeSpeaker(String delegate) => nextSpeakers.remove(delegate);

  void nextSpeaker() {
    if (currentSpeaker.isEmpty) return;

    pastSpeakers.add({currentSpeaker: stopwatch.elapsed});

    if (nextSpeakers.isEmpty) {
      currentSpeaker = "";
    } else {
      currentSpeaker = nextSpeakers.first;
      nextSpeakers.removeAt(0);
    }

    isSpeaking = false;

    stopwatch.stop();
    overallStopwatch.stop();

    stopwatch.reset();
  }
}
