import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/Pages/home.dart';

import '../Models/Note.dart';
import '../utils.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController? _titleController;
  TextEditingController? _contentController;

  Utils utils = Utils();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController?.dispose();
    _contentController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff4b39ef),
        appBar: AppBar(
          title: const Text(
            "Create note",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xff4b39ef),
          elevation: 0,
          toolbarHeight: 70,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                controller: _titleController,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                controller: _contentController,
                keyboardType: TextInputType.multiline,
                minLines: null,
                maxLines: null,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 1,
          onPressed: () async {
            var titleValue = _titleController!.value.text;
            var contentValue = _contentController!.value.text;

            if (contentValue.isEmpty) {
              utils.showSnackBarMessage(context, "Note is empty!", 2,
                  const Color(0xff4b39ef), Colors.white);
              return;
            }

            CollectionReference ref =
                FirebaseFirestore.instance.collection("notes");

            String docId = ref.doc().id;

            await ref
                .doc(docId)
                .set({
                  'update_timestamp': '',
                  'creation_timestamp':
                      DateFormat('yyyy-MM-dd - kk:mm').format(DateTime.now()),
                  'trashed': false,
                  'content': contentValue,
                  'title': titleValue,
                  'uid': FirebaseAuth.instance.currentUser!.uid,
                  'id': docId
                })
                .then((value) => Navigator.pop(context))
                .onError((error, stackTrace) => debugPrint(error.toString()));
          },
          backgroundColor: const Color.fromARGB(255, 43, 28, 161),
          child: const Icon(Icons.save),
        ),
      ),
      onWillPop: () async {
        if (_contentController!.value.text.isEmpty) {
          Widget cancelButton = TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
          Widget continueButton = TextButton(
            child: const Text(
              "Continue",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          );
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              backgroundColor: const Color.fromARGB(255, 111, 96, 222),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              title: const Text(
                "Unsaved modification",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                "Do you really want to exit?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
              actions: [continueButton, cancelButton],
            ),
          );
        }
        return false;
      },
    );
  }
}
