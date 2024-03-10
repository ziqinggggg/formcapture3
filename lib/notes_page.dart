import 'package:formcapture/pages.dart';
// import 'dart:developer' as devtools show log;

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
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
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LogInPage()),
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
                      MaterialPageRoute(
                          builder: (context) => const LogInPage()),
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
        body: SafeArea(
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
                // const Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Button(text: 'Favourites'),
                //     Button(text: 'Today'),
                //     Button(text: 'This week'),
                //     Button(text: "Last 30 days"),
                //   ],
                // ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        int reversedIndex = notes.length - 1 - index;
                        final note = notes[reversedIndex];
                        return NotePreview(
                          note: note,
                          index: index,
                        );
                      }),
                )
              ],
            ),
          ),
        ),
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
            )));
  }
}

class NotePreview extends StatefulWidget {
  final Note note;
  final int index;

  const NotePreview({
    super.key,
    required this.note,
    required this.index,
  });

  @override
  State<NotePreview> createState() => _NotePreviewState();
}

class _NotePreviewState extends State<NotePreview> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NoteDetail(note: widget.note, index: widget.index)),
          );
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
                      widget.note.title,
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
                                  text: widget.note.body,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'inter',
                                      fontSize: 16)))))
                ],
              ),
            )),
      ),
    ]);
  }
}
