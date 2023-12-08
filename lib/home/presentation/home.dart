import 'package:aiassistant/home/widgets/featurebox.dart';

import 'package:aiassistant/home/widgets/song_widget.dart';
import 'package:aiassistant/services/services/openaiservice/openaiservice.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Home extends StatefulWidget {
  final String? username;
  const Home({Key? key, this.username}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SpeechToText speechToText = SpeechToText();
  final OpenAIService openAIService = OpenAIService();
  final FlutterTts flutterTts = FlutterTts();
  int start = 200;
  int delay = 350;
  String? genContent;
  String? genUrl;
  bool ttsON = false;
  String lastWords = '';
  String resultSpeech = '';
  String trackName = '';
  bool playMusic = false;

  @override
  void initState() {
    super.initState();
    initSpeech();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    // await flutterTts.setSharedInstance(true);
    flutterTts.setSpeechRate(0.6);
    setState(() {});
    await flutterTts
        .speak("Welcome, ${widget.username ?? ''}! What can I do for you ?");
  }

  Future<void> initSpeech() async {
    await speechToText.initialize();

    setState(() {});
    // startListening();
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      lastWords = result.recognizedWords;
      print(lastWords);
    });

    if (!speechToText.isListening) {
      try {
        // print(lastWords.toLowerCase());

        if (lastWords.toLowerCase().contains("play") ||
            lastWords.toLowerCase().contains("Play") ||
            lastWords.toLowerCase().contains("Play music") ||
            lastWords.toLowerCase() == 'play music') {
          RegExp regex = RegExp(r'play ', caseSensitive: false);
          trackName = lastWords.replaceAll(regex, '');
          await speechOutput("Searching $trackName");
          playMusic = true;
          setState(() {});
        } else {
          final result = await openAIService.isArtPrompted(lastWords);
          if (result.contains("https") || result.contains("http")) {
            setState(() {
              genUrl = result;
              genContent = null;
              ttsON = false;
            });
          } else {
            await speechOutput(result);
            setState(() {
              resultSpeech = result;
              ttsON = true;
              genUrl = null;
              genContent = result;
            });
          }
        }

        // print(result);
      } catch (error) {
        print('Error executing openAIService: $error');
      }
    }
  }

  Future<void> speechOutput(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade100.withOpacity(0.1),
        actions: [
          IconButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              icon: const Icon(Icons.exit_to_app_outlined))
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: [
                  ElasticIn(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        "assets/images/friday.png",
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                margin:
                    const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 4),
                child: Text(lastWords),
              ),
              SlideInRight(
                child: Visibility(
                  visible: genUrl == null && playMusic == false,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 30)
                        .copyWith(top: 30),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(20)
                            .copyWith(topLeft: Radius.zero)),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                          genContent == null
                              ? "Welcome, ${widget.username ?? ''}! What can I do for you ?"
                              : genContent!,
                          style: GoogleFonts.mooli(
                            textStyle: TextStyle(
                                color: Colors.teal.shade600,
                                fontSize: genContent == null ? 20 : 16,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ),
              ),
              if (genUrl != null)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(genUrl!)),
                  ),
                ),
              Visibility(
                  visible: playMusic == true,
                  child: Stack(
                    children: [
                      Positioned(
                          left: size.width / 2.3,
                          child: IconButton(
                              onPressed: () {
                                playMusic = false;
                                setState(() {});
                              },
                              icon: const Icon(Icons.cancel))),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 10),
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            child: SongWidget(
                              prompt: trackName,
                              // genContent: genContent,
                            )),
                      ),
                    ],
                  )),
              // Visibility(child: Music_Player(song: song)),
              Visibility(
                visible: genContent == null && genUrl == null,
                child: SlideInLeft(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 24, top: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Here are a few examples",
                      style: GoogleFonts.mooli(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: genContent == null && genUrl == null,
                child: Column(
                  children: [
                    SlideInLeft(
                      delay: Duration(milliseconds: start),
                      child: FeatureBox(
                          color: Colors.cyan.withOpacity(0.28),
                          headerText: "Chatgpt",
                          desc:
                              "A smarter way to ask questions using Chat gpt !"),
                    ),
                    SlideInLeft(
                      delay: Duration(milliseconds: start + delay),
                      child: FeatureBox(
                          color: Colors.blue.withOpacity(0.2),
                          headerText: "Dall-E",
                          desc:
                              "Give your creativity life with Dall-E AI image generator !"),
                    ),
                    SlideInLeft(
                      delay: Duration(milliseconds: start + 50 + delay),
                      child: FeatureBox(
                          color: Colors.lightGreen.withOpacity(0.2),
                          headerText: "Or just ask to play music !",
                          desc:
                              "Just ask Friday to play a song by artist or by name."),
                    ),
                    SlideInLeft(
                      delay: Duration(milliseconds: start + 100 + delay),
                      child: FeatureBox(
                          color: Colors.brown.withOpacity(0.2),
                          headerText: "Smart Voice Assitant",
                          desc:
                              "Just use your voice to interact hassle free with Chatgpt or Dall-E or listen to music."),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SlideInUp(
        delay: Duration(milliseconds: start + 3 * delay),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                heroTag: const Text("fab1"),
                onPressed: () async {
                  if (await speechToText.hasPermission &&
                      speechToText.isNotListening) {
                    startListening();
                  } else if (speechToText.isListening) {
                    stopListening();
                  } else {
                    initSpeech();
                  }
                },
                child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                heroTag: const Text("fab2"),
                onPressed: () async {
                  if (ttsON == false) {
                    await speechOutput(resultSpeech);

                    setState(() {
                      ttsON = true;
                      playMusic = false;
                    });
                  } else {
                    flutterTts.pause();
                    setState(() {
                      ttsON = false;
                      playMusic = false;
                    });
                  }
                },
                child: Icon(ttsON ? Icons.pause : Icons.play_arrow),
              ),
            )
          ],
        ),
      ),
    );
  }
}
