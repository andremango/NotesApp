import 'package:flutter/material.dart';
import 'package:notes_app/Pages/Components/navbar_item.dart';
import 'package:notes_app/Pages/home.dart';
import 'package:notes_app/Pages/trashed_notes.dart';
import '../../Models/User.dart';
import '../../Services/authentication.dart';

class Navbar extends StatefulWidget {
  const Navbar({
    super.key,
    required this.auth,
    required this.userId,
    required this.user,
    required this.onLogout,
  });

  final String userId;
  final BaseAuth auth;
  final User? user;
  final VoidCallback onLogout;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color(0xff4b39ef),
        child: Column(
          children: [
            const SizedBox(height: 50),
            _buildNavbarHeaderSection(),
            const SizedBox(height: 30),
            NavbarItem(
              label: "Notes",
              icon: Icons.lightbulb,
              onItemPressed: () {
                _onItemPressed(context, 0);
                setState(() {
                  selectedPage = 0;
                });
              },
              isSelected: selectedPage == 0,
            ),
            NavbarItem(
              label: "Trash",
              icon: Icons.delete,
              onItemPressed: () {
                _onItemPressed(context, 1);
                setState(() {
                  selectedPage = 1;
                });
              },
              isSelected: selectedPage == 1,
            ),
            NavbarItem(
              label: "Logout",
              icon: Icons.logout,
              onItemPressed: () {
                _onItemPressed(context, 2);
                setState(() {
                  selectedPage = 2;
                });
              },
              isSelected: selectedPage == 2,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onItemPressed(BuildContext context, int pageIndex) async {
    Navigator.pop(context);

    switch (pageIndex) {
      // Home notes page
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage(
                auth: widget.auth,
                onLogout: widget.onLogout,
                userId: widget.userId,
              );
            },
          ),
        );
        break;
      // Trash notes page
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TrashedNotesPage(
                auth: widget.auth,
                onLogout: widget.onLogout,
                userId: widget.userId,
              );
            },
          ),
        );
        break;
      // Logout
      case 2:
        try {
          await widget.auth.onLogout().then((value) {
            widget.onLogout();
          });
        } catch (e) {
          debugPrint(e.toString());
        }
        break;
    }
  }

  Widget _buildNavbarHeaderSection() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                SizedBox(width: 25),
                Text(
                  "Fast Notes",
                  style: TextStyle(
                    fontSize: 27,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.draw,
                  color: Colors.white,
                  size: 28,
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}
