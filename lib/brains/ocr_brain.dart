import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class OCRBrain {
  late String output;

  Future<XFile?> getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    XFile? picked = await picker.pickImage(source: source);
    if (picked == null) return null;
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio3x2,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: const Color(0xFF412795),
          backgroundColor: Colors.white,
          activeControlsWidgetColor: const Color(0xFF412795),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );
    if (cropped == null) return null;
    XFile image = XFile(cropped.path);
    return image;
  }

  Future<File?> getPDF() async {
    FilePickerResult? picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
    if (picked == null) return null;
    return File(picked.files.single.path!);
  }

  Future<String> recognizeText(XFile inputFile) async {
    final recognizer = TextRecognizer();
    final InputImage input;
    late RecognizedText output;
    try {
      input = InputImage.fromFilePath(inputFile.path);
      output = await recognizer.processImage(input);
    } catch (e) {
      recognizer.close();
      return 'Error during text recognition: $e';
    }
    recognizer.close();
    if (output.text != '') return output.text;
    return 'No text found in image!';
  }

  Future scanPDF(File inputFile) async {
    final String text;
    try {
      final doc = PdfDocument(inputBytes: inputFile.readAsBytesSync());
      text = PdfTextExtractor(doc).extractText();
      doc.dispose();
    } catch (e) {
      return 'Error during pdf scan: $e';
    }
    if (text != '') return text;
    return 'No text found in image!';
  }
}
