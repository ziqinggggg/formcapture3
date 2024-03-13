// notes_page.dart

import 'package:formcapture/imports.dart';
import 'dart:developer' as devtools show log;

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // late final FirebaseCloudStorage _notesService;
  late final NotesService _notesService;

  String get userId => AuthService.firebase().currentUser!.id;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    // _notesService = FirebaseCloudStorage();
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My notes',
          style: TextStyle(
              color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            onSelected: (value) async {
              if (value == 'settings') {
                // Handle the Settings option
              } else if (value == 'share') {
                // Handle the Share option
              } else if (value == 'login') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogInPage()),
                );
              } else if (value == 'signOut') {
                bool shouldSignOut = await showConfirmationDialog(
                    context, 'Are you sure you want to sign out?');
                if (shouldSignOut) {
                  // await FirebaseAuth.instance.signOut();
                  await AuthService.firebase().signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogInPage()),
                  );
                } else {
                  // User canceled the action
                }
                // Handle the Sign Out option
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'settings',
                child: SizedBox(
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'login',
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Login'),
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
      drawer: Container(
        width: 200,
        child: Drawer(
          child: ListView(
            padding: const EdgeInsets.only(top: 40),
            children: [
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Login'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogInPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app_rounded),
                title: const Text('Sign Out'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  // final allNotes = snapshot.data as Iterable<CloudNote>;
                  final allNotes = snapshot.data as List<DatabaseNote>;
                  devtools.log(allNotes.toString());
                  print(allNotes);
                  return SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          // ListTile(
                          //   title: const Text(
                          //     'My notes',
                          //     style: TextStyle(
                          //         color: Colors.black,
                          //         fontSize: 35,
                          //         fontWeight: FontWeight.bold),
                          //   ),
                          //   trailing: IconButton(
                          //     icon: const Icon(Icons.more_horiz),
                          //     onPressed: () {
                          //       // showModalBottomSheet<void>(
                          //       //   context: context,
                          //       //   builder: (BuildContext context) {
                          //       //     return const MainMBS();
                          //       //   },
                          //       // );
                          //     },
                          //   ),
                          // ),

                          const SizedBox(
                            height: 15,
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: allNotes.length,
                                itemBuilder: (context, index) {
                                  final note = allNotes[index];
                                  return NotePreview(
                                    text: note.text,
                                    title: note.title,
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateNote()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 32,
        ),
      ),
    );
  }
}

class NotePreview extends StatefulWidget {
  final String title;
  final String text;

  const NotePreview({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  State<NotePreview> createState() => _NotePreviewState();
}

class _NotePreviewState extends State<NotePreview> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => NoteDetail(
            //             note: widget.note,
            //             // index: widget.index,
            //           )),
            // );
          },
          child: Card(
            color: Colors.white,
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      child: RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: widget.text,
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'inter',
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
