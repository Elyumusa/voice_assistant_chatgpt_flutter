import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_voice_assistant/api_service.dart';
import 'package:flutter_voice_assistant/feature_box.dart';
import 'package:flutter_voice_assistant/pallete.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  bool _speechEnabled = false;
  String lastWords = '';
  final api_service = APIservice();
  FlutterTts flutterTts = FlutterTts();
  TextEditingController textEditingController = TextEditingController();
  String? generatedContent;
  String? generatedImageUrl;
  Timer? timer;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToT();
    //startListening();
  }

  void initTTospeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  void initSpeechToT() async {
    _speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  startListening() async {
    if (_speechEnabled) {
      /*timer = Timer.periodic(Duration(seconds: 15), (timer) async {
        if (!speechToText.isListening && showsiri == true) {
          setState(() {
            showsiri = false;
          });
          await startListening();
        }
      });*/
      await speechToText.listen(
          onResult: _onSpeechResult,
          pauseFor: Duration(seconds: 15),
          listenFor: Duration(minutes: 2));
    } else {
      _speechEnabled = await speechToText.initialize();
      /*timer = Timer.periodic(Duration(seconds: 15), (timer) async {
        if (!speechToText.isListening && showsiri == true) {
          setState(() {
            showsiri = false;
          });
          await startListening();
        }
      });*/
      await speechToText.listen(
          onResult: _onSpeechResult,
          pauseFor: Duration(seconds: 15),
          listenFor: Duration(minutes: 2));
      print("Listener started");
    }
    setState(() {});
  }

  Future<void> _stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  bool showsiri = false;
  void _onSpeechResult(SpeechRecognitionResult result) async {
    print("okay no: ${result.recognizedWords}");
    if (result.recognizedWords.toLowerCase() == "amy") {
      showsiri = true;
      await _stopListening();
      await systemspeak("Hello what can I do for you");
      await startListening();
    }
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  Future<void> systemspeak(String content) async {
    await flutterTts.speak(content);
  }

  bool typing = false;
  bool enablespeech = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        padding: EdgeInsets.all(10),
        height: 80,
        child: Row(children: [
          SizedBox(
            height: 60,
            width: 300,
            child: TextField(
              controller: textEditingController,
              maxLines: 3,
              focusNode: focusNode,
              onChanged: (v) {
                if (v.isNotEmpty && typing == false) {
                  setState(() {
                    typing = true;
                  });
                } else if (typing == true && v.isEmpty) {
                  setState(() {
                    typing = false;
                  });
                }
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey))),
            ),
          ),
          SizedBox(width: 25),
          if (typing == false)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: () async {
                    await onMicPressed();
                  },
                  icon:
                      Icon(speechToText.isListening ? Icons.stop : Icons.mic)),
            ),
          if (typing == true)
            IconButton(
                onPressed: () async {
                  if (textEditingController.text.isNotEmpty) {
                    focusNode.unfocus();
                    await ifListening(prompt: textEditingController.text);
                  }
                },
                icon: Icon(Icons.send))
        ]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZoomIn(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage("assets/images/person.png"))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          Switch(
                              value: enablespeech,
                              onChanged: (v) {
                                setState(() {
                                  enablespeech = v;
                                });
                              }),
                          Text("AI speech")
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  margin: const EdgeInsets.only(top: 30, left: 40, right: 40),
                  decoration: BoxDecoration(
                      border: Border.all(color: Pallete.borderColor),
                      borderRadius: BorderRadius.circular(20)
                          .copyWith(topLeft: Radius.zero)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      generatedContent == null
                          ? "Good Morning, what task can I go for you?"
                          : generatedContent!,
                      style: TextStyle(
                          color: Pallete.mainFontColor,
                          fontSize: generatedContent == null ? 25 : 18,
                          fontFamily: "Cera Pro"),
                    ),
                  ),
                ),
              ),
            ),
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(generatedImageUrl!)),
              ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 10, left: 22),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Here are a few features",
                    style: TextStyle(
                        fontFamily: "Cera Pro",
                        color: Pallete.mainFontColor,
                        fontSize: 25),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  // If listening is active show the recognized words
                  speechToText.isListening
                      ? '$lastWords'
                      // If listening isn't active but could be tell the user
                      // how to start it, otherwise indicate that speech
                      // recognition is not yet ready or not supported on
                      // the target device
                      : _speechEnabled
                          ? 'Tap the microphone to start listening...'
                          : 'Speech not available',
                ),
              ),
            ),
            //features List
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: const [
                  FeatureBox(
                    color: Pallete.firstSuggestionBoxColor,
                    hText: "ChatGPT",
                    descriptionT:
                        "A smarter way to stay organized and informed with ChatGPT",
                  ),
                  /* FeatureBox(
                color: Pallete.secondSuggestionBoxColor,
                hText: "Dall-E",
                descriptionT:
                    "Get inspired and stay creative with your personal assistant"),
            FeatureBox(
                color: Pallete.thirdSuggestionBoxColor,
                hText: "Smart Voice Assistant",
                descriptionT:
                    "Get the best of both of ChatGpt using a voice assistant powered by Dall-E and ChatGPT")*/
                ],
              ),
            ),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Papa's VA"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await onMicPressed();
        },
        tooltip: 'Listen',
        child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
      ),*/
    );
  }

  bool changeToFuture = false;
  //Future ifListeningF=ifListening();
  Future<void> onMicPressed() async {
    if (await speechToText.hasPermission && speechToText.isNotListening) {
      await startListening();
    } else if (speechToText.isListening) {
      setState(() {
        changeToFuture = true;
      });
      await ifListening();
    } else {
      initSpeechToT();
    }
  }

  Future ifListening({String? prompt}) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: SizedBox(
              height: 80,
              width: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 18,
                ),
              )),
        );
      },
    );
    final returned = prompt != null
        ? await api_service
            .isArtPromptAPI(prompt)
            .whenComplete(() => Navigator.pop(context))
        : await api_service
            .isArtPromptAPI(lastWords)
            .whenComplete(() => Navigator.pop(context));
    setState(() {});
    if (returned.contains("https")) {
      generatedImageUrl = returned;
      generatedContent = null;
    } else {
      generatedImageUrl = null;
      generatedContent = returned;
      if (enablespeech) {
        await systemspeak(returned);
      }
      print("returned: $returned");
    }
    print("stop");
    await _stopListening();
    setState(() {});
    return "finished";
  }
}
