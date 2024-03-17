import 'dart:developer' as devtools show log;
import 'package:formcapture/imports.dart';

Future<String> cropImage(String path, BuildContext context) async {
  devtools.log('cropping image');
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: path,

    // aspectRatioPresets: [
    //   CropAspectRatioPreset.square,
    //   CropAspectRatioPreset.ratio3x2,
    //   CropAspectRatioPreset.original,
    //   CropAspectRatioPreset.ratio4x3,
    //   CropAspectRatioPreset.ratio16x9
    // ],
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    ],
  );
  if (croppedFile != null) {
    devtools.log("Image cropped");
    return croppedFile.path;
  } else {
    devtools.log("Do nothing");
    return '';
  }
}
