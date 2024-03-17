import 'package:formcapture/imports.dart';

// class ErrorDialog {
//   static void showErrorDialog(BuildContext context, String errorMessage) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: Text(errorMessage, style: const TextStyle(fontSize: 16)),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

Future<bool> showAlertDialog(BuildContext context, String message) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Alert',
    content: message,
    optionsBuilder: () => {'Cancel': false, 'Continue': true},
  ).then(
    (value) => value ?? false,
  );
}

Future<void> showErrorDialog(
  BuildContext context,
  String errorMessage,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'Error',
    content: errorMessage,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}

Future<bool> showDeleteConfirmationDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Confirm Delete',
    content: 'Are you sure you want to delete this note?',
    optionsBuilder: () => {'Cancel': false, 'Delete': true},
  ).then(
    (value) => value ?? false,
  );
}

Future<bool> showSignOutConfirmationDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Sign Out Confirmation',
    content: 'Are you sure you want to sign out?',
    optionsBuilder: () => {'Cancel': false, 'Sign Out': true},
  ).then(
    (value) => value ?? false,
  );
}

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Cannot Share Empty Note',
    content: 'Please add content to your note before sharing.',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}

Future<bool> cameraOrGalleryDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Upload Image',
    content: 'Choose an image to upload',
    optionsBuilder: () => {'Photo Library': false, 'Take Photo': true},
  ).then(
    (value) => value ?? false,
  );
}
