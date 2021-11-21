import 'dart:io';
import 'package:btiui/pages/home.dart';
import 'package:btiui/pages/loading.dart';
import 'package:btiui/pages/login.dart';
import 'package:btiui/pages/welcome.dart';
import 'package:btiui/services/globals.dart';
import 'package:btiui/services/storage_service.dart';
import 'package:btiui/services/wrapper.dart';
import "package:flutter/material.dart";
import 'dart:ui';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:btiui/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

// Sign Up
class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Break The Ice',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xfff2fcff),
        //scaffoldBackgroundColor: const Color(0xffA4E9FF),
      ),
      home: Scaffold(
        //resizeToAvoidBottomInset: false,
        body: const SignUpForm(),
      ),
    );
  }
}

// Create a Form widget.
class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<SignUpFormState>.
  GlobalKey<FormState> _signupformKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController headlineController = TextEditingController();
  final TextEditingController f1Controller = TextEditingController();
  final TextEditingController f2Controller = TextEditingController();
  final TextEditingController f3Controller = TextEditingController();
  var profileURL = " ";
  final Storage storage = Storage();
  var path = "no file";
  var fileName = getRandomString(25);

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _signupformKey created above.

    final authService = Provider.of<AuthService>(context);

    return Form(
      key: _signupformKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: (MediaQuery.of(context).size.height / 10)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Welcome to Break The Ice!',
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
                        'Let\'s get to know each other better',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color(0xff5a5a5a),
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                ImagePickerWidget(
                  diameter: 130,
                  initialImage: AssetImage("images/empty_profile2.jpg"),
                  shape: ImagePickerWidgetShape.circle,
                  isEditable: true,
                  modalTitle: Text("Select Image Source:"),
                  modalCameraText: Text("Camera"),
                  modalGalleryText: Text("Gallery"),
                  onChange: (File file) {
                    path = file.path;
                  },
                ),
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: "Profile image is required*",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xffff6f6f),
                        fontSize: 14,
                      ),
                    ),
                  ]),
                ),
                TextFormField(
                  //initialValue: "Eric",
                  //maxLength: 65,
                  controller: fnameController,
                  decoration: const InputDecoration(
                    //icon: Icon(Icons.person),
                    labelText: 'First Name *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.length > 55) {
                      return 'Please keep this under 55 characters';
                    }
                    return null;
                  },
                ),
                //SizedBox(height: 1),

                TextFormField(
                  //maxLength: 65,
                  //initialValue: "Economics Major at UNH",
                  controller: headlineController,
                  decoration: const InputDecoration(
                    //icon: Icon(Icons.person),
                    hintText: 'Ex. Economics Major @ UNH ',
                    labelText: 'Headline *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.length > 55) {
                      return 'Please keep this under 55 characters';
                    }
                    return null;
                  },
                ),
                //SizedBox(height: 1),
                TextFormField(
                  //maxLength: 65,
                  //initialValue: "",
                  controller: f1Controller,
                  decoration: const InputDecoration(
                    //icon: Icon(Icons.person),
                    hintText: 'Ex. My favorite place in the world is Rome',
                    labelText: 'Talk to me about / Interesting factoid (#1) *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.length > 55) {
                      return 'Please keep this under 55 characters';
                    }
                    return null;
                  },
                ),
                //SizedBox(height: 10),
                TextFormField(
                  //maxLength: 65,
                  //initialValue: "",
                  controller: f2Controller,
                  decoration: const InputDecoration(
                    //icon: Icon(Icons.person),
                    hintText: 'Ex. Economics and Data Science',
                    labelText: 'Talk to me about / Interesting factoid (#2) *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.length > 55) {
                      return 'Please keep this under 55 characters';
                    }
                    return null;
                  },
                ),
                //SizedBox(height: 10),
                TextFormField(
                  //maxLength: 65,
                  //initialValue: "",
                  controller: f3Controller,
                  decoration: const InputDecoration(
                    //icon: Icon(Icons.person),
                    hintText: 'Ex. I have a beach house in Maine',
                    labelText: 'Talk to me about / Interesting factoid (#3) *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.length > 55) {
                      return 'Please keep this under 55 characters';
                    }
                    return null;
                  },
                ),
                //SizedBox(height: 10),
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
                //SizedBox(height: 10),
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
                      if (_signupformKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Loading()),
                        );

                        if (path != "no file") {
                          await storage.UploadImage(path, fileName)
                              .then((value) {
                            profileURL = value!;

                            print(profileURL);
                          });

                          await authService.createUserWithEmailAndPassword(
                              emailController.text, passwordController.text);

                          // Try to cache location
                          Geoflutterfire geo = Geoflutterfire();
                          Position? pos =
                              await DatabaseService().determinePosition();
                          GeoFirePoint point = geo.point(
                              latitude: pos.latitude, longitude: pos.longitude);
                          Globals.changeCurLoc(point);
                          print("Got Location");

                          await DatabaseService().updateUserData(
                              fnameController.text,
                              headlineController.text,
                              f1Controller.text,
                              f2Controller.text,
                              f3Controller.text,
                              profileURL,
                              false);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please upload an image!",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text('Sign Up'),
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
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: "Already have an account?",
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Color(0xff5a5a5a),
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: " Log in",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xff79DFFF),
                      fontSize: 14,
                    ),
                  ),
                ]),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    fnameController.dispose();
    headlineController.dispose();
    f1Controller.dispose();
    f2Controller.dispose();
    f3Controller.dispose();
    super.dispose();
  }
}
