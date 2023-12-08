import 'package:aiassistant/home/widgets/goto.dart';
import 'package:aiassistant/services/musciplayer/audioPlayerService/audioPlayer.dart';
import 'package:aiassistant/services/texttospeech/text_to_speech.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => Player(),
    ),
    ChangeNotifierProvider(
      create: (context) => SpeechToTextProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const GoToHome(),
    );
  }
}
