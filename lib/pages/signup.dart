import 'dart:io';

import 'package:btiui/pages/home.dart';
import 'package:btiui/pages/login.dart';
import "package:flutter/material.dart";
import 'dart:ui';
import "package:flutter/material.dart";
import 'package:image_picker_widget/image_picker_widget.dart';

//import 'package:flow_builder/flow_builder.dart';
import '../models/signup_model.dart';

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
            SizedBox(height: 60),
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
                    print("I changed the file to: ${file.path}");
                  },
                ),
                TextFormField(
                  //initialValue: "Eric",
                  //maxLength: 65,
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
}
