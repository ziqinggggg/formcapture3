//! b4 removing unwanted comments
// // create_entry_screen.dart

// // ignore_for_file: prefer_interpolation_to_compose_strings

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

//   String? scannedText;
//   List<String> fieldNames = [];
//   //!3
//   List<Map<String, String>> cols = [];
//   //!2
//   List<ExpandableColumn<dynamic>> headers = [];
//   List<ExpandableRow> rows = [];
//   // final _fieldNamesController = StreamController<List<String>>.broadcast();
//   Stream<List<String>> get fieldNamesStream => _fieldNamesController.stream;
//   late final StreamController<List<String>> _fieldNamesController;

// //! datatable method
//   List<List<TextEditingController>> formDataControllersList = [];
//   List<TextEditingController> formHeaderControllers = [];
//   //!3 editable
//   final _editableKey = GlobalKey<EditableState>();
//   // void _addNewRow() {
//   //   setState(() {
//   //     _editableKey.currentState.createRow();
//   //   });
//   // }
//   void _printEditedRows() {
//     List editedRows = _editableKey.currentState!.editedRows;
//     print(editedRows);
//   }

//   @override
//   void initState() {
//     // _entriesService = EntriesService();
//     _entriesService = FirebaseCloudStorage();
//     _titleController = TextEditingController();
//     _textController = TextEditingController();
//     _fieldNamesController = StreamController();

//     scannedText =
//         '''Full name: kanel NG\nAddress: \n489 Beacn Boac, Singapore\nDate Available: 1+| 0s\nPosition applied for: Software tngineer\nNRIC: G 2V5518N\nPhone: 135\nEmail: rachel. na xample. COm\nDesired salary: \$ 00 00
//                           ''';
//     fieldNames = [
//       'Full Name',
//       'Address',
//       'Date Available',
//       'Phone',
//       'Email',
//       'NRIC',
//       'Desired salary'
//     ];

//     // //! 3 editable
//     // cols = generateCols(fieldNames);
//     // //!2
//     // headers = convertToExpandableColumns(fieldNames);
//     // log('headers       $headers');

//     // log('fieldNames.toString()$fieldNames');
//     // _fieldNamesController.add(fieldNames!);
//     // log('_fieldNamesController.toString()$_fieldNamesController');

//     super.initState();
//   }

// //! 2 expandable_datatable
//   List<ExpandableColumn<String>> convertToExpandableColumns(
//       List<String> fieldNames) {
//     List<ExpandableColumn<String>> headers = [];
//     for (String fieldName in fieldNames) {
//       headers.add(
//         ExpandableColumn<String>(
//           columnTitle: fieldName,
//           columnFlex: 1,
//         ),
//       );
//     }
//     return headers;
//   }

//   List<ExpandableRow> convertToExpandableRows(
//       List<Map<String, String>> generatedtext) {
//     List<ExpandableRow> rows = [];

//     for (Map<String, String> map in generatedtext) {
//       List<ExpandableCell<dynamic>> cells = [];

//       map.forEach((key, value) {
//         cells.add(ExpandableCell<String>(columnTitle: key, value: value));
//       });

//       rows.add(ExpandableRow(cells: cells));
//     }

//     return rows;
//   }

//   //! 3 editable
//   List<Map<String, String>> generateCols(List<String> fieldNames) {
//     for (String fieldName in fieldNames) {
//       cols.add({"title": fieldName, 'key': fieldName});
//     }
//     log('cols.toString()' + cols.toString());
//     return cols;
//   }

//   void _titleControllerListener() async {
//     final entry = _entry;
//     if (entry == null) {
//       return;
//     }
//     final title = _titleController.text;
//     final text = _textController.text;
//     await _entriesService.updateEntry(
//         documentId: entry.documentId,
//         title: title,
//         text: text,
//         formData: [],
//         formHeader: []);
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
//       formData: [],
//       formHeader: [],
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
//     List formHeader = [];
//     List<Map<String, String>> formData = [];

