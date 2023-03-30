import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("recognized page")),
        body: _isBusy == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  maxLines: MediaQuery.of(context).size.height.toInt(),
                  controller: controller,
                  decoration:
                      const InputDecoration(hintText: "Text goes here..."),
                ),
              ));
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    log(image.filePath!);
    final RecognizedText recognizedText =
         await textRecognizer.processImage(image);

    final RegExp nameRegExp = RegExp(r'([A-Z][a-z]+)\s([A-Z][a-z]+)\s([A-Z][a-z]+)');
    // final RegExp nameRegExp = RegExp(r'^([A-Z][a-z]+)\s([A-Z][a-z]+)(?:\s([A-Z]\.)\s?)?([A-Z][a-z]+)?$');
    final Match nameMatch = nameRegExp.firstMatch(recognizedText.text) as Match;
    final String? name = nameMatch.group(0);

    controller.text = name!.toString();

    ///End busy state
    setState(() {
      _isBusy = false;
    });
  }
}
