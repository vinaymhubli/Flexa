import 'package:avatar_glow/avatar_glow.dart';
import 'package:flexa_app/model/chatgpt_model.dart';
import 'package:flexa_app/model/tts.dart';
import 'package:flexa_app/services/api_service.dart';
import 'package:flexa_app/utlis/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:math' as math;

class SpeachScreen extends StatefulWidget {
  const SpeachScreen({super.key});

  @override
  State<SpeachScreen> createState() => _SpeachScreenState();
}

class _SpeachScreenState extends State<SpeachScreen> {
  var text = "Hold the button and start speaking";
  var isListing = false;
  final List<ChatMessage> messages = [];
  var scrollController = ScrollController();
  scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 180), curve: Curves.easeOut);
  }

  SpeechToText speechToText = SpeechToText();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: bgColor,
        title: Text(
          "Flexa",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: textColor, fontSize: 35),
        ),
      ),
      body: Container(
        // color: Color.fromARGB(255, 45, 45, 45),
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
        // margin: EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isListing ? Colors.black : Colors.black87),
            ),
            SizedBox(height: 15.0),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 13),
              decoration: BoxDecoration(
                  color: chatbgColor,
                  borderRadius: BorderRadius.circular(25.0)),
              child: ListView.builder(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    var chat = messages[index];
                    return chatbubble(chattext: chat.text, type: chat.type);
                  }),
            )),
            SizedBox(height: 7.0)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListing,
        duration: Duration(milliseconds: 2000),
        glowColor: textColor,
        repeat: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListing) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListing = true;
                  speechToText.listen(onResult: (result) {
                    setState(() {
                      text = result.recognizedWords;
                    });
                  });
                });
              }
            }
          },
          onTapUp: (details) async {
            setState(() {
              isListing = false;
            });
            await speechToText.stop();
            if (text.isNotEmpty &&
                text != "Hold the button and start speaking") {
              messages.add(ChatMessage(text: text, type: ChatmessageType.user));
              var msg = await Apiservices.sendMessage(text);
              msg = msg.trim();
              setState(() {
                messages.add(ChatMessage(text: msg, type: ChatmessageType.bot));
              });
              Future.delayed(Duration(milliseconds: 500), () {
                Texttospeech.speak(msg);
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("your voice is not audible")));
            }
          },
          child: Container(
            height: 85,
            width: 75,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: SweepGradient(
                  startAngle: math.pi * 0.2,
                  endAngle: math.pi * 1.7,
                  colors: [
                    Color.fromARGB(255, 148, 49, 42),
                    Color.fromARGB(255, 24, 190, 48),
                    Color.fromARGB(255, 187, 19, 128),
                    Color.fromARGB(255, 148, 49, 42),
                    Color.fromARGB(255, 240, 26, 33),
                  ],
                  stops: <double>[0.0, 0.25, 0.5, 0.75, 1.0],
                  tileMode: TileMode.clamp,
                )),
            child: Icon(
              isListing ? Icons.mic_sharp : Icons.mic_none_sharp,
              color:
                  isListing ? Color.fromARGB(255, 8, 172, 131) : Colors.white,
              size: 45,
            ),
          ),
        ),
      ),
    );
  }

  Widget chatbubble({required chattext, required ChatmessageType? type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          child: type == ChatmessageType.bot
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset('assets/icons/ChatGPT.png')))
              : Icon(Icons.person_outline_sharp, size: 30),
        ),
        SizedBox(width: 7.0),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
                color: type == ChatmessageType.bot ? bgColor : Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18))),
            child: Text(
              '$chattext',
              style: TextStyle(
                  color: type == ChatmessageType.bot ? textColor : chatbgColor,
                  fontWeight: type == ChatmessageType.bot
                      ? FontWeight.w600
                      : FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
