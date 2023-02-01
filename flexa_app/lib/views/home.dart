import 'package:flexa_app/model/tts.dart';
import 'package:flutter/material.dart';

class FlexaHome extends StatefulWidget {
  const FlexaHome({super.key});

  @override
  State<FlexaHome> createState() => _FlexaHomeState();
}

class _FlexaHomeState extends State<FlexaHome> {
  @override
  Widget build(BuildContext context) {
    var Textcontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Flexa"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: Textcontroller,
          ),
          ElevatedButton(
              onPressed: () {
                Texttospeech.speak(Textcontroller.text);
              },
              child: Text("Speak"))
        ],
      ),
    );
  }
}
