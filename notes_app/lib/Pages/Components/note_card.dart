import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Models/Note.dart';

Widget buildNoteCard(
    BuildContext context, Function() onTap, Note note, bool fromTrash) {
  return InkWell(
    onTap: onTap,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 135,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 2, 4),
                    child: Text(
                      note.getTitle(),
                      maxLines: 2,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Color(0xff4b39ef),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  alignment: Alignment.centerRight,
                  onPressed: () {
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
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () {
                        if (!fromTrash) {
                          FirebaseFirestore.instance
                              .collection("notes")
                              .doc(note.getId())
                              .update({"trashed": true})
                              .then(
                                (value) => Navigator.of(context).pop(),
                              )
                              .onError(
                                (error, stackTrace) =>
                                    debugPrint(error.toString()),
                              );
                        } else {
                          FirebaseFirestore.instance
                              .collection("notes")
                              .doc(note.getId())
                              .delete()
                              .then(
                                (value) => Navigator.of(context).pop(),
                              )
                              .onError(
                                (error, stackTrace) =>
                                    debugPrint(error.toString()),
                              );
                        }
                      },
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor:
                            const Color.fromARGB(255, 111, 96, 222),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        title: Text(
                          fromTrash ? "Delete note" : "Trash note",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          fromTrash
                              ? "Do you really want to delete the note?"
                              : "Do you really want to trash the note?",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        actions: [continueButton, cancelButton],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Color(0xff4b39ef),
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              note.getContent(),
              maxLines: 5,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(7),
                bottomRight: Radius.circular(7),
              ),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                note.getCreationTimestamp(),
                style: const TextStyle(
                  color: Color(0xff4b39ef),
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
