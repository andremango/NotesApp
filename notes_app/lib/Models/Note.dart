import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String? id;
  final String title;
  final String content;
  final bool? trashed;
  final String uid;
  final String creationTimestamp;
  final String updateTimestamp;

  Note(
      {this.id,
      required this.uid,
      required this.title,
      required this.content,
      this.trashed,
      required this.creationTimestamp,
      required this.updateTimestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'content': content,
      'trashed': trashed,
      'creation_timestamp': creationTimestamp,
      'update_timestamp': updateTimestamp
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
        id: map['id'],
        uid: map['uid'],
        title: map['title'],
        content: map['content'],
        trashed: map['trashed'],
        creationTimestamp: map['creation_timestamp'],
        updateTimestamp: map['update_timestamp']);
  }

  String? getId() {
    return id;
  }

  String getTitle() {
    return title;
  }

  String getContent() {
    return content;
  }

  String getCreationTimestamp() {
    return creationTimestamp;
  }

  String getUpdateTimestamp() {
    return updateTimestamp;
  }

  bool? isTrashed() {
    return trashed;
  }
}
