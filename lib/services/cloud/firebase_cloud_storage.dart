import 'package:formcapture/imports.dart';

// sigleton
class FirebaseCloudStorage {
  final entries = FirebaseFirestore.instance.collection('entries');

  Future<void> deleteEntry({required String documentId}) async {
    try {
      await entries.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteEntryException();
    }
  }

  Future<void> updateEntry({
    required String documentId,
    required String title,
    required String text,
    required List<Map<String, String>?>? formData,
    required List formHeader,
  }) async {
    try {
      await entries.doc(documentId).update({
        titleFieldName: title,
        textFieldName: text,
        modifiedDateFieldName: Timestamp.fromDate(DateTime.now()),
        formDataFieldName: formData,
        formHeaderFieldName: formHeader
      });
    } catch (e) {
      throw CouldNotUpdateEntryException();
    }
  }

  Stream<Iterable<CloudEntry>> allEntries(
      {required String ownerUserId, required bool sortByCreatedDate}) {
    var sortingMethod = '';
    if (sortByCreatedDate) {
      sortingMethod = 'created_date';
    } else {
      sortingMethod = 'modified_date';
    }

    final allEntries = entries
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .orderBy(sortingMethod, descending: true)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudEntry.fromSnapshot(doc)));

    return allEntries;
  }

  Future<Iterable<CloudEntry>> getEntries({required String ownerUserId}) async {
    try {
      return await entries
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudEntry.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllEntriesException();
    }
  }

  Future<CloudEntry> createNewEntry({required String ownerUserId}) async {
    try {
      final document = await entries.add({
        ownerUserIdFieldName: ownerUserId,
        titleFieldName: '',
        textFieldName: '',
        createdDateFieldName: Timestamp.fromDate(DateTime.now()),
        modifiedDateFieldName: Timestamp.fromDate(DateTime.now()),
        formDataFieldName: [],
        formHeaderFieldName: [],
      });
      final fetchedEntry = await document.get();

      return CloudEntry(
        documentId: fetchedEntry.id,
        ownerUserId: ownerUserId,
        title: '',
        text: '',
        createdDate: Timestamp.fromDate(DateTime.now()),
        modifiedDate: Timestamp.fromDate(DateTime.now()),
        formData: [],
        formHeader: [],
      );
    } catch (e) {
      throw CouldNotCreateEntryException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
