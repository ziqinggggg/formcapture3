import 'package:formcapture/imports.dart';

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
    content: 'Are you sure you want to delete this entry?',
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

Future<void> showCannotShareEmptyEntryDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Cannot Share an Empty Entry',
    content: 'Please add some content to your entry before sharing.',
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

Future<void> showResetPasswordSentDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Reset Password',
    content:
        "We've sent a reset password link to your account, please check your email for more information.",
    optionsBuilder: () => {
      'OK': null,
    },
  );
}

Future<void> showShareDialog(BuildContext context, String title, String text,
    List<Map<String, String>> formData) {
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          return AlertDialog(
            title: const Text('Share'),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Share.share('Title: ' +
                                title +
                                '\n' +
                                text +
                                '\nForm Data: \n' +
                                formData.toString());
                            Navigator.of(context).pop();
                          },
                          child: const Text('Share as text')),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            shareAsPdf(title, text, formData);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Share as pdf')),
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            shareToExcel(title, text, formData);
                            // shareListToExcel(title, text, formData); //!!!!!!!!!!!!!
                            Navigator.of(context).pop();
                          },
                          child: const Text('Share as .xlsx')),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
