// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TranslatorApp extends StatefulWidget {
  const TranslatorApp({super.key});

  @override
  State<TranslatorApp> createState() => _TranslatorAppState();
}

class _TranslatorAppState extends State<TranslatorApp> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  List<String> languages = [
    'English',
    'Hindi',
    'Arabic',
    'German',
    'Russian',
    'Spanish',
    'Urdu',
    'Japanese',
    'Italian',
    'Vietnamese',
    'Chinese',
  ];

  Map<String, String> languageMap = {
    'English': 'en',
    'Hindi': 'hi',
    'Arabic': 'ar',
    'German': 'de',
    'Russian': 'ru',
    'Spanish': 'es',
    'Urdu': 'ur',
    'Japanese': 'ja',
    'Italian': 'it',
    'Vietnamese': 'vi',
     'Chinese': 'zh',
  };
  final translator = GoogleTranslator();
  String from = 'vi';
  String to = 'en';
  String data = 'Hello teacher Truyen';
  String selectedvalue = 'Vietnamese';
  String selectedvalue2 = 'English';
  TextEditingController controller =
      TextEditingController(text: 'Chào thầy Truyền ');
  final formkey = GlobalKey<FormState>();
  bool isloading = false;

  translate() async {
    try {
      if (formkey.currentState!.validate()) {
        await translator.translate(controller.text, from: from, to: to).then((value) {
          data = value.text;
          isloading = false;
          setState(() {});
        });
      }
    } on SocketException catch (_) {
      isloading = true;
      SnackBar mysnackbar = const SnackBar(
        content: Text('Internet not Connected'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(mysnackbar);
      setState(() {});
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   translate();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
            decoration: const BoxDecoration(
          color: Colors.blue,
        )),
        title: const Text(
          'Translator App',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 171, 232, 241),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30, //canh lề trên của khung body text in & out
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('From'),
                const SizedBox(
                  width: 80,
                ),
                DropdownButton(
                  value: selectedvalue,
                  focusColor: Colors.black,
                  items: languages.map((lang) {
                    return DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                      onTap: () {
                        setState(() {
                          from = languageMap[lang]!;
                          selectedvalue = lang; // Cập nhật giá trị khi thay đổi dropdown
                        });
                      },
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedvalue = value!; // Cập nhật giá trị khi thay đổi dropdown
                    });
                  },
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black)),
            child: Form(
              key: formkey,
              child: TextFormField(
                controller: controller,
                maxLines: null,
                minLines: null,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    errorStyle: TextStyle(color: Colors.black)),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20), //kích ỡ khung của to language
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('To'),
                const SizedBox(
                  width: 80,
                ),
                DropdownButton(
                  value: selectedvalue2,
                  focusColor: Colors.black,
                  items: languages.map((lang) {
                    return DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                      onTap: () {
                        setState(() {
                          to = languageMap[lang]!;
                          selectedvalue2 = lang; // Cập nhật giá trị khi thay đổi dropdown
                        });
                      },
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedvalue2 = value!; // Cập nhật giá trị khi thay đổi dropdown
                    });
                  },
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20), //khung out text translate
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black)),
            child: Center(
              child: SelectableText(
                data,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: translate,
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.lightBlue.shade400),
              fixedSize: MaterialStateProperty.all(
                  const Size(250, 45)), //kích cỡ button translate
            ),
            child: isloading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : const Text('Translate',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,  //speak with mic
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(microseconds: 3000),
        repeatPauseDuration: const Duration(microseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none_sharp),

        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            controller.text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
            }
          }),
        );
        // Hiển thị thông báo yêu cầu người dùng nói
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xin mời nói...'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      // Hiển thị thông báo mic đã tắt
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone đã tắt'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

}
