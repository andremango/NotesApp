import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/Pages/Components/navbar.dart';
import 'package:notes_app/Pages/add_note.dart';
import 'package:notes_app/main.dart';
import 'Components/note_card.dart';

import '../Models/User.dart';
import '../../Models/Note.dart';
import '../Services/authentication.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.auth,
      required this.userId,
      required this.onLogout});

  final String userId;
  final BaseAuth auth;
  final VoidCallback onLogout;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  User? _user;

  late List<Note> _notes;

  TextEditingController? _searchController;

  late bool _toGridView;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _retrieveUserInfo();
    });
    _notes = [];
    _toGridView = true;
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if user isn't already loaded, show spinner
    if (_user == null) {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).nextFocus();
        },
        child: SafeArea(
          child: Scaffold(
            drawer: Navbar(
              auth: widget.auth,
              userId: widget.userId,
              user: _user,
              onLogout: widget.onLogout,
            ),
            key: scaffoldKey,
            appBar: _buildAppBar(),
            backgroundColor: const Color(0xff4b39ef),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("notes")
                            .where("uid", isEqualTo: _user!.uid)
                            .where("trashed", isEqualTo: false)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            if (_searchController!.text.isEmpty) {
                              _notes = [];
                              for (var note in snapshot.data!.docs) {
                                _notes.add(Note.fromMap(
                                    note.data() as Map<String, dynamic>));
                              }
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Your notes",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: GridView.builder(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: _notes.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: _toGridView ? 2 : 1,
                                      childAspectRatio: _toGridView ? 1 : 3,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return buildNoteCard(context, () {},
                                          _notes.elementAt(index), false);
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            var height = MediaQuery.of(context).size.height;
                            return Padding(
                              padding: EdgeInsets.only(top: height / 2.5),
                              child: const Center(
                                child: Text(
                                  "There's no notes. Create one!",
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 1,
              onPressed: () {
                Navigator.of(context).push(_createAddNotePageRoute());
              },
              backgroundColor: const Color.fromARGB(255, 43, 28, 161),
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xff4b39ef),
      elevation: 0,
      toolbarHeight: 70,
      leading: _buildAppBarLeading(),
      title: _buildAppBarTitle(),
      actions: _buildAppBarActions(),
    );
  }

  Builder _buildAppBarLeading() {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    );
  }

  Widget _buildAppBarTitle() {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search notes",
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w100,
            color: Colors.white70,
            letterSpacing: 1,
          ),
          prefixIcon: IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {},
          ),
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        onChanged: (value) {
          setState(() {
            List<Note> filtered = [];

            for (var note in _notes) {
              if (note.getTitle().toLowerCase().contains(value.toLowerCase()) ||
                  note
                      .getContent()
                      .toLowerCase()
                      .contains(value.toLowerCase())) {
                filtered.add(note);
              }
            }

            _notes = filtered;
          });
        },
      ),
    );
  }

  Route _createAddNotePageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const AddNotePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        onPressed: () {
          setState(() {
            _toGridView = !_toGridView;
          });
        },
        icon: _toGridView
            ? const Icon(Icons.grid_view)
            : const Icon(Icons.view_day_outlined),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      Padding(
        padding: const EdgeInsets.all(7.0),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => _buildUserInfoDialog(),
            );
          },
          child: CircleAvatar(
            radius: 25,
            backgroundColor: const Color.fromARGB(255, 43, 28, 161),
            child: Text(
              _user!.getInitials(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Dialog _buildUserInfoDialog() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Dialog(
      insetPadding:
          EdgeInsets.only(bottom: (height / 2) + 90, left: (width / 2) - 100),
      insetAnimationDuration: const Duration(milliseconds: 600),
      backgroundColor: const Color.fromARGB(255, 111, 96, 222),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        height: 175.0,
        width: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    iconSize: 25,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ),
                const SizedBox(width: 35),
                const Text(
                  "Fast Notes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Divider(color: Colors.grey.shade800, thickness: 1, height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 10, bottom: 12),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color.fromARGB(255, 43, 28, 161),
                    child: Text(
                      _user!.getInitials(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_user!.getFirstName()} ${_user!.getLastName()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      _user!.getEmail(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Divider(color: Colors.grey.shade800, thickness: 1, height: 1),
            Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: GestureDetector(
                onTap: () async {
                  await widget.auth.onLogout().then((value) {
                    Navigator.pop(context);
                    widget.onLogout();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15),
                    Icon(Icons.logout_outlined, size: 24, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _retrieveUserInfo() async {
    var users = FirebaseFirestore.instance.collection('users');
    var snapshot = await users.doc(widget.userId).get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data();
      setState(() {
        if (data!.isNotEmpty) {
          _user = User.fromMap(data);
        }
      });
    }
  }
}
