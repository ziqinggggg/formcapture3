// create_note_page.dart

import 'package:formcapture/imports.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  DatabaseNote? _note;
  late final NotesService _notesService;

  late final TextEditingController _titleController;
  late final TextEditingController _textController;

  // final _titleController = TextEditingController();
  // final _noteController = TextEditingController();

  // CloudNote? _note;
  // late final FirebaseCloudStorage _notesService;
  // late final TextEditingController _titleController;
  // late final TextEditingController _textController;

  @override
  void initState() {
    // _notesService = FirebaseCloudStorage();
    _notesService = NotesService();
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
      // documentId: note.documentId,
      note: note,
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
      // documentId: note.documentId,
      note: note,
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

  // Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
  //   final widgetNote = context.getArgument<CloudNote>();

  //   if (widgetNote != null) {
  //     _note = widgetNote;
  //     _textController.text = widgetNote.text;
  //     return widgetNote;
  //   }

  //   final existingNote = _note;
  //   if (existingNote != null) {
  //     return existingNote;
  //   }
  //   final currentUser = AuthService.firebase().currentUser!;
  //   final userId = currentUser.id;
  //   final newNote = await _notesService.createNewNote(ownerUserId: userId);
  //   _note = newNote;
  //   return newNote;
  // }

  Future<DatabaseNote> createNewNote(BuildContext context) async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty &&
        _titleController.text.isEmpty &&
        note != null) {
      // _notesService.deleteNote(documentId: note.documentId);
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final title = _titleController.text;
    final text = _textController.text;

    if (note != null && text.isNotEmpty) {
      if (title.isNotEmpty) {
        await _notesService.updateNote(
          // documentId: note.documentId,
          note: note,
          title: title,
          text: text,
        );
      } else if (title.isEmpty) {
        await _notesService.updateNote(
          // documentId: note.documentId,
          note: note,
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
          IconButton(
            icon: const Icon(
              Icons.delete,
              size: 30,
            ),
            onPressed: () {
              // Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: createNewNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNote;
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
                          //note text field
                          controller: _textController,
                          // cursorColor: Colors.black,
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
