import 'package:formcapture/imports.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:developer' as devtools show log;

Future<String?> scanImage(context, path) async {
  try {
    final file = File(path);

    final inputImage = InputImage.fromFile(file);
    final recognizedText = await TextRecognizer().processImage(inputImage);
    devtools.log(recognizedText.text);
    return recognizedText.text;
    // Navigator.pop(context, recognizedText.text);
  } catch (e) {
    showErrorDialog(context, "An error occurred when scanning text");
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('An error occurred when scanning text'),
    //   ),
    // );
  }
}
