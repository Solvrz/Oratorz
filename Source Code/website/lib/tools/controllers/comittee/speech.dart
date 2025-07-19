import 'package:get/get.dart';

import '/services/cloud_storage.dart';
import '/services/local_storage.dart';
import 'autosave.dart';

class SpeechController extends GetxController {
  final String tag;

  SpeechController(this.tag);

  final RxMap<String, String> _subtopic = <String, String>{}.obs;

  final Rx<Stopwatch> _overallStopwatch = Stopwatch().obs;
  final Rx<Stopwatch> _stopwatch = Stopwatch().obs;

  final Rx<Duration> _duration = const Duration(minutes: 1).obs;
  final Rx<Duration> _overallDuration = Duration.zero.obs;

  final RxString _currentSpeaker = "".obs;
  final RxBool _isSpeaking = false.obs;

  final RxList<String> nextSpeakers = <String>[].obs;

  final RxList<Map<String, Duration>> pastSpeakers =
      <Map<String, Duration>>[].obs;

  @override
  void onInit() {
    super.onInit();

    everAll([
      _subtopic,
      _overallDuration,
      _duration,
      _currentSpeaker,
      nextSpeakers,
      pastSpeakers,
    ], (_) {
      Get.find<AutoSaveController>()
          .debounceSave("caucus-$tag", () => CloudStorage.saveCaucus(tag));
    });
  }

  SpeechController.fromJson(this.tag, Map<String, dynamic> data) {
    subtopic = Map<String, String>.from(data["subtopic"]);
    overallDuration = Duration(seconds: data["overall"]);
    duration = Duration(seconds: data["duration"]);
    currentSpeaker = data["current"];

    final List<Map<String, int>> past = data["past"]
        .map<Map<String, int>>((element) => Map<String, int>.from(element))
        .toList();

    pastSpeakers.value = past
        .map<Map<String, Duration>>(
          (element) => <String, Duration>{
            element.keys.first: Duration(seconds: element.values.first),
          },
        )
        .toList();

    nextSpeakers.value = List<String>.from(data["next"]);
  }

  List<Map<String, int>> get pastSpeakersEncode => pastSpeakers
      .map<Map<String, int>>(
        (element) =>
            <String, int>{element.keys.first: element.values.first.inSeconds},
      )
      .toList();

  Map<String, String> get subtopic => _subtopic;
  set subtopic(Map<String, String> newSubtopic) =>
      _subtopic.value = newSubtopic;

  bool get hasSubtopic => subtopic.keys.isNotEmpty;
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

  void swapWithCurrentSpeaker(int index) {
    final String temp = _currentSpeaker.value;

    _currentSpeaker.value = nextSpeakers[index];
    nextSpeakers[index] = temp;
  }

  void addSpeaker(String delegate) {
    if (currentSpeaker.isEmpty) {
      currentSpeaker = delegate;
      LocalStorage.updateSpeech("current", currentSpeaker, tag);
      return;
    }

    if (currentSpeaker == delegate || nextSpeakers.contains(delegate)) {
      return;
    }

    nextSpeakers.add(delegate);
    LocalStorage.updateSpeech("next", nextSpeakers, tag);
  }

  void removeSpeaker(String delegate) {
    nextSpeakers.remove(delegate);
    LocalStorage.updateSpeech("next", nextSpeakers, tag);

    update();
  }

  void removeCurrentSpeaker() {
    if (nextSpeakers.isEmpty) {
      _currentSpeaker.value = "";
    } else {
      _currentSpeaker.value = nextSpeakers.first;
      nextSpeakers.removeAt(0);
      LocalStorage.updateSpeech("next", nextSpeakers, tag);
    }

    LocalStorage.updateSpeech("current", currentSpeaker, tag);

    update();
  }

  void removePastSpeaker(int index) {
    pastSpeakers.removeAt(index);
    LocalStorage.updateSpeech("past", pastSpeakers, tag);

    update();
  }

  void nextSpeaker() {
    if (_currentSpeaker.value.isEmpty) return;

    pastSpeakers.add({_currentSpeaker.value: stopwatch.elapsed});
    LocalStorage.updateSpeech("past", pastSpeakersEncode, tag);

    removeCurrentSpeaker();

    _isSpeaking.value = false;

    _stopwatch.value.stop();
    _overallStopwatch.value.stop();

    _stopwatch.value.reset();
  }

  Map<String, dynamic> toJson() => {
        "subtopic": _subtopic,
        "overall": _overallDuration.value.inSeconds,
        "duration": _duration.value.inSeconds,
        "current": _currentSpeaker.value,
        "past": pastSpeakersEncode,
        "next": nextSpeakers,
      };
}
