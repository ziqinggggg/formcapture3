// entries_page.dart

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:formcapture/imports.dart';

import 'package:intl/intl.dart';

class EntriesPage extends StatefulWidget {
  const EntriesPage({super.key});

  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  late final FirebaseCloudStorage _entriesService;
  // late final EntriesService _entriesService;
  bool sortByCreatedDate = true;

  String get userId => AuthService.firebase().currentUser!.id;
  String get username => AuthService.firebase().currentUser!.username;
  // String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _entriesService = FirebaseCloudStorage();
    // _entriesService = EntriesService();
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
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
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
          stream: _entriesService.allEntries(
              ownerUserId: userId, sortByCreatedDate: sortByCreatedDate),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  // LoadingScreen().hide();

                  final allEntries = snapshot.data as Iterable<CloudEntry>;
                  if (allEntries.isNotEmpty) {
                    return SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            EntryPreview(
                              entries: allEntries,
                              sortByCreatedDate: sortByCreatedDate,
                              onTap: (entry) {
                                Navigator.of(context).pushNamed(
                                  '/createentry/',
                                  arguments: entry,
                                );
                              },
                              onDelete: (entry) async {
                                await _entriesService.deleteEntry(
                                    documentId: entry.documentId);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "Your entries collection is empty. Start by tapping the '+' button to create one.",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
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
          //   MaterialPageRoute(builder: (context) => const CreateEntry()),
          // );
          Navigator.of(context).pushNamed('/createentry/');
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

typedef EntryCallBack = void Function(CloudEntry entry);

class EntryPreview extends StatelessWidget {
  final Iterable<CloudEntry> entries;
  final EntryCallBack onTap;
  final EntryCallBack onDelete;
  final bool sortByCreatedDate;

  const EntryPreview({
    super.key,
    required this.entries,
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
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries.elementAt(index);
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
                      //     await _entriesService.deleteEntry(id: widget.entryId);
                      //   } catch (e) {
                      //     log("$e");
                      //   }
                      // }),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            if (entry.formHeader.isNotEmpty) {
                              List<Map<String, String>> formData = [];
                              List<String> formHeader = [];
                              for (var header in entry.formHeader) {
                                formHeader.add(header);
                              }
                              for (var data in entry.formData) {
                                Map<String, String> formDataMap = {};
                                for (var key in entry.formHeader) {
                                  formDataMap[key] = data[key] ?? '';
                                }
                                formData.add(formDataMap);
                              }
                              showShareDialog(
                                context,
                                entry.title,
                                entry.text,
                                formData,
                              );
                            } else {
                              Share.share(
                                  'Title: ' + entry.title + '\n' + entry.text);
                            }

                            // Share.share(
                            //     'Title: ' + entry.title + '\n' + entry.text);
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
                                onDelete(entry);
                              } else {}
                            } catch (e) {
                              log("$e");
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
                            entry.title.trim(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            // DateFormat('yyyy/MM/dd HH:mm')
                            //         .format(entry.createdDate.toDate())
                            //         .toString() +
                            // '  ' +
                            getRelativeTime(sortByCreatedDate
                                    ? entry.createdDate.toDate()
                                    : entry.modifiedDate.toDate()) +
                                '  ' +
                                entry.text.trim(),

                            style: const TextStyle(
                              color: Color.fromARGB(255, 121, 121, 121),
                              // fontSize: 16,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor:
                                  const Color.fromARGB(71, 169, 169, 169),
                              onTap: () {
                                onTap(entry);
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