//     if (formHeaderControllers.isNotEmpty) {
//       for (int i = 0; i < formHeaderControllers.length; i++) {
//         formHeader.add(formHeaderControllers[i].text);
//       }
//       log('1');
//     }
//     log('formDataControllersList.toString()       ' +
//         formDataControllersList.toString());
//     if (formDataControllersList.isNotEmpty) {
//       log('2');
//       for (var formDataControllers in formDataControllersList) {
//         Map<String, String> formDataMap = {};
//         // Iterate over each TextEditingController in the list
//         for (int i = 0; i < formDataControllers.length; i++) {
//           // Extract the text from the TextEditingController and add it to the map
//           formDataMap[formHeader[i]] = formDataControllers[i].text;
//         }
//         // Add the map to the formData list
//         formData.add(formDataMap);
//         log('formData.toString()       ' + formData.toString());
//       }
//     }
//     log('5');
//     if (entry != null && (title.isNotEmpty | text.isNotEmpty)) {
//       await _entriesService.updateEntry(
//         documentId: entry.documentId,
//         title: title.isNotEmpty ? title : 'Untitled',
//         text: text,
//         formHeader: formHeader,
//         formData: formData,
//       );
//       log('6');
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
//     _fieldNamesController.close();
//     super.dispose();
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

//   Future<String> chooseFromGalleryOrCamera() async {
//     bool takePhoto = await cameraOrGalleryDialog(context);
//     final String? imagePath;
//     if (takePhoto) {
//       imagePath = await pickImage(context, source: ImageSource.camera);
//     } else {
//       imagePath = await pickImage(context, source: ImageSource.gallery);
//     }
//     return cropImage(context, imagePath);
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
//                   await showCannotShareEmptyEntryDialog(context);
//                 } else {
//                   Share.share('Title: ' + title + '\n' + text);
//                 }
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
//                               fontSize: 12,
//                               color: lightTheme
//                                   ? Colors.grey.shade700
//                                   : Colors.grey.shade400,
//                             ),
//                           ),
//                           TextField(
//                             controller: _titleController,
//                             maxLines: null,
//                             style: const TextStyle(
//                               fontSize: 30,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             decoration: const InputDecoration(
//                               hintText: 'Title',
//                               hintStyle: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 30,
//                               ),
//                               border: InputBorder.none,
//                             ),
//                             // onChanged: _saveEntry,
//                           ),
//                           TextField(
//                             controller: _textController,
//                             keyboardType: TextInputType.multiline,
//                             maxLines: null,
//                             style: const TextStyle(
//                               fontSize: 18,
//                             ),
//                             decoration: const InputDecoration(
//                               hintText: 'Body', //todo: add hint text font
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
//                             visible: fieldNames.isNotEmpty,
//                             child: SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: Container(
//                                 // constraints: BoxConstraints(
//                                 //   maxHeight:
//                                 //       (context.findRenderObject() as RenderBox)
//                                 //               .size
//                                 //               .height *
//                                 //           0.8,
//                                 //   maxWidth:
//                                 //       (context.findRenderObject() as RenderBox)
//                                 //               .size
//                                 //               .width *
//                                 //           0.8,
//                                 // ),
//                                 child: DataTable(
//                                   border: const TableBorder(
//                                     verticalInside: BorderSide(
//                                       width: 1,
//                                       style: BorderStyle.solid,
//                                     ),
//                                   ),
//                                   columns: <DataColumn>[
//                                     for (int i = 0;
//                                         i < formHeaderControllers.length;
//                                         i++)
//                                       DataColumn(
//                                         label: Expanded(
//                                           child: TextField(
//                                             controller:
//                                                 formHeaderControllers[i],
//                                             textAlign: TextAlign.center,
//                                             keyboardType:
//                                                 TextInputType.multiline,
//                                             maxLines: null,
//                                             decoration: const InputDecoration(
//                                               border: InputBorder.none,
//                                             ),
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                   rows: <DataRow>[
//                                     for (int i = 0;
//                                         i < formDataControllersList.length;
//                                         i++)
//                                       DataRow(
//                                         cells: <DataCell>[
//                                           for (int j = 0;
//                                               j < formHeaderControllers.length;
//                                               j++)
//                                             DataCell(
//                                               TextField(
//                                                 controller:
//                                                     formDataControllersList[i]
//                                                         [j],
//                                                 keyboardType:
//                                                     TextInputType.multiline,
//                                                 maxLines: null,
//                                                 decoration:
//                                                     const InputDecoration(
//                                                   border: InputBorder.none,
//                                                 ),
//                                               ),
//                                             ),
//                                         ],
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // Visibility(  //!DataTable
//                           //   visible: fieldNames.isNotEmpty,
//                           //   child: SingleChildScrollView(
//                           //     scrollDirection: Axis.horizontal,
//                           //     child: Container(
//                           //       // constraints: BoxConstraints(
//                           //       //   maxHeight:
//                           //       //       (context.findRenderObject() as RenderBox)
//                           //       //               .size
//                           //       //               .height *
//                           //       //           0.8,
//                           //       //   maxWidth:
//                           //       //       (context.findRenderObject() as RenderBox)
//                           //       //               .size
//                           //       //               .width *
//                           //       //           0.8,
//                           //       // ),
//                           //       child: DataTable(
//                           //         border: const TableBorder(
//                           //           verticalInside: BorderSide(
//                           //             width: 1,
//                           //             style: BorderStyle.solid,
//                           //           ),
//                           //         ),
//                           //         columns: <DataColumn>[
//                           //           for (int i = 0; i < fieldNames.length; i++)
//                           //             DataColumn(
//                           //               label: Expanded(
//                           //                 child: Text(
//                           //                   fieldNames[i],
//                           //                   textAlign: TextAlign.center,
//                           //                 ),
//                           //               ),
//                           //             ),
//                           //         ],
//                           //         // rows: AddRows(fieldname: fieldNames, scannedtext: scannedText!),
//                           //         // rows:addRows(fieldNames, scannedText!),
//                           //         rows: <DataRow>[
//                           //           // DataRow(
//                           //           //   cells: addCells(fieldNames, scannedText!),
//                           //           // ),
//                           //           DataRow(
//                           //             cells: <DataCell>[
//                           //               for (int i = 0;
//                           //                   i <
//                           //                       addCells(fieldNames,
//                           //                               scannedText!)
//                           //                           .length;
//                           //                   i++)
//                           //                 DataCell(
//                           //                   // TextField(
//                           //                   //   controller: ,      //help me
//                           //                   //   keyboardType: TextInputType.multiline,
//                           //                   //   maxLines: null,
//                           //                   // ),
//                           //                   Text(
//                           //                     fieldNames[i],
//                           //                     textAlign: TextAlign.center,
//                           //                   ),
//                           //                   // TextFormField(
//                           //                   //   initialValue: 'blablabla',
//                           //                   //   // keyboardType: keyboar,
//                           //                   //   onFieldSubmitted: (val) {
//                           //                   //     print('onSubmited $val');
//                           //                   //   },
//                           //                   // ),
//                           //                 ),
//                           //             ],
//                           //           ),
//                           //         ],
//                           //       ),
//                           //     ),
//                           //   ),
//                           // ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           // Visibility(  //!ExpandableTheme
//                           //   visible: fieldNames.isNotEmpty,
//                           //   child: SingleChildScrollView(
//                           //     scrollDirection: Axis.horizontal,
//                           //     child: Container(
//                           //       constraints: BoxConstraints(
//                           //         maxHeight:
//                           //             (context.findRenderObject() as RenderBox)
//                           //                     .size
//                           //                     .height *
//                           //                 0.8,
//                           //         maxWidth:
//                           //             (context.findRenderObject() as RenderBox)
//                           //                     .size
//                           //                     .width *
//                           //                 2.5,
//                           //       ),
//                           //       child: ExpandableTheme(
//                           //         data: ExpandableThemeData(
//                           //           context,
//                           //           contentPadding: const EdgeInsets.all(1),
//                           //           expandedBorderColor: Colors.transparent,
//                           //           paginationSize: 48,
//                           //           headerColor: Colors.amber[400],
//                           //           headerBorder: const BorderSide(
//                           //             color: Colors.black,
//                           //             width: 1,
//                           //           ),
//                           //           evenRowColor: const Color(0xFFFFFFFF),
//                           //           oddRowColor: Colors.amber[200],
//                           //           rowBorder: const BorderSide(
//                           //             color: Colors.black,
//                           //             width: 0.3,
//                           //           ),
//                           //           rowColor: Colors.green,
//                           //           headerTextMaxLines: 4,
//                           //           headerSortIconColor:
//                           //               const Color(0xFF6c59cf),
//                           //           paginationSelectedFillColor:
//                           //               const Color(0xFF6c59cf),
//                           //           paginationSelectedTextColor: Colors.white,
//                           //         ),
//                           //         child: ExpandableDataTable(
//                           //           headers: headers,
//                           //           rows: convertToExpandableRows(
//                           //               addRows(fieldNames, scannedText!)),
//                           //           multipleExpansion: false,
//                           //           onRowChanged: (newRow) {
//                           //             print(newRow.cells[01].value);
//                           //           },
//                           //           onPageChanged: (page) {
//                           //             print(page);
//                           //           },
//                           //           // renderEditDialog: (row, onSuccess) =>
//                           //           //     _buildEditDialog(row, onSuccess),
//                           //           visibleColumnCount: fieldNames.length,
//                           //         ),
//                           //       ),
//                           //     ),
//                           //   ),
//                           // ),

//                           // Visibility(  //!Editable
//                           //   visible: fieldNames.isNotEmpty,
//                           //   child: SingleChildScrollView(
//                           //     scrollDirection: Axis.horizontal,
//                           //     child: Container(
//                           //       constraints: BoxConstraints(
//                           //         maxHeight:
//                           //             (context.findRenderObject() as RenderBox)
//                           //                     .size
//                           //                     .height *
//                           //                 0.8,
//                           //       ),
//                           //       child: Editable(
//                           //         key: _editableKey, //Assign Key to Widget
//                           //         columns: cols, //
//                           //         rows: addRows(fieldNames, scannedText!),
//                           //         zebraStripe: true,
//                           //         stripeColor2: Colors.amber,
//                           //         borderColor: Colors.amber,
//                           //         onRowSaved: (value) {
//                           //           print(value);
//                           //         },
//                           //         onSubmitted: (value) {
//                           //           print(value);
//                           //         },
//                           //         // tdStyle: TextStyle(
//                           //         //     fontWeight: FontWeight.bold,
//                           //         //     overflow: TextOverflow.fade),
//                           //         // // trHeight: 80,
//                           //         // thStyle: TextStyle(
//                           //         //     overflow: TextOverflow.fade,
//                           //         //     fontWeight: FontWeight.bold),
//                           //         // thAlignment: TextAlign.center,
//                           //         // showSaveIcon: true,
//                           //         // saveIconColor: Colors.black,
//                           //         // showCreateButton: true,
//                           //         // tdAlignment: TextAlign.left,
//                           //         // tdEditableMaxLines:
//                           //         //     100, // don't limit and allow data to wrap
//                           //         // tdPaddingTop: 0,
//                           //         // tdPaddingBottom: 14,
//                           //         // tdPaddingLeft: 10,
//                           //         // tdPaddingRight: 8,
//                           //         // focusedBorder: OutlineInputBorder(
//                           //         //   borderSide: BorderSide(color: Colors.amber),
//                           //         //   borderRadius: BorderRadius.all(
//                           //         //     Radius.circular(0),
//                           //         //   ),
//                           //         // ),
//                           //       ),
//                           //     ),
//                           //   ),
//                           // ),

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
//                 final selectedImagePath = await chooseFromGalleryOrCamera();
//                 scannedText = await scanImage(context, selectedImagePath);
//                 insertRecognizedText(scannedText!);
//               } else if (value == 'scanForm') {
//                 // final selectedImagePath = await chooseFromGalleryOrCamera();
//                 // scannedText = await scanImage(context, selectedImagePath);
//                 // fieldNames = await Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) => const InputForm()),
//                 // );
//                 // // fieldNames = await Navigator.of(context).pushNamed(
//                 // //   '/forminput/',
//                 // // );
//                 scannedText = '''Full name: kanel NG
//                                 Address: 489 Beacn Boac, Singapore
//                                 Date Available: 1+| 0s
//                                 Position applied for: Software tngineer
//                                 NRIC: G 2V5518N
//                                 Phone: 135
//                                 Email: rachel. na xample. COm
//                                 Desired salary: \$ 00 00
//                           ''';
//                 fieldNames = [
//                   'Full Name',
//                   'Adress',
//                   'Phone',
//                   'Email',
//                   'Desired salary'
//                 ];
//                 // log('fieldNames.toString()$fieldNames');
//                 // for (int i = 0; i < fieldNames!.length; i++) {
//                 //   _fieldNamesController.add([fieldNames![i]]);
//                 // }

//                 // log(
//                 //     '_fieldNamesController.toString()$_fieldNamesController'); // how to print the values stored here???
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// // class ShowTable extends StatelessWidget {
// //   final List fieldname;
// //   final String scannedtext;
// //   ShowTable({super.key, required this.fieldname, required this.scannedtext});

// //   List<Map<String, String>> formData = [];
// //   List<Map<String, String>> generateMap(List fieldname, String scannedtext) {
// //     Map<String, String> currentFormData = {};

// //     for (int i = 0; i < fieldname.length; i++) {
// //       String? generatedFieldInput =
// //           extractFieldValue(fieldname, scannedtext, i);
// //       currentFormData[fieldname[i]] = generatedFieldInput ?? '';
// //       formData.add(currentFormData);
// //     }
// //     return formData;
// //   }

// //   String? extractFieldValue(List fieldName, String text, int i) {
// //     String escapedFieldName = RegExp.escape(fieldName[i]);
// //     RegExp regex = RegExp('\$$escapedFieldName:*\\s*(.*?)(?=(\\n|\$))');

// //     Match? match = regex.firstMatch(text);

// //     return match!.group(1)?.trim();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     log('666666');
// //     return
// //     Container(
// //       child: DataTable(
// //         columns: [
// //           for (int i = 0; i < fieldname.length; i++)
// //             DataColumn(label: Text(fieldname[i])),
// //         ],
// //         rows: generateMap(fieldname, scannedtext).map(
// //           (data) {
// //             for (int i = 0; i < fieldname.length; i++) {
// //               DataCell(Text(data[fieldname[i]] ?? ''));
// //             }
// //             return DataRow(cells: [
// //               for (int i = 0; i < fieldname.length; i++)
// //                 DataCell(Text(data[fieldname[i]] ?? '')),
// //             ]);
// //           },
// //         ).toList(),
// //       ),
// //     );
// //   }
// // }

// List<DataCell> addCells(List fieldname, String scannedtext) {
//   String? extractFieldValue(List fieldName, String text, int i) {
//     String escapedFieldName = RegExp.escape(fieldName[i]);

//     RegExp regex = RegExp('$escapedFieldName:*\\s*\\n*(.*?)(?=(\\n|\$))',
//         caseSensitive: false);
//     Match? match = regex.firstMatch(text);
//     return match?.group(1)?.trim();
//   }

//   // List<Map<String, String>> formData = [];
//   Map<String, String> currentFormData = {};

//   for (int i = 0; i < fieldname.length; i++) {
//     String? generatedFieldInput = extractFieldValue(fieldname, scannedtext, i);
//     currentFormData[fieldname[i]] = generatedFieldInput ?? '';
//   }
//   // log('addCells currentFormData' + currentFormData.toString());

//   // List<DataCell> cells = currentFormData.values
//   //     .map<DataCell>((value) => DataCell(Text(value)))
//   //     .toList();

//   List<DataCell> cells = currentFormData.values
//       .map<DataCell>((value) => DataCell(Text(value)))
//       .toList();

//   return cells;
// }

// List<Map<String, String>> addRows(List fieldname, String scannedtext) {
//   String? extractFieldValue(List fieldName, String text, int i) {
//     String escapedFieldName = RegExp.escape(fieldName[i]);

//     RegExp regex = RegExp('$escapedFieldName:*\\s*\\n*(.*?)(?=(\\n|\$))',
//         caseSensitive: false);
//     Match? match = regex.firstMatch(text);
//     return match?.group(1)?.trim();
//   }

//   List<Map<String, String>> formData = [];
//   Map<String, String> currentFormData = {};

//   for (int i = 0; i < fieldname.length; i++) {
//     String? generatedFieldInput = extractFieldValue(fieldname, scannedtext, i);
//     currentFormData[fieldname[i]] = generatedFieldInput ?? '';
//   }

//   formData.add(currentFormData);
//   // log('addRows formData' + formData.toString());

//   return formData;
// }

// //   final List<DataRow> mapped = formData.map((data) {
// //     List<DataCell> cells = [];
// //     for (int i = 0; i < fieldname.length; i++) {
// //       cells.add(
// //         DataCell(
// //           Text(data[fieldname[i]] ?? ''),
// //         ),
// //       );
// //     }
// //     return DataRow(cells: cells);
// //   }).toList();

// //   log('mapped' + mapped.toString());

// //   // final mapped = formData.map(
// //   //   (data) {
// //   //     for (int i = 0; i < fieldname.length; i++) {
// //   //       DataCell(Text(data[fieldname[i]] ?? ''));
// //   //     }
// //   //     return DataRow(cells: [
// //   //       for (int i = 0; i < fieldname.length; i++)
// //   //         DataCell(Text(data[fieldname[i]] ?? '')),
// //   //     ]);
// //   //   },
// //   // ).toList();

// //   return mapped;
// // }

// // class AddRows extends StatelessWidget {
// //   final List fieldname;
// //   final String scannedtext;
// //   AddRows({super.key, required this.fieldname, required this.scannedtext});

// //   List<Map<String, String>> formData = [];
// //   List<Map<String, String>> generateMap(List fieldname, String scannedtext) {
// //     Map<String, String> currentFormData = {};

// //     for (int i = 0; i < fieldname.length; i++) {
// //       String? generatedFieldInput =
// //           extractFieldValue(fieldname, scannedtext, i);
// //       currentFormData[fieldname[i]] = generatedFieldInput ?? '';
// //     }
// //     formData.add(currentFormData);
// //     return formData;
// //   }

// //   String? extractFieldValue(List fieldName, String text, int i) {
// //     String escapedFieldName = RegExp.escape(fieldName[i]);

// //     RegExp regex = RegExp('$escapedFieldName:*\\s*\\n*(.*?)(?=(\\n|\$))',
// //         caseSensitive: false);
// //     Match? match = regex.firstMatch(text);
// //     return match?.group(1)?.trim();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     log('666666');
// //     return Container(
// //       child: DataTable(
// //         columns: [
// //           for (int i = 0; i < fieldname.length; i++)
// //             DataColumn(label: Text(fieldname[i])),
// //         ],
// //         rows: generateMap(fieldname, scannedtext).map(
// //           (data) {
// //             for (int i = 0; i < fieldname.length; i++) {
// //               DataCell(Text(data[fieldname[i]] ?? ''));
// //             }
// //             return DataRow(cells: [
// //               for (int i = 0; i < fieldname.length; i++)
// //                 DataCell(Text(data[fieldname[i]] ?? '')),
// //             ]);
// //           },
// //         ).toList(),
// //       ),
// //     );
// //   }
// // }
