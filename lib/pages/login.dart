import 'package:btiui/pages/home.dart';
import 'package:btiui/pages/signup.dart';
import 'package:btiui/services/auth_service.dart';
import 'package:btiui/services/wrapper.dart';
import "package:flutter/material.dart";
import 'dart:ui';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:btiui/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Sign Up
class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Break The Ice',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xfff2fcff),
        //scaffoldBackgroundColor: const Color(0xffA4E9FF),
      ),
      home: Scaffold(
        body: LoginForm(),
      ),
    );
  }
}

// Create a Form widget.
class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<LoginFormState>.
  GlobalKey<FormState> _loginformKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _loginformKey created above.

    final authService = Provider.of<AuthService>(context);

    return Form(
      key: _loginformKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: (MediaQuery.of(context).size.height / 3)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff5a5a5a),
                          fontSize: 26,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Get ready to meet some new people',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color(0xff5a5a5a),
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  //initialValue: "Eric",
                  controller: emailController,
                  decoration: const InputDecoration(
                    //icon: Icon(Icons.person),
                    labelText: 'Email *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  //initialValue: "Eric",
                  controller: passwordController,
                  decoration: const InputDecoration(
                    //icon: Icon(Icons.person),
                    labelText: 'Password *',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_loginformKey.currentState!.validate()) {
                        await authService.signInWithEmailAndPassword(
                            emailController.text, passwordController.text);
                        final User? user = await AuthService().getCurrentUser();
                        String userId = user?.uid ?? " ";
                        if (userId != " ") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Wrapper()),
                          );
                        }
                      }
                    },
                    child: const Text('Log In'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff79DFFF)),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 12.8, horizontal: 85.0),
                      ),
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
              child: RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: "Don't have an account?",
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Color(0xff5a5a5a),
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: " Sign up",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xff79DFFF),
                      fontSize: 14,
                    ),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    print("trash dumped!");
    super.dispose();
  }
}
