// ! before changing future builder

// // create_note_page.dart

// import 'package:formcapture/imports.dart';
// import 'dart:developer' as devtools show log;
// import 'package:intl/intl.dart';

// class CreateUpdateNote extends StatefulWidget {
//   const CreateUpdateNote({
//     super.key,
//   });

//   @override
//   State<CreateUpdateNote> createState() => _CreateUpdateNoteState();
// }

// class _CreateUpdateNoteState extends State<CreateUpdateNote> {
//   // DatabaseNote? _note;
//   // late final NotesService _notesService;

//   CloudNote? _note;
//   late final FirebaseCloudStorage _notesService;

//   late final TextEditingController _titleController;
//   late final TextEditingController _textController;
//   late final String createdDate;
//   String? scannedText;

//   @override
//   void initState() {
//     // _notesService = NotesService();
//     _notesService = FirebaseCloudStorage();
//     _titleController = TextEditingController();
//     _textController = TextEditingController();
//     super.initState();
//   }

//   void _titleControllerListener() async {
//     final note = _note;
//     if (note == null) {
//       return;
//     }
//     final title = _titleController.text;
//     final text = _textController.text;
//     await _notesService.updateNote(
//       documentId: note.documentId,
//       title: title,
//       text: text,
//     );
//   }

//   void _textControllerListener() async {
//     final note = _note;
//     if (note == null) {
//       return;
//     }
//     final title = _titleController.text;
//     final text = _textController.text;
//     await _notesService.updateNote(
//       documentId: note.documentId,
//       title: title,
//       text: text,
//     );
//   }

//   void _setupTextControllerListener() {
//     _textController.removeListener(_textControllerListener);
//     _textController.addListener(_textControllerListener);
//     _titleController.removeListener(_titleControllerListener);
//     _titleController.addListener(_titleControllerListener);
//   }

//   Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
//     final widgetNote = context.getArgument<CloudNote>();

//     if (widgetNote != null) {
//       _note = widgetNote;
//       _titleController.text = widgetNote.title;
//       _textController.text = widgetNote.text;
//       createdDate = DateFormat('yyyy/MM/dd HH:mm')
//           .format(widgetNote.createdDate.toDate());
//       return widgetNote;
//     }

//     final existingNote = _note;
//     if (existingNote != null) {
//       return existingNote;
//     }

//     final currentUser = AuthService.firebase().currentUser!;
//     final userId = currentUser.id;
//     final newNote = await _notesService.createNewNote(ownerUserId: userId);
//     createdDate = DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now());
//     _note = newNote;

//     return newNote;
//   }

//   // void insertRecognizedText(BuildContext context, String scannedText) {
//   //   setState(() {
//   //     final currentText = _textController.text;
//   //     if (currentText.isEmpty) {
//   //       _textController.text = 'Scanned Text: $scannedText';
//   //     } else {
//   //       _textController.text += '\n\nScanned Text: $scannedText';
//   //     }
//   //   });
//   // }

//   void _deleteNoteIfTextIsEmpty() {
//     final note = _note;
//     if (_textController.text.isEmpty &&
//         _titleController.text.isEmpty &&
//         note != null) {
//       _notesService.deleteNote(documentId: note.documentId);
//       // _notesService.deleteNote(id: note.id);
//     }
//   }

//   void _saveNoteIfTextNotEmpty() async {
//     final note = _note;
//     final title = _titleController.text;
//     final text = _textController.text;

