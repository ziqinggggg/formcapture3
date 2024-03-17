import 'dart:developer';
import 'package:formcapture/imports.dart';

Future<String> pickImage({ImageSource? source}) async {

  String path = '';

  try {
    final image = await ImagePicker().pickImage(source: source!);

    if (image != null) {
      path = image.path;
    } else {
      path = '';
    }
  } catch (e) {
    log(e.toString());
  }

  return path;
}
