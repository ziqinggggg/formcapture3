import 'package:formcapture/imports.dart';

// sigleton
class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String title,
    required String text,
  }) async {
    final currentTime = DateTime.now();
    final gmtOffset = Duration(hours: 8); // GMT+08:00
    final gmtTime = currentTime.add(gmtOffset);
    try {
      await notes.doc(documentId).update({
        titleFieldName: title,
        textFieldName: text,
        modifiedDateFieldName: gmtTime
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final currentTime = DateTime.now();
    final gmtOffset = Duration(hours: 8); // GMT+08:00
    final gmtTime = currentTime.add(gmtOffset);

    try {
      final document = await notes.add({
        ownerUserIdFieldName: ownerUserId,
        titleFieldName: '',
        textFieldName: '',
      });
      final fetchedNote = await document.get();
      return CloudNote(
        documentId: fetchedNote.id,
        ownerUserId: ownerUserId,
        title: '',
        text: '',
        createdDate: gmtTime,
        modifiedDate: gmtTime,
      );
    } catch (e) {
      throw CouldNotCreateNoteException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
