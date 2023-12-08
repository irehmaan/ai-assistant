import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextProvider extends ChangeNotifier {
  final SpeechToText speech = SpeechToText();
  bool _isListening = false;
  bool isAvailable = false;
  bool get isListening => _isListening;

  Future<void> initializeSpeech() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      isAvailable = await speech.initialize();
      if (isAvailable) {
        notifyListeners();
      } else {
        // Handle the case where speech recognition is not available on this device.
      }
    } else {
      // Handle the case where microphone permission is denied.
    }
  }

  Future<void> startListening() async {
    if (speech.isAvailable && await Permission.microphone.isGranted) {
      await speech.listen(
        onResult: (result) {
          // Handle recognized speech result.
          print(result.recognizedWords);
        },
      );
      _isListening = true;
      notifyListeners();
    }
  }

  void stopListening() {
    speech.stop();
    _isListening = false;
    notifyListeners();
  }
}
