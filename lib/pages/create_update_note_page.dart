// create_note_page.dart

import 'package:formcapture/imports.dart';
import 'dart:developer' as devtools show log;

class CreateUpdateNote extends StatefulWidget {
  const CreateUpdateNote({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateUpdateNote> createState() => _CreateUpdateNoteState();
}

class _CreateUpdateNoteState extends State<CreateUpdateNote> {
  // DatabaseNote? _note;
  // late final NotesService _notesService;
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;

  late final TextEditingController _titleController;
  late final TextEditingController _textController;

  @override
  void initState() {
    // _notesService = NotesService();
    _notesService = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _textController = TextEditingController();
    super.initState();
  }

  void _titleControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final title = _titleController.text;
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: note.documentId,
      title: title,
      text: text,
    );
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final title = _titleController.text;
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: note.documentId,
      title: title,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
    _titleController.removeListener(_titleControllerListener);
    _titleController.addListener(_titleControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _titleController.text = widgetNote.title;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty &&
        _titleController.text.isEmpty &&
        note != null) {
      _notesService.deleteNote(documentId: note.documentId);
      // _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final title = _titleController.text;
    final text = _textController.text;

    if (note != null && (title.isNotEmpty | text.isNotEmpty)) {
      if (title.isNotEmpty) {
        await _notesService.updateNote(
          documentId: note.documentId,
          title: title,
          text: text,
        );
      } else if (title.isEmpty) {
        await _notesService.updateNote(
          documentId: note.documentId,
          title: 'Untitled',
          text: text,
        );
      }
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            onSelected: (value) async {
              if (value == 'delete') {
                bool shoulddelete = await showDeleteConfirmationDialog(
                    context, 'Are you sure you want to delete note?');
                if (shoulddelete) {
                  // // await Navigator.of(context).pushNamedAndRemoveUntil(
                  // //   '/notes/',
                  // //   (route) => false,
                  final note = _note;
                  await _notesService.deleteNote(documentId: note!.documentId);

                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotesPage()),
                  );
                } else {}
              } else if (value == 'share') {
                final title = _titleController.text;
                final text = _textController.text;
                if (_note == null || (text.isEmpty && title.isEmpty)) {
                  await showCannotShareEmptyNoteDialog(context);
                } else {
                  Share.share('Title: ' + title + '\n' + text);
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: SizedBox(
                  child: ListTile(
                    leading: Icon(Icons.delete,
                        color: Color.fromARGB(255, 207, 88, 78)),
                    title: Text(
                      'Delete',
                      style: TextStyle(color: Color.fromARGB(255, 207, 88, 78)),
                    ),
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
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener;
              return SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        // const FormattingToolBar(),
                        TextField(
                          controller: _titleController,
                          cursorColor: Colors.black,
                          maxLines: null,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                        TextField(
                          controller: _textController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Body', //todo: add hint text font
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Scaner()),
          );
        },
      ),
    );
  }
}
