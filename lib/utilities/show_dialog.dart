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
    optionsBuilder: () => {'Cancel': false, 'Sign Out': true},
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
    title: 'An error occurred',
    content: errorMessage,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}

Future<bool> showDeleteConfirmationDialog(
    BuildContext context, String message) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete Confirmation',
    content: message,
    optionsBuilder: () => {'Cancel': false, 'Delete': true},
  ).then(
    (value) => value ?? false,
  );
}

Future<void> showCannotShareEmptyNoteDialog(
    BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Alert',
    content: 'You cannot share empty notes.',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
