import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/Pages/wrapper.dart';
import 'package:notes_app/Services/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xff4b39ef),
      ),
      darkTheme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        brightness: Brightness.dark,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  // Initialize Firebase
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return const Scaffold(
              body: Center(
                child: Text("Error"),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Center(
                child: Wrapper(
                  auth: Auth(),
                ),
              ),
            );
          }

          return const Scaffold(
            body: Center(
              child: Text("Loading..."),
            ),
          );
        },
      ),
    );
  }
}
