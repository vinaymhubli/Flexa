import 'dart:io';
import 'package:flexa_app/model/tts.dart';
import 'package:flexa_app/views/home.dart';
import 'package:flexa_app/views/speachscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpoverrides();
  WidgetsFlutterBinding.ensureInitialized();
  Texttospeech.initTTS();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FLUTTER ALEXA',
      home: SpeachScreen(),
    );
  }
}
