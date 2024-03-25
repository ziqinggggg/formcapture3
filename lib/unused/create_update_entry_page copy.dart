// // create_entry_page.dart

// // ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

// import 'package:formcapture/imports.dart';
// import 'package:intl/intl.dart';

// class CreateUpdateEntry extends StatefulWidget {
//   const CreateUpdateEntry({
//     super.key,
//   });

//   @override
//   State<CreateUpdateEntry> createState() => _CreateUpdateEntryState();
// }

// class _CreateUpdateEntryState extends State<CreateUpdateEntry> {
//   // DatabaseEntry? _entry;
//   // late final EntriesService _entriesService;

//   CloudEntry? _entry;
//   late final FirebaseCloudStorage _entriesService;

//   late final TextEditingController _titleController;
//   late final TextEditingController _textController;
//   late final String createdDate;

//   // final _fieldNamesController = StreamController<List<String>>.broadcast();
//   // Stream<List<String>> get fieldNamesStream => _fieldNamesController.stream;
//   // late final StreamController<List<String>> _fieldNamesController;

// //! datatable method
//   List<List<TextEditingController>> formDataControllersList = [];
//   List<TextEditingController> formHeaderControllers = [];

//   List<String> formHeader = [];
//   List<Map<String, String>> formData = [];

//   @override
//   void initState() {
//     // _entriesService = EntriesService();
//     _entriesService = FirebaseCloudStorage();
//     _titleController = TextEditingController();
//     _textController = TextEditingController();
//     // _fieldNamesController = StreamController();
//     super.initState();
//   }

//   void _titleControllerListener() async {
//     final entry = _entry;
//     if (entry == null) {
//       return;
//     }
//     final title = _titleController.text;
//     final text = _textController.text;
//     await _entriesService.updateEntry(
//       documentId: entry.documentId,
//       title: title,
//       text: text,
//       formHeader: formHeader,
//       formData: formData,
//     );
//   }

//   void _textControllerListener() async {
//     final entry = _entry;
//     if (entry == null) {
//       return;
//     }
//     final title = _titleController.text;
//     final text = _textController.text;

//     await _entriesService.updateEntry(
//       documentId: entry.documentId,
//       title: title,
//       text: text,
//       formHeader: formHeader,
//       formData: formData,
//     );
//   }

//   void _setupTextControllerListener() {
//     _textController.removeListener(_textControllerListener);
//     _textController.addListener(_textControllerListener);
//     _titleController.removeListener(_titleControllerListener);
//     _titleController.addListener(_titleControllerListener);
//   }

//   Future<CloudEntry> createOrGetExistingEntry(BuildContext context) async {
//     final widgetEntry = context.getArgument<CloudEntry>();

//     if (widgetEntry != null) {
//       _entry = widgetEntry;
//       createdDate = DateFormat('yyyy/MM/dd HH:mm')
//           .format(widgetEntry.createdDate.toDate());
//       if (_titleController.text.isEmpty && _textController.text.isEmpty) {
//         _titleController.text = widgetEntry.title;
//         _textController.text = widgetEntry.text;
//       }

//       if (widgetEntry.formData.isNotEmpty) {
//         for (var header in widgetEntry.formHeader) {
//           formHeaderControllers.add(TextEditingController(text: header));
//         }
//         for (var data in widgetEntry.formData) {
//           List<TextEditingController> formDataControllers = [];
//           for (var key in widgetEntry.formHeader) {
//             formDataControllers.add(TextEditingController(text: data[key]));
//           }
//           formDataControllersList.add(formDataControllers);
//         }
//       }

//       return widgetEntry;
//     }

//     final existingEntry = _entry;
//     if (existingEntry != null) {
//       return existingEntry;
//     }

//     final currentUser = AuthService.firebase().currentUser!;
//     final userId = currentUser.id;
//     final newEntry = await _entriesService.createNewEntry(ownerUserId: userId);
//     createdDate = DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now());
//     _entry = newEntry;

//     return newEntry;
//   }

