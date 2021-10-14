import 'dart:ui';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'dart:math';

// Edit Profile
class Filters extends StatelessWidget {
  const Filters({Key? key}) : super(key: key);

  // not sure if this makes sense

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filters"),
        backgroundColor: Color(0xff79DFFF),
      ),
      body: const FiltersForm(),
    );
  }
}

// Create a Form widget.
class FiltersForm extends StatefulWidget {
  const FiltersForm({Key? key}) : super(key: key);

  @override
  FiltersFormState createState() {
    return FiltersFormState();
  }
}

class FiltersFormState extends State<FiltersForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<FiltersFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: "500",
                      decoration: const InputDecoration(
                        //icon: Icon(Icons.person),
                        labelText: 'Maximum Distance (ft)*',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }

                        return null;
                      },
                      maxLength: 4,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: "18",
                            maxLength: 2,
                            decoration: const InputDecoration(
                              //icon: Icon(Icons.person),
                              labelText: 'Minimum Age *',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              if (int.parse(value) < 18) {
                                return 'Please enter an age higher than 17';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue: "99",
                            maxLength: 2,
                            decoration: const InputDecoration(
                              //icon: Icon(Icons.person),
                              labelText: 'Maximum Age *',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: "Everyone",
                      items: ['Everyone', 'Men', 'Women']
                          .map<DropdownMenuItem<String>>(
                        (String val) {
                          return DropdownMenuItem(
                            child: Text(val),
                            value: val,
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Show Me',
                      ),
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
                        EdgeInsets.symmetric(vertical: 12.8, horizontal: 45.0),
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
