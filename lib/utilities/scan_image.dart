import 'package:formcapture/imports.dart';

Future<String?> scanImage(context, path) async {
  try {
    final file = File(path);

    final inputImage = InputImage.fromFile(file);
    final recognizedText = await TextRecognizer().processImage(inputImage);
    log(recognizedText.text);
    return recognizedText.text;
    // Navigator.pop(context, recognizedText.text);
  } catch (e) {
    showErrorDialog(context, "An error occurred when scanning text");
  }
}
