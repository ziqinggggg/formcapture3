import 'package:formcapture/imports.dart';
import 'dart:developer' as devtools show log;

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
    try {
      await notes.doc(documentId).update({
        titleFieldName: title,
        textFieldName: text,
        modifiedDateFieldName: Timestamp.fromDate(DateTime.now())
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes(
      {required String ownerUserId, required bool sortByCreatedDate}) {
    var sortingMethod = '';
    if (sortByCreatedDate) {
      sortingMethod = 'created_date';
    } else {
      sortingMethod = 'modified_date';
    }

    final allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .orderBy(sortingMethod, descending: true)
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
    try {
      final document = await notes.add({
        ownerUserIdFieldName: ownerUserId,
        titleFieldName: '',
        textFieldName: '',
        createdDateFieldName: Timestamp.fromDate(DateTime.now()),
        modifiedDateFieldName: Timestamp.fromDate(DateTime.now()),
      });
      final fetchedNote = await document.get();

      return CloudNote(
        documentId: fetchedNote.id,
        ownerUserId: ownerUserId,
        title: '',
        text: '',
        createdDate: Timestamp.fromDate(DateTime.now()),
        modifiedDate: Timestamp.fromDate(DateTime.now()),
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
