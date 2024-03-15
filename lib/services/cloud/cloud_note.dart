import 'package:formcapture/imports.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String title;
  final String text;
  final DateTime createdDate;
  final DateTime modifiedDate;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.title,
    required this.text,
    required this.createdDate,
    required this.modifiedDate,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        title = snapshot.data()[titleFieldName] as String,
        text = snapshot.data()[textFieldName] as String,
        createdDate = snapshot.data()[createdDateFieldName] as DateTime,
        modifiedDate = snapshot.data()[modifiedDateFieldName] as DateTime;
}
