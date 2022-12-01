import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Utils {
  void showSnackBarMessage(BuildContext context, String message, int duration,
      Color textColor, Color backgroundColor) {
    // ! Hide snackbar if already visible
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: duration),
      content: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      backgroundColor: backgroundColor,
    ));
  }

  bool validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool validateFormAndSave(GlobalKey<FormState> formKey) {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void manageAuthException(
      BuildContext context, firebaseAuthException, bool isLogin) {
    debugPrint("FIREBASE AUTH EXCEPTION : $firebaseAuthException");

    // Login exceptions's
    if (isLogin) {
      if (firebaseAuthException.code == 'user-not-found') {
        showSnackBarMessage(context, "User not found!", 3, Colors.white,
            const Color(0xff4b39ef));
      } else if (firebaseAuthException.code == 'wrong-password') {
        showSnackBarMessage(context, "Password incorrect!", 3, Colors.white,
            const Color(0xff4b39ef));
      }
      // Register exception's
    } else {
      if (firebaseAuthException.code == 'email-already-in-use') {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          if (!user.emailVerified) {
            showSnackBarMessage(
                context,
                "Verify email for confirm registration",
                3,
                Colors.white,
                const Color(0xff4b39ef));
          } else {
            showSnackBarMessage(context, "User already registered!", 3,
                Colors.white, const Color(0xff4b39ef));
          }
        } else {
          showSnackBarMessage(context, "User already registered!", 3,
              Colors.white, const Color(0xff4b39ef));
        }
      } else if (firebaseAuthException.code == 'weak-password') {
        showSnackBarMessage(
            context,
            "Password too weak! Please digit another one",
            3,
            Colors.white,
            const Color(0xff4b39ef));
      }
    }
  }
}
