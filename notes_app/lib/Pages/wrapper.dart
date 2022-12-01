// ignore_for_file: constant_identifier_names

import 'package:notes_app/Pages/login.dart';

import '../Services/authentication.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Wrapper extends StatefulWidget {
  final BaseAuth auth;
  const Wrapper({super.key, required this.auth});

  @override
  State<Wrapper> createState() => _WrapperState();
}

enum AuthStatus { UNDETERMINED, LOGGED_IN, NOT_LOGGED_IN }

class _WrapperState extends State<Wrapper> {
  AuthStatus authStatus = AuthStatus.UNDETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    // Try to retrieve logged user
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLogin() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user!.uid.toString();
      });

      setState(() {
        authStatus = AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLogout() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = "";
        authStatus = AuthStatus.NOT_LOGGED_IN;
      });
    });
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.UNDETERMINED:
        return _buildLoadingScreen();
      case AuthStatus.NOT_LOGGED_IN:
        return LoginPage(auth: widget.auth, onLogin: _onLogin);
      case AuthStatus.LOGGED_IN:
        if (_userId.isNotEmpty) {
          return HomePage(
              auth: widget.auth, onLogout: _onLogout, userId: _userId);
        } else {
          return _buildLoadingScreen();
        }
      default:
        return _buildLoadingScreen();
    }
  }
}
