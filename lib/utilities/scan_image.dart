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

// Future<String?> scanImage(BuildContext context, String path) async {
//   try {
//     String _extractedText = "";
//     final file = File(path);
//     final inputImage = InputImage.fromFile(file);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     final RecognizedText recognizedText =
//         await textRecognizer.processImage(inputImage);

//     String text = recognizedText.text;
//     for (TextBlock block in recognizedText.blocks) {
//       // Each block of text/section of text
//       final String blockText = block.text;
//       log("Block of text: $blockText");

//       for (TextLine line in block.lines) {
//         log('line.text' + line.text);
//         // Each line within a text block
//         for (TextElement element in line.elements) {
//           // Each word within a line
//           _extractedText += element.text + " ";
//         }
//       }
//     }

//     _extractedText += "\n\n";
//     log("Extracted Text: $_extractedText");
//     return _extractedText;
//   } catch (e) {
//     showErrorDialog(context, "An error occurred when scanning text");
//     return null;
//   }
// }
