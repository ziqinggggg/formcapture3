import 'package:formcapture/imports.dart';

@immutable
class CloudEntry {
  final String documentId;
  final String ownerUserId;
  final String title;
  final String text;
  final Timestamp createdDate;
  final Timestamp modifiedDate;
  final dynamic formData;
  final dynamic formHeader;

  const CloudEntry({
    required this.documentId,
    required this.ownerUserId,
    required this.title,
    required this.text,
    required this.createdDate,
    required this.modifiedDate,
    required this.formData,
    required this.formHeader,
  });

  CloudEntry.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        title = snapshot.data()[titleFieldName] as String,
        text = snapshot.data()[textFieldName] as String,
        createdDate = snapshot.data()[createdDateFieldName] as Timestamp,
        modifiedDate = snapshot.data()[modifiedDateFieldName] as Timestamp,
        formData = snapshot.data()[formDataFieldName] as dynamic,
        formHeader = snapshot.data()[formHeaderFieldName] as dynamic;
}
