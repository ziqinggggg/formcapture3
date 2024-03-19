import 'dart:developer';
import 'package:formcapture/imports.dart';

Future<String> pickImage(context, {ImageSource? source}) async {

  String path = '';

  try {
    final image = await ImagePicker().pickImage(source: source!);

    if (image != null) {
      path = image.path;
    } else {
      path = '';
    }
  } catch (e) {
    showErrorDialog(context, "Failed to select an image. Please try again.");
  }

  return path;
}
