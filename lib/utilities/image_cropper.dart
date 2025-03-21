import 'package:formcapture/imports.dart';

Future<String> cropImage(BuildContext context, String path) async {
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
    return croppedFile.path;
  } else {
    return '';
  }
}
