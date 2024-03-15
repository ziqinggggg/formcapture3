//! before changing note preview
// // notes_page.dart

// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:formcapture/imports.dart';
// import 'dart:developer' as devtools show log;

// import 'package:intl/intl.dart';

// class NotesPage extends StatefulWidget {
//   const NotesPage({super.key});

//   @override
//   State<NotesPage> createState() => _NotesPageState();
// }

// class _NotesPageState extends State<NotesPage> {
//   // late final FirebaseCloudStorage _notesService;
//   late final NotesService _notesService;

//   String get userId => AuthService.firebase().currentUser!.id;
//   String get userEmail => AuthService.firebase().currentUser!.email;

//   @override
//   void initState() {
//     // _notesService = FirebaseCloudStorage();
//     _notesService = NotesService();
//     _notesService.open();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool sortByCreatedDate = true;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'My notes',
//           style: TextStyle(
//               color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           PopupMenuButton<String>(
//             offset: const Offset(0, 50),
//             onSelected: (value) async {
//               if (value == 'sorting') {
//                 setState(() {
//                   sortByCreatedDate = !sortByCreatedDate;
//                 });
//               } else if (value == 'settings') {
//                 // Handle the Settings option
//               } else if (value == 'share') {
//                 // Handle the Share option
//               } else if (value == 'signOut') {
//                 bool shouldSignOut = await showSignOutConfirmationDialog(
//                     context, 'Are you sure you want to sign out?');
//                 if (shouldSignOut) {
//                   // await FirebaseAuth.instance.signOut();
//                   await AuthService.firebase().signOut();
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const LogInPage()),
//                   );
//                 } else {}
//               }
//             },
//             itemBuilder: (BuildContext context) => [
//               PopupMenuItem<String>(
//                 value: 'sorting',
//                 child: SizedBox(
//                   child: ListTile(
//                     leading: const Icon(Icons.sort),
//                     title: Text(sortByCreatedDate
//                         ? 'Sort by: Created date'
//                         : 'Sort by: Modified date'),
//                   ),
//                 ),
//               ),
//               const PopupMenuItem<String>(
//                 value: 'settings',
//                 child: SizedBox(
//                   child: ListTile(
//                     leading: Icon(Icons.settings),
//                     title: Text('Settings'),
//                   ),
//                 ),
//               ),
//               const PopupMenuItem<String>(
//                 value: 'share',
//                 child: ListTile(
//                   leading: Icon(Icons.share),
//                   title: Text('Share'),
//                 ),
//               ),
//               const PopupMenuItem<String>(
//                 value: 'signOut',
//                 child: ListTile(
//                   leading: Icon(Icons.exit_to_app_rounded),
//                   title: Text('Sign Out'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       drawer: Container(
//         width: 200,
//         child: Drawer(
//           child: ListView(
//             padding: const EdgeInsets.only(top: 40),
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.settings),
//                 title: const Text('Settings'),
//                 onTap: () {},
//               ),
//               ListTile(
//                 leading: const Icon(Icons.share),
//                 title: const Text('Share'),
//                 onTap: () {},
//               ),
//               ListTile(
//                 leading: const Icon(Icons.account_circle),
//                 title: const Text('Login'),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const LogInPage()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.exit_to_app_rounded),
//                 title: const Text('Sign Out'),
//                 onTap: () {},
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: FutureBuilder(
//         future: _notesService.getOrCreateUser(email: userEmail),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               return StreamBuilder(
//                   stream: _notesService.allNotes,
//                   builder: (context, snapshot) {
//                     switch (snapshot.connectionState) {
//                       case ConnectionState.waiting:
//                       case ConnectionState.active:
//                         if (snapshot.hasData) {
//                           // final allNotes = snapshot.data as Iterable<CloudNote>;
//                           final allNotes = snapshot.data as List<DatabaseNote>;
//                           if (sortByCreatedDate) {
//                             allNotes.sort((a, b) =>
//                                 b.createdDate.compareTo(a.createdDate));
//                           } else {
//                             allNotes.sort((a, b) =>
//                                 b.createdDate.compareTo(a.modifiedDate));
//                           }
//                           if (allNotes.isNotEmpty) {
//                             return SafeArea(
//                               bottom: false,
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 15),
//                                 child: Column(
//                                   children: [
//                                     // ListTile(
//                                     //   title: const Text(
//                                     //     'My notes',
//                                     //     style: TextStyle(
//                                     //         color: Colors.black,
//                                     //         fontSize: 35,
//                                     //         fontWeight: FontWeight.bold),
//                                     //   ),
//                                     //   trailing: IconButton(
//                                     //     icon: const Icon(Icons.more_horiz),
//                                     //     onPressed: () {
//                                     //       // showModalBottomSheet<void>(
//                                     //       //   context: context,
//                                     //       //   builder: (BuildContext context) {
//                                     //       //     return const MainMBS();
//                                     //       //   },
//                                     //       // );
//                                     //     },
//                                     //   ),
//                                     // ),