//   void _deleteEntryIfTextIsEmpty() {
//     final entry = _entry;
//     if (_textController.text.isEmpty &&
//         _titleController.text.isEmpty &&
//         entry != null) {
//       _entriesService.deleteEntry(documentId: entry.documentId);
//       // _entriesService.deleteEntry(id: entry.id);
//     }
//   }

//   void _saveEntryIfTextNotEmpty() async {
//     final entry = _entry;
//     final title = _titleController.text;
//     final text = _textController.text;
//     formHeader = [];
//     formData = [];

//     if (formHeaderControllers.isNotEmpty) {
//       for (int i = 0; i < formHeaderControllers.length; i++) {
//         formHeader.add(formHeaderControllers[i].text);
//       }
//     }
//     if (formDataControllersList.isNotEmpty) {
//       for (var formDataControllers in formDataControllersList) {
//         Map<String, String> formDataMap = {};
//         for (int i = 0; i < formDataControllers.length; i++) {
//           formDataMap[formHeader[i]] = formDataControllers[i].text;
//         }
//         formData.add(formDataMap);
//       }
//     }
//     if (entry != null && (title.isNotEmpty | text.isNotEmpty)) {
//       await _entriesService.updateEntry(
//         documentId: entry.documentId,
//         title: title.isNotEmpty ? title : 'Untitled',
//         text: text,
//         formHeader: formHeader,
//         formData: formData,
//       );
//     }
//   }

//   // void _saveEntry(String? newText) async {
//   //   final entry = _entry;
//   // final title = _titleController.text;
//   // final text = _textController.text;
//   // if (entry != null) {
//   //   await _entriesService.updateEntry(
//   //     documentId: entry.documentId,
//   //     title: title,
//   //     text: text,
//   //   );
//   //   log('entry updated');
//   // }
//   // }

//   @override
//   void dispose() {
//     _deleteEntryIfTextIsEmpty();
//     _saveEntryIfTextNotEmpty();
//     _titleController.dispose();
//     _textController.dispose();
//     // _fieldNamesController.close();
//     formHeaderControllers.forEach((controller) => controller.dispose());
//     formDataControllersList.forEach((formDataControllers) {
//       formDataControllers.forEach((controller) => controller.dispose());
//     });

//     super.dispose();
//   }

//   Future<String> selectAndCropImage() async {
//     bool takePhoto = await cameraOrGalleryDialog(context);
//     final String? imagePath;
//     if (takePhoto) {
//       imagePath = await pickImage(context, source: ImageSource.camera);
//     } else {
//       imagePath = await pickImage(context, source: ImageSource.gallery);
//     }
//     return cropImage(context, imagePath);
//   }

//   void insertRecognizedText(String scannedText) async {
//     final currentText = _textController.text;
//     if (currentText.isEmpty) {
//       _textController.text = 'Scanned Text: $scannedText';
//     } else {
//       _textController.text += '\n\nScanned Text: $scannedText';
//     }
//     // _saveEntry(null);
//   }

//   String extractFieldValue(List fieldName, String text, int i) {
//     String escapedFieldName = RegExp.escape(fieldName[i]);
//     RegExp regex = RegExp('$escapedFieldName:*\\s*\\n*(.*?)(?=(\\n|\$))',
//         caseSensitive: false);
//     Match? match = regex.firstMatch(text);
//     return match?.group(1)?.trim() ?? '';
//   }

