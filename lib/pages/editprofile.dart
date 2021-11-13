import 'dart:ui';
import 'package:btiui/services/storage_service.dart';
import 'package:btiui/services/user_db_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'dart:io';
import 'package:btiui/models/user_model_db.dart';
import 'package:btiui/models/user_model.dart';
import '../services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// Create a Form widget.
class EditProfileForm extends StatefulWidget {
  const EditProfileForm({Key? key}) : super(key: key);

  @override
  EditProfileFormState createState() {
    return EditProfileFormState();
  }
}

class EditProfileFormState extends State<EditProfileForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<EditProfileFormState>.
  static GlobalKey<FormState> _editformKey = GlobalKey<FormState>();

  final TextEditingController fnameController = TextEditingController();
  final TextEditingController headlineController = TextEditingController();
  final TextEditingController f1Controller = TextEditingController();
  final TextEditingController f2Controller = TextEditingController();
  final TextEditingController f3Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    // change to other stream
    final user = Provider.of<UserAtt?>(context);
    print("rebuild");
    final userAttd2 = Provider.of<UserAttDbInfo?>(context);
    var uid = user?.uid;
    var fname = userAttd2?.user?.fname;
    var headline = userAttd2?.user?.headline;
    var f1 = userAttd2?.user?.f1;
    var f2 = userAttd2?.user?.f2;
    var f3 = userAttd2?.user?.f3;
    var profileURL = userAttd2?.user?.profileURL;

    fnameController.text = fname!;
    headlineController.text = headline!;
    f1Controller.text = f1!;
    f2Controller.text = f2!;
    f3Controller.text = f3!;

    // Build a Form widget using the _editformKey created above.
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Color(0xff79DFFF),
      ),
      body: Form(
        key: _editformKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      ImagePickerWidget(
                        diameter: 130,
                        initialImage: NetworkImage(profileURL!),
                        shape: ImagePickerWidgetShape.circle,
                        isEditable: true,
                        modalTitle: Text("Select Image Source:"),
                        modalCameraText: Text("Camera"),
                        modalGalleryText: Text("Gallery"),
                        onChange: (File file) {
                          final path = file.path;
                          final fileName = uid;
                          storage.UploadImage(path, fileName ?? "No ID")
                              .then((value) {
                            profileURL = value!;
                            print(profileURL);
                          });
                        },
                      ),
                      TextFormField(
                        controller: fnameController,

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
                      SizedBox(height: 10),
                      TextFormField(
                        controller: headlineController,

                        //maxLength: 65,
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
                      SizedBox(height: 10),
                      TextFormField(
                        controller: f1Controller,

                        //maxLength: 65,
                        decoration: const InputDecoration(
                          //icon: Icon(Icons.person),
                          hintText:
                              'Ex. My favorite place in the world is Rome',
                          labelText:
                              'Talk to me about / Interesting factoid (#1) *',
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
                      SizedBox(height: 10),
                      TextFormField(
                        //maxLength: 65,
                        controller: f2Controller,

                        decoration: const InputDecoration(
                          //icon: Icon(Icons.person),
                          hintText: 'Ex. Economics and Data Science',
                          labelText:
                              'Talk to me about / Interesting factoid (#2) *',
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
                      SizedBox(height: 10),
                      TextFormField(
                        controller: f3Controller,
                        //maxLength: 65,

                        decoration: const InputDecoration(
                          //icon: Icon(Icons.person),
                          hintText: 'Ex. I have a beach house in Maine',
                          labelText:
                              'Talk to me about / Interesting factoid (#3) *',
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
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_editformKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          Fluttertoast.showToast(
                              msg: "Processing Data",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0);

                          await DatabaseService().updateUserData(
                              fnameController.text,
                              headlineController.text,
                              f1Controller.text,
                              f2Controller.text,
                              f3Controller.text,
                              profileURL!,
                              false);

                          Future.delayed(const Duration(milliseconds: 750), () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        } else {
                          print("Not valid");
                        }
                      },
                      icon: Icon(
                        Icons.done,
                        size: 20.0,
                      ),
                      label: Text('Save Changes'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xff79DFFF)),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                              vertical: 12.8, horizontal: 85.0),
                        ),
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
