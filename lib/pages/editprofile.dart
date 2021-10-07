import 'dart:ui';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'dart:math';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'dart:io';

// Edit Profile
class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Color(0xff79DFFF),
      ),
      body: const EditProfileForm(),
    );
  }
}

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
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
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
                      initialValue: "Eric",
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
                      initialValue: "Economics Major at UNH",
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
                      initialValue: "",
                      //maxLength: 65,
                      decoration: const InputDecoration(
                        //icon: Icon(Icons.person),
                        hintText: 'Ex. My favorite place in the world is Rome',
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
                      initialValue: "",
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
                      //maxLength: 65,
                      initialValue: "",
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
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
                        EdgeInsets.symmetric(vertical: 12.8, horizontal: 85.0),
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
    );
  }
}