//   void showEditDialog(int i) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, setState) {
//             return AlertDialog(
//               title: const Text('Edit Data'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     // Display input fields for each column of the row
//                     for (int j = 0; j < formHeaderControllers.length; j++)
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: TextField(
//                           controller: formDataControllersList[i][j],
//                           decoration: InputDecoration(
//                             labelText: formHeaderControllers[j].text,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     setState(() {
//                       _saveEntryIfTextNotEmpty();
//                     });
//                     Navigator.of(context).pop(); // Close the dialog
//                   },
//                   child: const Text('Save'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
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
//                 if (_entry == null || (text.isEmpty && title.isEmpty)) {
//                   _saveEntryIfTextNotEmpty();
//                   await showCannotShareEmptyEntryDialog(context);
//                 } else {
//                   Share.share('Title: ' + title + '\n' + text);
//                 }
//               } else if (value == 'excel') {
//                 _saveEntryIfTextNotEmpty();
//                 shareListToExcel(formData);
//               } else if (value == 'delete') {
//                 bool shoulddelete = await showDeleteConfirmationDialog(context);
//                 if (shoulddelete) {
//                   final entry = _entry;
//                   await _entriesService.deleteEntry(documentId: entry!.documentId);
//                   await Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const EntriesPage()),
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
//               if (formHeaderControllers.isNotEmpty)
//                 const PopupMenuItem<String>(
//                   value: 'excel',
//                   child: ListTile(
//                     leading: Icon(Icons.share),
//                     title: Text('Share to Excel'),
//                   ),
//                 ),
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
//         future: createOrGetExistingEntry(context),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               _setupTextControllerListener;
//               return Container(
//                 child: SafeArea(
//                   bottom: false,
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Column(
//                         children: [
//                           // const FormattingToolBar(),
//                           Text(
//                             'Created: $createdDate',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: lightTheme
//                                   ? Colors.grey.shade700
//                                   : Colors.grey.shade400,
//                             ),
//                           ),
//                           TextField(
//                             controller: _titleController,
//                             maxLines: null,
//                             style: const TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             decoration: const InputDecoration(
//                               hintText: 'Title',
//                               hintStyle: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 28,
//                               ),
//                               border: InputBorder.none,
//                             ),
//                             // onChanged: _saveEntry,
//                           ),
//                           TextField(
//                             controller: _textController,
//                             keyboardType: TextInputType.multiline,
//                             maxLines: null,
//                             decoration: const InputDecoration(
//                               hintText: 'Body',
//                               border: InputBorder.none,
//                             ),
//                             // onChanged: _saveEntry,
//                           ),

//                           // StreamBuilder(
//                           //   stream: _fieldNamesController.stream,
//                           //   builder: (context, snapshot) {
//                           //     if (snapshot.hasData) {
//                           //       log('snapshot has data!!!');
//                           //       final fieldNames =
//                           //           snapshot.data as List<String>;
//                           //     .log('fieldNames' + fieldNames.toString());
//                           Visibility(
//                             //!DataTable
//                             visible: formHeaderControllers.isNotEmpty,
//                             child: formHeaderControllers.isNotEmpty
//                                 ? Column(
//                                     children: [
//                                       SingleChildScrollView(
//                                         scrollDirection: Axis.horizontal,
//                                         child: Column(
//                                           children: [
//                                             DataTable(
//                                               border: const TableBorder(
//                                                 verticalInside: BorderSide(
//                                                   width: 1,
//                                                   style: BorderStyle.solid,
//                                                 ),
//                                               ),
//                                               columns: <DataColumn>[
//                                                 for (int i = 0;
//                                                     i <
//                                                         formHeaderControllers
//                                                             .length;
//                                                     i++)
//                                                   DataColumn(
//                                                     label: Expanded(
//                                                       child: TextField(
//                                                         controller:
//                                                             formHeaderControllers[
//                                                                 i],
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         keyboardType:
//                                                             TextInputType
//                                                                 .multiline,
//                                                         maxLines: null,
//                                                         decoration:
//                                                             const InputDecoration(
//                                                           border:
//                                                               InputBorder.none,
//                                                         ),
//                                                         style: const TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 const DataColumn(
//                                                   label: Text(''),
//                                                 ),
//                                               ],
//                                               rows: <DataRow>[
//                                                 for (int i = 0;
//                                                     i <
//                                                         formDataControllersList
//                                                             .length;
//                                                     i++)
//                                                   DataRow(
//                                                     onLongPress: () {},
//                                                     cells: <DataCell>[
//                                                       for (int j = 0;
//                                                           j <
//                                                               formHeaderControllers
//                                                                   .length;
//                                                           j++)
//                                                         DataCell(
//                                                           TextField(
//                                                             controller:
//                                                                 formDataControllersList[
//                                                                     i][j],
//                                                             // keyboardType:
//                                                             //     TextInputType.multiline,
//                                                             maxLines: null,
//                                                             decoration:
//                                                                 const InputDecoration(
//                                                               border:
//                                                                   InputBorder
//                                                                       .none,
//                                                               // suffixIcon: j ==
//                                                               //         formHeaderControllers
//                                                               //                 .length -
//                                                               //             1
//                                                               //     ? IconButton(
//                                                               //         icon: Icon(
//                                                               //           Icons
//                                                               //               .delete_outline_rounded,
//                                                               //           size: 18,
//                                                               //           color: Colors
//                                                               //               .red
//                                                               //               .shade700,
//                                                               //         ),
//                                                               //         onPressed:
//                                                               //             () async {
//                                                               //           bool
//                                                               //               shoulddelete =
//                                                               //               await showDeleteConfirmationDialog(
//                                                               //                   context);
//                                                               //           if (shoulddelete) {
//                                                               //             setState(() {
//                                                               //               formDataControllersList
//                                                               //                   .removeAt(
//                                                               //                       i);
//                                                               //             });
//                                                               //           }
//                                                               //         },
//                                                               //       )
//                                                               //     : null,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       DataCell(
//                                                         Row(
//                                                           children: [
//                                                             IconButton(
//                                                               icon: const Icon(
//                                                                 Icons
//                                                                     .edit_outlined,
//                                                                 size: 18,
//                                                               ),
//                                                               onPressed:
//                                                                   () async {
//                                                                 showEditDialog(
//                                                                     i);
//                                                               },
//                                                             ),
//                                                             IconButton(
//                                                               icon: Icon(
//                                                                 Icons
//                                                                     .delete_outline_rounded,
//                                                                 size: 18,
//                                                                 color: Colors
//                                                                     .red
//                                                                     .shade700,
//                                                               ),
//                                                               onPressed:
//                                                                   () async {
//                                                                 bool
//                                                                     shoulddelete =
//                                                                     await showDeleteConfirmationDialog(
//                                                                         context);
//                                                                 if (shoulddelete) {
//                                                                   setState(() {
//                                                                     formDataControllersList
//                                                                         .removeAt(
//                                                                             i);
//                                                                   });
//                                                                 }
//                                                               },
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : Container(),
//                           ),
//                           //     } else if (snapshot.hasError) {
//                           //       log('Error: ${snapshot.error}');
//                           //       return Text('Error: ${snapshot.error}');
//                           //     } else {
//                           //       log('No data available');
//                           //       return Container();
//                           //     }
//                           //   },
//                           // ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );

//             default:
//               return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: lightTheme ? Colors.black : Colors.grey.shade800,
//         child: const Icon(
//           Icons.camera_alt_outlined,
//           color: Colors.white,
//         ),
//         onPressed: () {
//           showMenu(
//             context: context,
//             position: const RelativeRect.fromLTRB(100, 645, 0, 0),
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
//           ).then(
//             (value) async {
//               if (value == 'scanText') {
//                 final selectedImagePath = await selectAndCropImage();
//                 String? scannedText =
//                     await scanImage(context, selectedImagePath);
//                 insertRecognizedText(scannedText!);
//               } else if (value == 'scanForm') {
//                 final selectedImagePath = await selectAndCropImage();

//                 String? scannedText =
//                     await scanImage(context, selectedImagePath);

//                 if (selectedImagePath.isNotEmpty) {
//                   List fieldNames = [];
//                   if (formHeaderControllers.isEmpty) {
//                     fieldNames = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               InputForm(path: selectedImagePath)),
//                     );
//                     formHeaderControllers.addAll(
//                       fieldNames
//                           .map((text) => TextEditingController(text: text)),
//                     );
//                   } else {
//                     fieldNames = formHeaderControllers
//                         .map((controller) => controller.text)
//                         .toList();
//                   }
//                   List<TextEditingController> formDataControllers = [];
//                   setState(() {
//                     for (int i = 0; i < formHeaderControllers.length; i++) {
//                       String extractedText =
//                           extractFieldValue(fieldNames, scannedText!, i);
//                       formDataControllers
//                           .add(TextEditingController(text: extractedText));
//                     }
//                     formDataControllersList.add(formDataControllers);
//                   });
//                 }
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }
