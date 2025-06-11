import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image2text/brains/ocr_brain.dart';
import 'package:image2text/custom_widgets/bottom_bar_button.dart';

class ResultScreen extends StatefulWidget {
  var inputFile;

  ResultScreen(this.inputFile, {super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? myText;
  var inputFile;
  bool showText = true;
  OCRBrain ocrBrain = OCRBrain();

  getText() async {
    late String text;
    if (inputFile is XFile) {
      text = await ocrBrain.recognizeText(inputFile);
    } else {
      text = await ocrBrain.scanPDF(inputFile);
    }
    setState(() {
      myText = text;
    });
  }

  Widget? viewInputFile() {
    if (inputFile is XFile) {
      return Container(
        child: Image.file(
          File(inputFile.path),
        ),
      );
    } else {
      return const Center(
        child: Text(
            textAlign: TextAlign.center,
            'unable to show pdf file at the moment, this functionality will be added soon in the future'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    inputFile = widget.inputFile;
    getText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF412795),
        centerTitle: true,
        title: const Text('RESULT'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFE0DAFC),
              Color(0xFFC0D8FA),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: myText == null
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF412795),
                          ),
                        )
                      : showText
                          ? TextFormField(
                              initialValue: myText,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontFamily: ''),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                fillColor: const Color(0x44FFFFFF),
                                filled: true,
                              ),
                              maxLines: null,
                              onChanged: (value) {
                                setState(() {
                                  myText = value;
                                });
                              },
                            )
                          : viewInputFile(), //viewInputFile(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              showText
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BBButton(
                          onTap: () async {
                            final clipboard = ClipboardData(text: myText!);
                            await Clipboard.setData(clipboard);
                            Fluttertoast.showToast(
                              msg: "copied to clipboard!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: const Color(0xEE412795),
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                          icon: Icons.copy_all,
                          text: 'Copy',
                        ),
                        BBButton(
                          onTap: () {
                            setState(() {
                              showText = !showText;
                            });
                          },
                          icon: Icons.photo_outlined,
                          text: 'Switch',
                        ),
                        BBButton(
                          onTap: () async {
                            await Share.share(myText!);
                          },
                          icon: Icons.share_rounded,
                          text: 'Share',
                        ),
                      ],
                    )
                  : Center(
                      child: BBButton(
                        onTap: () {
                          setState(() {
                            showText = !showText;
                          });
                        },
                        text: 'Switch',
                        icon: Icons.text_fields,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
