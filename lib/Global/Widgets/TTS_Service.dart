import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  late FlutterTts flutterTts;

  TtsService._internal() {
    flutterTts = FlutterTts();
    initTts();
  }

  Future<void> initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1.0);
  }

  // Future<void> speak(String text) async {
  //   if (text.isNotEmpty) {
  //     await flutterTts.speak(text);
  //   }
  // }

  Future<void> speak(String text, {double? speechRate, double? pitch}) async {
    if (text.isNotEmpty) {
      if (speechRate != null) {
        await flutterTts.setSpeechRate(speechRate);
      }
      if (pitch != null) {
        await flutterTts.setPitch(pitch);
      }
      await flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }
}