//                                     const SizedBox(
//                                       height: 15,
//                                     ),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         itemCount: allNotes.length,
//                                         itemBuilder: (context, index) {
//                                           final note = allNotes[index];
//                                           return NotePreview(
//                                             notes: note,
//                                               noteId: note.id,
//                                               title: note.title,
//                                               text: note.text,
//                                               createdDate: note.createdDate,
//                                               modifiedDate: note.modifiedDate,
//                                               onTap: (note) {
//                                                 Navigator.of(context).pushNamed(
//                                                   '/createnote/',
//                                                   arguments: note,
//                                                 );
//                                               });
//                                         },
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 15.0),
//                                 child: Column(
//                                   // mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     const SizedBox(
//                                       height: 290,
//                                     ),
//                                     const Text(
//                                       "Your notes collection is empty. Start by tapping the '+' button to create one.",
//                                       style: TextStyle(
//                                           fontSize: 23, color: Colors.grey),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 00),
//                                       child: Image.asset(
//                                         'assets/images/arrow2.png',
//                                         height: 280,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }
//                         } else {
//                           return const CircularProgressIndicator();
//                         }

//                       default:
//                         return const CircularProgressIndicator();
//                     }
//                   });

//             default:
//               return const CircularProgressIndicator();
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.white,
//         onPressed: () {
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => const CreateNote()),
//           // );
//           Navigator.of(context).pushNamed('/createnote/');
//         },
//         child: const Icon(
//           Icons.add,
//           color: Colors.black,
//           size: 32,
//         ),
//       ),
//     );
//   }
// }

// typedef NoteCallBack = void Function(DatabaseNote note);

// class NotePreview extends StatefulWidget {
//   final int noteId;
//   final String title;
//   final String text;
//   final DateTime createdDate;
//   final DateTime modifiedDate;

//   final NoteCallBack onTap;
//   final List<DatabaseNote> notes;

//   const NotePreview({
//     super.key,
//     required this.noteId,
//     required this.title,
//     required this.text,
//     required this.createdDate,
//     required this.modifiedDate,
//     required this.onTap,
//     required this.notes,
//   });

//   @override
//   State<NotePreview> createState() => _NotePreviewState();
// }

// class _NotePreviewState extends State<NotePreview> {
//   late final NotesService _notesService;

//   @override
//   void initState() {
//     // _notesService = FirebaseCloudStorage();
//     _notesService = NotesService();
//     _notesService.open();
//     super.initState();
//   }

//   String getRelativeTime(DateTime date) {
//     final currentDate = DateTime.now();
//     const gmtOffset = Duration(hours: 8); // GMT+08:00
//     final gmtTime = currentDate.add(gmtOffset);

//     final dateMidnight = DateTime(date.year, date.month, date.day, 0, 0, 0);
//     final gmtTimeMidnight =
//         DateTime(gmtTime.year, gmtTime.month, gmtTime.day, 0, 0, 0);

//     final difference = gmtTimeMidnight.difference(dateMidnight).inDays;

//     if (difference == 0) {
//       return 'Today';
//     } else if (difference == 1) {
//       return 'Yesterday';
//     } else if (difference < 7) {
//       return DateFormat('EEEE').format(date); // Day of the week
//     } else {
//       return DateFormat('yyyy/MM/dd').format(date); // Default format
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         InkWell(
//           onTap: () {},
//           child: Card(
//             elevation: 3,
//             // margin: const EdgeInsets.only(bottom: 20),
//             margin: const EdgeInsets.symmetric(vertical: 10),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//               // const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//               child: Container(
//                 clipBehavior: Clip.hardEdge, // this
//                 decoration: const BoxDecoration(),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Slidable(
//                     key: const ValueKey(0),
//                     endActionPane: ActionPane(
//                       motion: const DrawerMotion(),
//                       // dismissible: DismissiblePane(onDismissed: () async {
//                       //   try {
//                       //     await _notesService.deleteNote(id: widget.noteId);
//                       //   } catch (e) {
//                       //     devtools.log("$e");
//                       //   }
//                       // }),
//                       children: [
//                         SlidableAction(
//                           onPressed: (BuildContext context) async {},
//                           backgroundColor: const Color(0xFF21B7CA),
//                           foregroundColor: Colors.white,
//                           icon: Icons.share,
//                           label: 'Share',
//                         ),
//                         SlidableAction(
//                           onPressed: (BuildContext context) async {
//                             try {
//                               bool shoulddelete =
//                                   await showDeleteConfirmationDialog(context,
//                                       'Are you sure you want to delete note?');
//                               if (shoulddelete) {
//                                 await _notesService.deleteNote(
//                                     id: widget.noteId);
//                               } else {}
//                             } catch (e) {
//                               devtools.log("$e");
//                             }
//                           },
//                           backgroundColor: const Color(0xFFFE4A49),
//                           foregroundColor: Colors.white,
//                           icon: Icons.delete,
//                           label: 'Delete',
//                         ),
//                       ],
//                     ),
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: ListTile(
//                         title: Text(
//                           widget.title,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20),
//                         ),
//                         subtitle: Text(
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           // DateFormat('yyyy/MM/dd HH:mm')
//                           //         .format(widget.createdDate)
//                           //         .toString() +
//                           //     '  ' +
//                           getRelativeTime(widget.createdDate) +
//                               '  ' +
//                               widget.text,
//                           style: const TextStyle(
//                             color: Color.fromARGB(255, 95, 95, 95),
//                             fontFamily: 'inter',
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
