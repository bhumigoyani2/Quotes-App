import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();
Future<void> speakQuote(String language,String quote) async {
  await flutterTts.setLanguage(language);
  await flutterTts.speak(quote);
}