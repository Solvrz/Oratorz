import 'package:get/get.dart';

class SpeechController extends GetxController {
  final RxMap<String, String> _subtopic = {"": ""}.obs;

  final Rx<Stopwatch> _overallStopwatch = Stopwatch().obs;
  final Rx<Stopwatch> _stopwatch = Stopwatch().obs;

  final Rx<Duration> _duration = const Duration(minutes: 1).obs;
  final Rx<Duration> _overallDuration = Duration.zero.obs;

  final RxString _currentSpeaker = "".obs;
  final RxBool _isSpeaking = false.obs;

  final RxList<String> _nextSpeakers = <String>[].obs;
  final RxList<Map<String, Duration>> _pastSpeakers =
      <Map<String, Duration>>[].obs;

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

  List<String> get nextSpeakers => _nextSpeakers;
  List<Map<String, Duration>> get pastSpeakers => _pastSpeakers;

  bool isAdded(String delegate) =>
      _currentSpeaker.value == delegate || _nextSpeakers.contains(delegate);

  void reorder(int oldIndex, int newIndex) {
    final String _old = _nextSpeakers[oldIndex];

    _nextSpeakers.removeAt(oldIndex);
    _nextSpeakers.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, _old);
  }

  void addSpeaker(String delegate) {
    if (_currentSpeaker.value.isEmpty) {
      _currentSpeaker.value = delegate;
      return;
    }

    _nextSpeakers.add(delegate);
  }

  void removeSpeaker(String delegate) => _nextSpeakers.remove(delegate);

  void nextSpeaker() {
    if (_currentSpeaker.value.isEmpty) return;

    _pastSpeakers.add({_currentSpeaker.value: _stopwatch.value.elapsed});

    if (_nextSpeakers.isEmpty) {
      _currentSpeaker.value = "";
    } else {
      _currentSpeaker.value = _nextSpeakers.first;
      _nextSpeakers.removeAt(0);
    }

    _isSpeaking.value = false;

    _stopwatch.value.stop();
    _overallStopwatch.value.stop();

    _stopwatch.value.reset();
  }
}
