import 'package:get/get.dart';

import '/services/local_storage.dart';

class SpeechController extends GetxController {
  final String tag;

  SpeechController(this.tag);

  final RxMap<String, String> _subtopic = {"": ""}.obs;

  final Rx<Stopwatch> _overallStopwatch = Stopwatch().obs;
  final Rx<Stopwatch> _stopwatch = Stopwatch().obs;

  final Rx<Duration> _duration = const Duration(minutes: 1).obs;
  final Rx<Duration> _overallDuration = Duration.zero.obs;

  final RxString _currentSpeaker = "".obs;
  final RxBool _isSpeaking = false.obs;

  final RxList<String> nextSpeakers = <String>[].obs;

  final RxList<Map<String, Duration>> pastSpeakers =
      <Map<String, Duration>>[].obs;

  List<Map<String, int>> get pastSpeakersEncode => pastSpeakers
      .map<Map<String, int>>(
        (element) =>
            <String, int>{element.keys.first: element.values.first.inSeconds},
      )
      .toList();

  Map<String, String> get subtopic => _subtopic;
  set subtopic(Map<String, String> newSubtopic) =>
      _subtopic.value = newSubtopic;

  bool get hasSubtopic => subtopic.keys.first.isNotEmpty;
  bool get hasOverallDuration => overallDuration.inSeconds > 0;

  Stopwatch get overallStopwatch => _overallStopwatch.value;
  Stopwatch get stopwatch => _stopwatch.value;

  Duration get overallDuration => _overallDuration.value;
  Duration get duration => _duration.value;

  set overallDuration(Duration newDuration) {
    _overallDuration.value = newDuration;
    LocalStorage.updateSpeech("overall", newDuration.inSeconds, tag);
  }

  set duration(Duration newDuration) {
    _duration.value = newDuration;
    LocalStorage.updateSpeech("duration", newDuration.inSeconds, tag);
  }

  String get currentSpeaker => _currentSpeaker.value;
  set currentSpeaker(String newSpeaker) => _currentSpeaker.value = newSpeaker;

  bool get isSpeaking => _isSpeaking.value;
  set isSpeaking(bool newSpeaker) => _isSpeaking.value = newSpeaker;

  bool isAdded(String delegate) =>
      _currentSpeaker.value == delegate || nextSpeakers.contains(delegate);

  void reorder(int oldIndex, int newIndex) {
    final String old = nextSpeakers[oldIndex];

    nextSpeakers.removeAt(oldIndex);
    nextSpeakers.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, old);
    LocalStorage.updateSpeech("next", nextSpeakers, tag);
  }

  void addSpeaker(String delegate) {
    if (currentSpeaker.isEmpty) {
      currentSpeaker = delegate;
      LocalStorage.updateSpeech("current", currentSpeaker, tag);
      return;
    }

    nextSpeakers.add(delegate);
    LocalStorage.updateSpeech("next", nextSpeakers, tag);
  }

  void removeSpeaker(String delegate) {
    nextSpeakers.remove(delegate);
    LocalStorage.updateSpeech("next", nextSpeakers, tag);
  }

  void nextSpeaker() {
    if (_currentSpeaker.value.isEmpty) return;

    pastSpeakers.add({_currentSpeaker.value: stopwatch.elapsed});
    LocalStorage.updateSpeech("past", pastSpeakersEncode, tag);

    if (nextSpeakers.isEmpty) {
      _currentSpeaker.value = "";
    } else {
      _currentSpeaker.value = nextSpeakers.first;
      nextSpeakers.removeAt(0);
      LocalStorage.updateSpeech("next", nextSpeakers, tag);
    }

    LocalStorage.updateSpeech("current", currentSpeaker, tag);

    _isSpeaking.value = false;

    _stopwatch.value.stop();
    _overallStopwatch.value.stop();

    _stopwatch.value.reset();
  }

  Map<String, dynamic> toJson() {
    return {
      "subtopic": _subtopic,
      "overall": _overallDuration.value.inSeconds,
      "duration": _duration.value.inSeconds,
      "current": _currentSpeaker.value,
      "past": pastSpeakersEncode,
      "next": nextSpeakers,
    };
  }
}