//     if (note != null && (title.isNotEmpty | text.isNotEmpty)) {
//       if (title.isNotEmpty) {
//         await _notesService.updateNote(
//           documentId: note.documentId,
//           title: title,
//           text: text,
//         );
//       } else if (title.isEmpty) {
//         await _notesService.updateNote(
//           documentId: note.documentId,
//           title: 'Untitled',
//           text: text,
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _deleteNoteIfTextIsEmpty();
//     _saveNoteIfTextNotEmpty();
//     _titleController.dispose();
//     _textController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool lightTheme = Theme.of(context).brightness == Brightness.light;
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           PopupMenuButton<String>(
//             offset: const Offset(0, 50),
//             onSelected: (value) async {
//               if (value == 'share') {
//                 final title = _titleController.text;
//                 final text = _textController.text;
//                 if (_note == null || (text.isEmpty && title.isEmpty)) {
//                   await showCannotShareEmptyNoteDialog(context);
//                 } else {
//                   Share.share('Title: ' + title + '\n' + text);
//                 }
//               } else if (value == 'delete') {
//                 bool shoulddelete = await showDeleteConfirmationDialog(context);
//                 if (shoulddelete) {
//                   final note = _note;
//                   await _notesService.deleteNote(documentId: note!.documentId);
//                   await Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const NotesPage()),
//                   );
//                 }
//               }
//             },
//             itemBuilder: (BuildContext context) => [
//               const PopupMenuItem<String>(
//                 value: 'share',
//                 child: ListTile(
//                   leading: Icon(Icons.share),
//                   title: Text('Share'),
//                 ),
//               ),
//               const PopupMenuItem<String>(
//                 value: 'delete',
//                 child: SizedBox(
//                   child: ListTile(
//                     leading: Icon(Icons.delete,
//                         color: Color.fromARGB(255, 207, 88, 78)),
//                     title: Text(
//                       'Delete',
//                       style: TextStyle(color: Color.fromARGB(255, 207, 88, 78)),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: FutureBuilder(
//         future: createOrGetExistingNote(context),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               _setupTextControllerListener;
//               // setState(() {
//               if (scannedText != null) {
//                 devtools.log('scannedText: ' + scannedText!);
//                 if (_textController.text.isEmpty) {
//                   _textController.text = 'Scanned Text: $scannedText';
//                 } else {
//                   _textController.text += '\n\nScanned Text: $scannedText';
//                 }
//                 scannedText = null;
//               }
//               // });

//               devtools.log(
//                   'building....................._textController.text: ' +
//                       _textController.text);
//               return Container(
//                 child: SafeArea(
//                   bottom: false,
//                   child: 
//                   SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Column(
//                         children: [
//                           // const FormattingToolBar(),
//                           Text(
//                             'Created: $createdDate',
//                             style: TextStyle(
//                               color: lightTheme
//                                   ? Colors.grey.shade700
//                                   : Colors.grey.shade400,
//                             ),
//                           ),
//                           TextField(
//                             controller: _titleController,
//                             maxLines: null,
//                             style: const TextStyle(
//                                 fontSize: 30, fontWeight: FontWeight.bold),
//                             decoration: const InputDecoration(
//                               hintText: 'Title',
//                               hintStyle: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 30,
//                               ),
//                               border: InputBorder.none,
//                             ),
//                           ),
//                           TextField(
//                             controller: _textController,
//                             keyboardType: TextInputType.multiline,
//                             maxLines: null,
//                             style: const TextStyle(
//                               fontSize: 22,
//                             ),
//                             decoration: const InputDecoration(
//                               hintText: 'Body', //todo: add hint text font
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
                
//               );

//             default:
//               return const CircularProgressIndicator();
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: lightTheme ? Colors.black : Colors.grey.shade800,
//         child: const Icon(
//           Icons.camera_alt_outlined,
//           color: Colors.white,
//           // lightTheme ? Colors.black : Colors.white,
//         ),
//         onPressed: () async {
//           showMenu(
//             context: context,
//             position: const RelativeRect.fromLTRB(
//                 100, 645, 0, 0), // Adjust the position as needed
//             items: [
//               const PopupMenuItem(
//                 value: 'scanText',
//                 child: ListTile(
//                     leading: Icon(Icons.text_fields_rounded),
//                     title: Text('Scan Text')),
//               ),
//               const PopupMenuItem(
//                 value: 'scanForm',
//                 child: ListTile(
//                     leading: Icon(Icons.document_scanner_outlined),
//                     title: Text('Scan Form')),
//               ),
//             ],
//           ).then((value) async {
//             if (value == 'scanText') {
//               scannedText = await Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const Scaner()),
//               );
//               // bool takePhoto = await cameraOrGalleryDialog(context);
//               // if (takePhoto) {
//               //   final imagePath = await pickImage(source: ImageSource.camera);
//               //   devtools.log('imagepicked');
//               //   final croppedImagePath =
//               //       await imageCropperView(imagePath, context);
//               //   devtools.log('imagecropped');
//               //   scannedText = await scanImage(context, croppedImagePath);
//               // } else {
//               //   final imagePath = await pickImage(source: ImageSource.gallery);
//               //   devtools.log('imagepicked');
//               //   final croppedImagePath =
//               //       await imageCropperView(imagePath, context);
//               //   devtools.log('imagecropped');
//               //   scannedText = await scanImage(context, croppedImagePath);

//               //   // pickImage(source: ImageSource.gallery).then(
//               //   //   (value) {
//               //   //     devtools.log('imagepicked');
//               //   //     if (value != '') {
//               //   //       imageCropperView(value, context).then(
//               //   //         (value) async {
//               //   //           if (value != '') {
//               //   //             devtools.log('imagecropped');
//               //   //             scannedText = await scanImage(context, value);
//               //   //           }
//               //   //         },
//               //   //       );
//               //   //     }
//               //   //   },
//               //   // );
//               // }
//             } else if (value == 'scanForm') {}
//           });
//         },
//       ),
//     );
//   }
// }
