import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:fluttertoast/fluttertoast.dart';


class Text_to_Speech extends StatefulWidget {
  String msg;
  Text_to_Speech(this.msg,{super.key});

  @override
  State<Text_to_Speech> createState() => _Text_to_SpeechState();
}
enum TtsState { playing, stopped, paused, continued }
class _Text_to_SpeechState extends State<Text_to_Speech> {

  late FlutterTts flutterTts;
  String language='en-US';
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.4;

  TtsState ttsState = TtsState.stopped;

  bool get isPlaying => ttsState == TtsState.playing;
  bool get isStopped => ttsState == TtsState.stopped;
  bool get isPaused => ttsState == TtsState.paused;
  bool get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

 // final AudioPlayer player = AudioPlayer();
  List<dynamic> availableLanguages = [];

  @override
  initState() {
  super.initState();

  initTts();
  _checkAndSetTtsLanguage();
  }

  Future<void> _checkAndSetTtsLanguage() async {
    // Get the list of supported languages on the device
    availableLanguages = await flutterTts.getLanguages;

    // Check if the desired language (en-IN) is available
    if (availableLanguages.contains(language)) {
      // Set the preferred language if available
      await flutterTts.setLanguage(language);
    } else {
      /// Fallback to a default language if the preferred language is not available
      // Fluttertoast.showToast(
      //   msg: "$language is not available. Falling back to en-US.",
      //   backgroundColor: Colors.grey,
      // );
      await flutterTts.setLanguage("en-US");
    }
  }

  // Future<void> _speak(String text) async {
  //   await flutterTts.speak(text);
  // }

//  speaks() async {
//    final voicesResponse = await TtsGoogle.getVoices();
//
//    final voices = voicesResponse.voices;
//
// //Print all voices
//    print(voices);
//    language=getLanguageCode!()??'en-';
// //Pick an English Voice
//    final voice = voices
//        .where((element) => element.locale.code.startsWith(language!))
//        .toList(growable: false)
//        .first;
//    TtsParamsGoogle ttsParams = TtsParamsGoogle(
//        voice: voice,
//        audioFormat: AudioOutputFormatGoogle.mp3,
//        text: widget.msg,
//        rate: 'slow', //optional
//        pitch: 'default' //optional
//    );
//
//    final ttsResponse = await TtsGoogle.convertTts(ttsParams);
//
// //Get the audio bytes.
//    final audioBytes = ttsResponse.audio.buffer.asUint8List();
//    await playAudio(audioBytes);
//
//  }

  // Future<void> playAudio(Uint8List audioBytes) async {
  //   final player = AudioPlayer();
  //
  //   // Get the temporary directory
  //   final tempDir = await getTemporaryDirectory();
  //
  //   // Create a temporary file
  //   final tempFile = File('${tempDir.path}/temp_audio.mp3');
  //
  //   // Write the byte data to the file
  //   await tempFile.writeAsBytes(audioBytes, flush: true);
  //
  //   // Play the audio from the file using AudioSource.file
  //   try {
  //     await player.play(DeviceFileSource(tempFile.path));
  //   } on Exception catch (e) {
  //     print('Error playing audio: $e');
  //   }
  // }

  dynamic initTts() {
  flutterTts = FlutterTts();

  _setAwaitOptions();

  // TtsGoogle.init(
  //     //params: InitParamsGoogle(apiKey: "API-KEY"),
  //     withLogs:true,
  //     apiKey: 'AIzaSyDY-oB0QysTXFJu2cOMlZvpwANBR2XS84E'
  // );

  if (isAndroid) {
  _getDefaultEngine();
  _getDefaultVoice();
  }

  flutterTts.setStartHandler(() {
  setState(() {
  print("Playing");
  ttsState = TtsState.playing;
  });
  });

  flutterTts.setCompletionHandler(() {
  setState(() {
  print("Complete");
  ttsState = TtsState.stopped;
  });
  });

  flutterTts.setCancelHandler(() {
  setState(() {
  print("Cancel");
  ttsState = TtsState.stopped;
  });
  });

  flutterTts.setPauseHandler(() {
  setState(() {
  print("Paused");
  ttsState = TtsState.paused;
  });
  });

  flutterTts.setContinueHandler(() {
  setState(() {
  print("Continued");
  ttsState = TtsState.continued;
  });
  });

  flutterTts.setErrorHandler((msg) {
  setState(() {
  print("error: $msg");
  ttsState = TtsState.stopped;
  });
  });
  }

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
        onTap: () {
      if (ttsState != TtsState.playing) {
        _speak();  // Speak the message on tap
      }
    },
    child:Container(
              height: 120,
              child: _btnSection(),)
    );
  }

  Future<void> _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future<void> _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future<void> _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (widget.msg != null) {
      if (widget.msg!.isNotEmpty) {
        await flutterTts.speak(widget.msg!);
      }
    }
  }

  Future<void> _speak_slow() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(0.1);
    await flutterTts.setPitch(1.0);

    if (widget.msg != null) {
      if (widget.msg!.isNotEmpty) {
        await flutterTts.speak(widget.msg!);
      }
    }
  }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    //player.dispose();
  }

  Widget _btnSection() {
    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(Colors.green, Colors.greenAccent, Icons.record_voice_over, 'Listen', _speak),
          _buildButtonColumn(Colors.orangeAccent, Colors.orange, Icons.audiotrack_outlined, 'Slow', _speak_slow),
        ],
      ),
    );
  }

  Card _buildButtonColumn(Color color, Color splashColor, IconData icon, String label, Function func) {
    return Card(
      elevation: 4,
        shadowColor: Colors.white,
        child:Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             IconButton(
                  icon: Icon(icon),
                  color: color,
                  splashColor: splashColor,
                  onPressed: () => func()),
            Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: Text(label,
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: color)))
          ]),
        ));
  }

}

