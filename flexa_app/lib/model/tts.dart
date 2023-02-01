import 'package:flutter_tts/flutter_tts.dart';

class Texttospeech {
  static FlutterTts tts = FlutterTts();
  static initTTS() {
    tts.setLanguage('hi-IN');
  }

  static speak(String text) async {
    await tts.awaitSpeakCompletion(true);
    tts.speak(text);
  }
}
