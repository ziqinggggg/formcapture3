// notes_page.dart

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formcapture/imports.dart';
import 'dart:developer' as devtools show log;

import 'package:intl/intl.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final FirebaseCloudStorage _notesService;
  // late final NotesService _notesService;
  bool sortByCreatedDate = true;

  String get userId => AuthService.firebase().currentUser!.id;
  String get username => AuthService.firebase().currentUser!.username;
  // String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    // _notesService = NotesService();
    _loadSortingPreference();
    super.initState();
  }

  void _saveSortingPreference(bool sortByCreatedDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('sortByCreatedDate', sortByCreatedDate);
  }

  void _loadSortingPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? sortByCreatedDate = prefs.getBool('sortByCreatedDate');
    if (sortByCreatedDate != null) {
      setState(() {
        this.sortByCreatedDate = sortByCreatedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool lightTheme = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          username,
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            onSelected: (value) async {
              if (value == 'sorting') {
                setState(() {
                  sortByCreatedDate = !sortByCreatedDate;
                });
                _saveSortingPreference(sortByCreatedDate);
              } else if (value == 'theme') {
                setState(() {
                  AdaptiveTheme.of(context).toggleThemeMode();
                });
              } else if (value == 'signOut') {
                bool shouldSignOut = await showSignOutConfirmationDialog(
                  context,
                );
                if (shouldSignOut) {
                  context.read<AuthBloc>().add(const AuthEventSignOut());
                  // await AuthService.firebase().signOut();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const LogInPage()),
                  // );
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'sorting',
                child: SizedBox(
                  child: ListTile(
                    leading: const Icon(Icons.sort),
                    title: Text(sortByCreatedDate
                        ? 'Sort by: Created date'
                        : 'Sort by: Modified date'),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'theme',
                child: SizedBox(
                  child: ListTile(
                    leading: Icon(lightTheme
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined),
                    title: Text(
                      AdaptiveTheme.of(context).mode.isLight
                          ? 'Light Theme'
                          : (AdaptiveTheme.of(context).mode.isDark
                              ? 'Dark Theme'
                              : 'System'),
                    ),
                  ),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'signOut',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app_rounded),
                  title: Text('Sign Out'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
          stream: _notesService.allNotes(
              ownerUserId: userId, sortByCreatedDate: sortByCreatedDate),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  // LoadingScreen().hide();

                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  if (allNotes.isNotEmpty) {
                    return SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            NotePreview(
                              notes: allNotes,
                              sortByCreatedDate: sortByCreatedDate,
                              onTap: (note) {
                                Navigator.of(context).pushNamed(
                                  '/createnote/',
                                  arguments: note,
                                );
                              },
                              onDelete: (note) async {
                                await _notesService.deleteNote(
                                    documentId: note.documentId);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 290,
                            ),
                            const Text(
                              "Your notes collection is empty. Start by tapping the '+' button to create one.",
                              style:
                                  TextStyle(fontSize: 22, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 00),
                              child: Image.asset(
                                'assets/images/arrow2.png',
                                height: 280,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                } else {
                  // LoadingScreen().show(context: context, text: 'Loading...');
                  // return Container();
                  return const Center(child: CircularProgressIndicator());
                }

              default:
                return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: lightTheme ? Colors.white : Colors.grey.shade800,
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const CreateNote()),
          // );
          Navigator.of(context).pushNamed('/createnote/');
        },
        child: Icon(
          Icons.add,
          color: lightTheme ? Colors.black : Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

typedef NoteCallBack = void Function(CloudNote note);

class NotePreview extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onTap;
  final NoteCallBack onDelete;
  final bool sortByCreatedDate;

  const NotePreview({
    super.key,
    required this.notes,
    required this.onTap,
    required this.onDelete,
    required this.sortByCreatedDate,
  });

  String getRelativeTime(DateTime date) {
    final dateMidnight = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final currentDateMidnight = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

    final difference = currentDateMidnight.difference(dateMidnight).inDays;

    if (difference == 0) {
      return DateFormat('HH:mm').format(date);
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return DateFormat('EEEE').format(date); // Day of the week
    } else {
      return DateFormat('yyyy/MM/dd').format(date); // Default format
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes.elementAt(index);
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Slidable(
                    key: const ValueKey(0),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      // dismissible: DismissiblePane(onDismissed: () async {
                      //   try {
                      //     await _notesService.deleteNote(id: widget.noteId);
                      //   } catch (e) {
                      //     devtools.log("$e");
                      //   }
                      // }),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) async {
                            Share.share(
                                'Title: ' + note.title + '\n' + note.text);
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.share,
                          label: 'Share',
                        ),
                        SlidableAction(
                          onPressed: (BuildContext context) async {
                            try {
                              bool shoulddelete =
                                  await showDeleteConfirmationDialog(context);
                              if (shoulddelete) {
                                onDelete(note);
                              } else {}
                            } catch (e) {
                              devtools.log("$e");
                            }
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ListTile(
                          title: Text(
                            note.title.trim(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            // DateFormat('yyyy/MM/dd HH:mm')
                            //         .format(note.createdDate.toDate())
                            //         .toString() +
                            // '  ' +
                            getRelativeTime(sortByCreatedDate
                                    ? note.createdDate.toDate()
                                    : note.modifiedDate.toDate()) +
                                '  ' +
                                note.text.trim(),

                            style: const TextStyle(
                              color: Color.fromARGB(255, 121, 121, 121),
                              fontFamily: 'inter',
                              // fontSize: 16,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Color.fromARGB(71, 169, 169, 169),
                              onTap: () {
                                onTap(note);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
