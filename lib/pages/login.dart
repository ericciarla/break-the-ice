import 'package:btiui/pages/home.dart';
import 'package:btiui/pages/signup.dart';
import "package:flutter/material.dart";
import 'dart:ui';
import "package:flutter/material.dart";

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
        body: const LoginForm(),
      ),
    );
  }
}

// Create a Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 170),
            //Container(
            //  child: CircleAvatar(
            //    backgroundColor: Color(0xff79DFFF),
            //    radius: 65,
            //    child: Container(
            //      width: 110,
            //      child: Image(
            //        image: AssetImage('images/logo_shadow4.png'),
            //        //color: Color(0xffA4E9FF),
            //      ),
            //    ),
            //  ),
            //),

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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                      //if (_formKey.currentState!.validate()) {
                      //  // If the form is valid, display a snackbar. In the real world,
                      //  // you'd often call a server or save the information in a database.
                      //  ScaffoldMessenger.of(context).showSnackBar(
                      //    const SnackBar(content: Text('Processing Data')),
                      //  );
                      //}
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
                Navigator.push(
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
}
