import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/Pages/register.dart';
import 'package:notes_app/Services/authentication.dart';

import '../utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.auth, required this.onLogin});

  final BaseAuth auth;
  final VoidCallback onLogin;

  @override
  State<LoginPage> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPage> {
  Utils utils = Utils();

  // Keys
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // Textfield controllers
  TextEditingController? _emailController;
  TextEditingController? _passwordController;

  late bool _passwordVisible;
  late String _email, _password;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordVisible = false;
    _email = "";
    _password = "";
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    _email = "";
    _password = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: const Color(0xff4b39ef),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildHeaderContainer(context),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.53,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              alignment: const Alignment(0, 0),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildEmailFormField(),
                      _buildPasswordFormField(),
                      _buildForgotPassword(),
                      _buildLoginButton(context),
                      _buildDivider(),
                      _buildGoToRegisterButton(context),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xff4b39ef),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 35.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Login',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Welcome back to Fast Notes!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailFormField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        style: const TextStyle(color: Color(0xff4b39ef)),
        controller: _emailController,
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: "Enter your email",
          hintStyle: const TextStyle(
              color: Color(0xff4b39ef), fontWeight: FontWeight.bold),
          prefixIcon: const Icon(Icons.email, color: Color(0xff4b39ef)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            color: const Color(0xff4b39ef),
            onPressed: () => _emailController!.clear(),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xff4b39ef)),
          ),
        ),
        onSaved: (newValue) => _email = newValue!.trim(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Email is required";
          }
          if (!utils.validateEmail(value)) {
            return "Email format invalid";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordFormField() {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: TextFormField(
        style: const TextStyle(color: Color(0xff4b39ef)),
        controller: _passwordController,
        obscureText: !_passwordVisible,
        autofocus: false,
        decoration: InputDecoration(
          hintText: ("Enter your password"),
          hintStyle: const TextStyle(
              color: Color(0xff4b39ef), fontWeight: FontWeight.bold),
          prefixIcon: const Icon(
            Icons.lock,
            color: Color(0xff4b39ef),
          ),
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off),
            color: const Color(0xff4b39ef),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xff4b39ef)),
          ),
        ),
        onSaved: (newValue) => _password = newValue!.trim(),
        validator: (value) {
          return value == null || value.isEmpty ? "Password is required" : null;
        },
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: const AlignmentDirectional(1, 0),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: TextButton(
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
                color: Color(0xff4b39ef),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {},
        ),
      ),
    );
  }

  Padding _buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 45,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text("Login"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff4b39ef),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          onPressed: () {
            if (utils.validateFormAndSave(_formKey)) {
              _performLogin();
            }
          },
        ),
      ),
    );
  }

  Padding _buildGoToRegisterButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 45,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.how_to_reg),
          label: const Text("Register"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff382947),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            textStyle: const TextStyle(
              color: Colors.black12,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(_createRegisterPageRoute());
          },
        ),
      ),
    );
  }

  Route _createRegisterPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const RegisterPage(),
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

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: const <Widget>[
          Expanded(
            child: Divider(
              thickness: 2,
              endIndent: 10,
              color: Colors.grey,
            ),
          ),
          Text(
            "OR",
            style: TextStyle(fontSize: 15),
          ),
          Expanded(
            child: Divider(
              thickness: 2,
              indent: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future _performLogin() async {
    bool errorAuthentication = false;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      errorAuthentication = true;
      utils.manageAuthException(context, e, true);
    } catch (e) {
      utils.showSnackBarMessage(
          context, e.toString(), 2, Colors.white, const Color(0xff4b39ef));
    }

    if (FirebaseAuth.instance.currentUser != null && !errorAuthentication) {
      widget.onLogin();
    }
  }
}
