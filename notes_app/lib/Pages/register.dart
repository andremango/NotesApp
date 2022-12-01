import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageWidgetState();
}

class _RegisterPageWidgetState extends State<RegisterPage> {
  Utils utils = Utils();

  // Keys
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // Textfield controllers
  TextEditingController? _emailController;
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _passwordController;

  late String _email, _firstName, _lastName, _password;
  late bool _passwordVisible, _isEmailVerified, _allowInformative;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _passwordVisible = false;
    _allowInformative = false;
    _isEmailVerified = false;
    _email = "";
    _firstName = "";
    _lastName = "";
    _password = "";

    // Check every 2 seconds if email is verified by registered user
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkEmailVerified();
    });
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _firstNameController?.dispose();
    _lastNameController?.dispose();
    _passwordController?.dispose();
    _timer?.cancel();
    _email = "";
    _firstName = "";
    _lastName = "";
    _password = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xff4b39ef),
        elevation: 0,
      ),
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
              height: MediaQuery.of(context).size.height * 0.68,
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
                      _buildFirstNameFormField(),
                      _buildLastNameFormField(),
                      _buildEmailFormField(),
                      _buildPasswordFormField(),
                      _buildInformativeCheckbox(),
                      _buildRegisterButton(context),
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
              'Create an account',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Let\'s start to use Fast Notes!',
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

  Widget _buildFirstNameFormField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        style: const TextStyle(color: Color(0xff4b39ef)),
        controller: _firstNameController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "First name",
          hintStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff4b39ef),
          ),
          prefixIcon: const Icon(
            Icons.person,
            color: Color(0xff4b39ef),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            color: const Color(0xff4b39ef),
            onPressed: () => _firstNameController!.clear(),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff4b39ef),
            ),
          ),
        ),
        onSaved: (newValue) => _firstName = newValue!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "First name is required";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLastNameFormField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: const TextStyle(color: Color(0xff4b39ef)),
        controller: _lastNameController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "Last name",
          hintStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff4b39ef),
          ),
          prefixIcon: const Icon(
            Icons.person,
            color: Color(0xff4b39ef),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            color: const Color(0xff4b39ef),
            onPressed: () => _lastNameController!.clear(),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff4b39ef),
            ),
          ),
        ),
        onSaved: (newValue) => _lastName = newValue!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "First name is required";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmailFormField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: const TextStyle(color: Color(0xff4b39ef)),
        controller: _emailController,
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: "Enter email",
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
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: const TextStyle(color: Color(0xff4b39ef)),
        controller: _passwordController,
        obscureText: !_passwordVisible,
        autofocus: false,
        decoration: InputDecoration(
          hintText: ("Enter password"),
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

  Widget _buildInformativeCheckbox() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: CheckboxListTile(
        title: const Text(
          "Agree to terms and privacy statement",
          style: TextStyle(fontSize: 15),
        ),
        value: _allowInformative,
        activeColor: const Color(0xff4b39ef),
        onChanged: (newValue) {
          setState(() {
            _allowInformative = newValue!;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        side: MaterialStateBorderSide.resolveWith(
          (states) => const BorderSide(width: 2.0, color: Color(0xff4b39ef)),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
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
            if (!utils.validateFormAndSave(_formKey)) {
              return;
            }

            if (!_allowInformative) {
              utils.showSnackBarMessage(
                  context,
                  "You need to accept privacy terms!",
                  3,
                  Colors.white,
                  const Color(0xff4b39ef));
              return;
            }
            if (utils.validateFormAndSave(_formKey)) _performRegister();
          },
        ),
      ),
    );
  }

  Future _performRegister() async {
    try {
      // Create authentication
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then(
            (userCredential) => {
              // After authentication creation, save document with user information's (document_id => uid)
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(userCredential.user!.uid)
                  .set({
                'uid': userCredential.user!.uid,
                'first_name': _firstName,
                'last_name': _lastName,
                'email': _email,
                'password': _password
              }),
            },
          );
    } on FirebaseAuthException catch (e) {
      utils.manageAuthException(context, e, false);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (FirebaseAuth.instance.currentUser != null && !_isEmailVerified) {
      _sendEmailVerification();
    }
  }

  Future _sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();

      if (!mounted) {
        return;
      }

      utils.showSnackBarMessage(
          context,
          "Verification email sent. Confirm to continue on registration",
          3,
          Colors.white,
          const Color(0xff4b39ef));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future _checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();

      setState(() {
        _isEmailVerified = user.emailVerified;
      });

      if (_isEmailVerified) {
        _timer!.cancel();

        if (!mounted) {
          return;
        }

        utils.showSnackBarMessage(
            context,
            "Registration completed, login yourself!",
            3,
            Colors.white,
            const Color(0xff4b39ef));

        FirebaseAuth.instance.signOut();
      }
    }
  }
}
