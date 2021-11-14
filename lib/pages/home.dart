import 'dart:async';
import 'dart:ui';
import 'package:btiui/models/nearby_user_model_db.dart';
import 'package:btiui/pages/login.dart';
import 'package:btiui/services/storage_service.dart';
import 'package:btiui/services/user_db_info.dart';
import 'package:geolocator/geolocator.dart';

import 'editprofile.dart';

import 'filters.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'dart:math';

// Database
import '../services/database.dart';
import 'package:provider/provider.dart';
import 'package:btiui/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:btiui/models/user_model_db.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:btiui/models/location_model.dart';

// Auth
import 'package:btiui/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  final List<UserLoc> nUserAttr;
  final UserAttDB UserData;
  const Home({required this.nUserAttr, required this.UserData, Key? key})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ON TAP FUNCTIONS
  void tapReport() {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Report User'),
        content: const Text('Do you want to report this user?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: const Text('Yes'),
            isDestructiveAction: true,
            onPressed: () {
              // Do something destructive.
            },
          )
        ],
      ),
    );
  }

  void tapSignOut() {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: const Text('Yes'),
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              final authService =
                  Provider.of<AuthService>(context, listen: false);
              await authService.signOut();
            },
          )
        ],
      ),
    );
  }

  void tapSettings(bool hidden) {
    var hide = "Hide Profile";
    if (hidden == true) {
      hide = "Unhide Profile";
    }
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 160,
          child: Container(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      //color: Color(0xffc4c4c4),
                      fontSize: 18,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print(hide);
                    DatabaseService().hideUser(!hidden);
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.snooze),
                    title: Text(hide),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    tapSignOut();
                  },
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Sign Out'),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void tapActivity() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 160,
          child: Container(
            //height: (MediaQuery.of(context).size.height / 2),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Activity',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      //color: Color(0xffc4c4c4),
                      fontSize: 18,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    tapNearbyUser(
                        "Jim",
                        "40ft",
                        "Data Science Manger - Customer Experience",
                        "I like to Golf",
                        "I have a German Shepard",
                        "I am restoring a sailboat",
                        "p1");
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xff79DFFF),
                      radius: 26,
                      // ignore: prefer_const_constructors
                      child: CircleAvatar(
                        backgroundImage: const AssetImage('images/p1.jpeg'),
                        radius: 23,
                      ),
                    ),
                    title: Text('Jim waved at you'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);

                    tapNearbyUser(
                        "Hannah",
                        "40ft",
                        "Software Engineer - UI",
                        "I have 2 dogs",
                        "My favorite movie is Forrest Gump",
                        "Cycling in the Bay",
                        "p3");
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xff79DFFF),
                      radius: 26,
                      // ignore: prefer_const_constructors
                      child: CircleAvatar(
                        backgroundImage: const AssetImage('images/p3.jpeg'),
                        radius: 23,
                      ),
                    ),
                    title: Text('Hannah waved at you'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    tapNearbyUser(
                        "Angela",
                        "20ft",
                        "Head of Marketing - Enterprise",
                        "My favorite coffee is from Columbia",
                        "I recently went on a trip to Italy",
                        "I like to run marathons",
                        "p2");
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xffc4c4c4),
                      radius: 26,
                      // ignore: prefer_const_constructors
                      child: CircleAvatar(
                        backgroundImage: const AssetImage('images/p2.jpeg'),
                        radius: 23,
                      ),
                    ),
                    title: Text('You viewed and waved at Angela'),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void tapNearbyUser(String fname, String lastActive, String headline,
      String f1, String f2, String f3, String imageID) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(35),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 160,
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.width) - 70,
                    child: Stack(
                      children: [
                        Positioned(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40.0),
                                topLeft: Radius.circular(40.0)),
                            child: Image(
                              // make sure all images going in are square
                              image: NetworkImage(imageID),
                              height: (MediaQuery.of(context).size.width) - 70,
                              width: (MediaQuery.of(context).size.width) - 70,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 3,
                          right: 3,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.close,
                                size: 30,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3),
                  RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: "$fname",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xff5a5a5a),
                          fontSize: 32,
                        ),
                      ),
                      TextSpan(
                        text: "",
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xff5a5a5a),
                          fontSize: 32,
                        ),
                      ),
                    ]),
                  ),
                  Text(
                    headline,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Color(0xff5a5a5a),
                      fontSize: 22,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Talk to me about:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5a5a5a),
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.question_answer_outlined),
                        title: Text(
                          f1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff5a5a5a),
                            fontSize: 16,
                          ),
                        ),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.question_answer_outlined),
                        title: Text(
                          f2,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff5a5a5a),
                            fontSize: 16,
                          ),
                        ),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.question_answer_outlined),
                        title: Text(
                          f3,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff5a5a5a),
                            fontSize: 16,
                          ),
                        ),
                        dense: true,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Active $lastActive minutes ago',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff79DFFF),
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  //SizedBox(height: 10),
                  //Row(
                  //  mainAxisAlignment: MainAxisAlignment.center,
                  //  crossAxisAlignment: CrossAxisAlignment.center,
                  //  children: [
                  //    ElevatedButton.icon(
                  //      onPressed: () {},
                  //      icon: Transform.rotate(
                  //        angle: 0.52, //set the angel
                  //        child: Icon(
                  //          //Icons.pan_tool_outlined,
                  //          Icons.pan_tool,
                  //          size: 20.0,
                  //          //color: Color(0xffc4c4c4),
                  //          color: Color(0xffffffff),
                  //        ),
                  //      ),
                  //      label: Text('Wave'),
                  //      style: ButtonStyle(
                  //        backgroundColor:
                  //            MaterialStateProperty.all(Color(0xff79DFFF)),
                  //        padding: MaterialStateProperty.all(
                  //          EdgeInsets.symmetric(
                  //              vertical: 12.8, horizontal: 65.0),
                  //        ),
                  //        textStyle: MaterialStateProperty.all(
                  //            TextStyle(fontSize: 18)),
                  //      ),
                  //    ),
                  //  ],
                  //),
                  SizedBox(height: 20),
                  //Row(
                  //  mainAxisAlignment: MainAxisAlignment.end,
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  //  children: [
                  //    GestureDetector(
                  //      onTap: () {
                  //        tapReport();
                  //      },
                  //      child: Container(
                  //        margin: const EdgeInsets.only(right: 22.0, bottom: 5),
                  //        child: Text(
                  //          'Report',
                  //          style: TextStyle(
                  //            fontWeight: FontWeight.w500,
                  //            color: Color(0xffc4c4c4),
                  //            fontSize: 14,
                  //          ),
                  //          textAlign: TextAlign.center,
                  //        ),
                  //      ),
                  //    ),
                  //  ],
                  //),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void tapOwnProfile(String fname, String headline, String f1, String f2,
      String f3, String imageID) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(35),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 160,
          child: Container(
            //height: (MediaQuery.of(context).size.height / 1.3),
            //width: 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.width) - 70,
                    child: Stack(
                      children: [
                        Positioned(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40.0),
                                topLeft: Radius.circular(40.0)),
                            child: Image(
                              // make sure all images going in are square
                              image: NetworkImage(imageID),
                              height: (MediaQuery.of(context).size.width) - 70,
                              width: (MediaQuery.of(context).size.width) - 70,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 3,
                          right: 3,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.close,
                                size: 30,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        SizedBox(height: 3),
                        RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: fname,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xff5a5a5a),
                                fontSize: 32,
                              ),
                            ),
                          ]),
                        ),
                        Text(
                          headline,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0xff5a5a5a),
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Talk to me about:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff5a5a5a),
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.question_answer_outlined),
                              title: Text(
                                f1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff5a5a5a),
                                  fontSize: 16,
                                ),
                              ),
                              dense: true,
                            ),
                            ListTile(
                              leading: Icon(Icons.question_answer_outlined),
                              title: Text(
                                f2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff5a5a5a),
                                  fontSize: 16,
                                ),
                              ),
                              dense: true,
                            ),
                            ListTile(
                              leading: Icon(Icons.question_answer_outlined),
                              title: Text(
                                f3,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff5a5a5a),
                                  fontSize: 16,
                                ),
                              ),
                              dense: true,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfileForm()),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 20.0,
                              ),
                              label: Text('Edit Profile'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xff79DFFF)),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 12.8, horizontal: 40),
                                ),
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 18)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double screenSizeAva() {
    if (MediaQuery.of(context).size.height > 800) {
      return 60;
    } else {
      return 50;
    }
  }

  @override
  void initState() {
    super.initState();
    // Update location
    DatabaseService().updateLocation(
        widget.UserData.fname ?? "",
        widget.UserData.headline ?? "",
        widget.UserData.f1 ?? "",
        widget.UserData.f2 ?? "",
        widget.UserData.f3 ?? "",
        widget.UserData.profileURL ?? "",
        widget.UserData.hidden ?? false);
    //const waitTime = Duration(seconds: 60);
    //Timer.periodic(waitTime, (Timer t) => DatabaseService().updateLocation());
  }

  @override
  Widget build(BuildContext context) {
    final userAttd2 = Provider.of<UserAttDbInfo?>(context, listen: false);
    final userAttd3 = Provider.of<UserAtt?>(context, listen: false);

    List<Widget> displayUsers(List<UserLoc> users) {
      if (userAttd2?.user?.hidden == true) {
        return <Widget>[
          Positioned(
            top: (MediaQuery.of(context).size.height / 1.4),
            left: (MediaQuery.of(context).size.width / 2) - 100,
            child: RichText(
              text: const TextSpan(children: <TextSpan>[
                TextSpan(
                  text: 'Your profile is hidden. \nUnhide to see others!',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xff79DFFF),
                    fontSize: 18,
                  ),
                ),
              ]),
            ),
          ),
        ];
      }
      if (users.length == 1) {
        return <Widget>[
          Positioned(
            top: (MediaQuery.of(context).size.height / 4.5),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[0].fname ?? "",
                    users[0].lastActive ?? "",
                    users[0].headline ?? "",
                    users[0].f1 ?? "",
                    users[0].f2 ?? "",
                    users[0].f3 ?? "",
                    users[0].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[0].fname ?? "",
                  (users[0].distance ?? "") + "ft",
                  users[0].profileURL ?? ""),
            ),
          ),
        ];
      }
      if (users.length == 2) {
        return <Widget>[
          Positioned(
            top: (MediaQuery.of(context).size.height / 4.5),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[0].fname ?? "",
                    users[0].lastActive ?? "",
                    users[0].headline ?? "",
                    users[0].f1 ?? "",
                    users[0].f2 ?? "",
                    users[0].f3 ?? "",
                    users[0].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[0].fname ?? "",
                  (users[0].distance ?? "") + "ft",
                  users[0].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[1].fname ?? "",
                    users[1].lastActive ?? "",
                    users[1].headline ?? "",
                    users[1].f1 ?? "",
                    users[1].f2 ?? "",
                    users[1].f3 ?? "",
                    users[1].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[1].fname ?? "",
                  (users[1].distance ?? "") + "ft",
                  users[1].profileURL ?? ""),
            ),
          ),
        ];
      }
      if (users.length == 3) {
        return <Widget>[
          Positioned(
            top: (MediaQuery.of(context).size.height / 4.5),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[0].fname ?? "",
                    users[0].lastActive ?? "",
                    users[0].headline ?? "",
                    users[0].f1 ?? "",
                    users[0].f2 ?? "",
                    users[0].f3 ?? "",
                    users[0].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[0].fname ?? "",
                  (users[0].distance ?? "") + "ft",
                  users[0].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[1].fname ?? "",
                    users[1].lastActive ?? "",
                    users[1].headline ?? "",
                    users[1].f1 ?? "",
                    users[1].f2 ?? "",
                    users[1].f3 ?? "",
                    users[1].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[1].fname ?? "",
                  (users[1].distance ?? "") + "ft",
                  users[1].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[2].fname ?? "",
                    users[2].lastActive ?? "",
                    users[2].headline ?? "",
                    users[2].f1 ?? "",
                    users[2].f2 ?? "",
                    users[2].f3 ?? "",
                    users[2].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[2].fname ?? "",
                  (users[2].distance ?? "") + "ft",
                  users[2].profileURL ?? ""),
            ),
          ),
        ];
      }
      if (users.length == 4) {
        return <Widget>[
          Positioned(
            top: (MediaQuery.of(context).size.height / 4.5),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[0].fname ?? "",
                    users[0].lastActive ?? "",
                    users[0].headline ?? "",
                    users[0].f1 ?? "",
                    users[0].f2 ?? "",
                    users[0].f3 ?? "",
                    users[0].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[0].fname ?? "",
                  (users[0].distance ?? "") + "ft",
                  users[0].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[1].fname ?? "",
                    users[1].lastActive ?? "",
                    users[1].headline ?? "",
                    users[1].f1 ?? "",
                    users[1].f2 ?? "",
                    users[1].f3 ?? "",
                    users[1].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[1].fname ?? "",
                  (users[1].distance ?? "") + "ft",
                  users[1].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[2].fname ?? "",
                    users[2].lastActive ?? "",
                    users[2].headline ?? "",
                    users[2].f1 ?? "",
                    users[2].f2 ?? "",
                    users[2].f3 ?? "",
                    users[2].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[2].fname ?? "",
                  (users[2].distance ?? "") + "ft",
                  users[2].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[3].fname ?? "",
                    users[3].lastActive ?? "",
                    users[3].headline ?? "",
                    users[3].f1 ?? "",
                    users[3].f2 ?? "",
                    users[3].f3 ?? "",
                    users[3].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[3].fname ?? "",
                  (users[3].distance ?? "") + "ft",
                  users[3].profileURL ?? ""),
            ),
          ),
        ];
      }
      if (users.length == 5) {
        return <Widget>[
          Positioned(
            top: (MediaQuery.of(context).size.height / 4.5),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[0].fname ?? "",
                    users[0].lastActive ?? "",
                    users[0].headline ?? "",
                    users[0].f1 ?? "",
                    users[0].f2 ?? "",
                    users[0].f3 ?? "",
                    users[0].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[0].fname ?? "",
                  (users[0].distance ?? "") + "ft",
                  users[0].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[1].fname ?? "",
                    users[1].lastActive ?? "",
                    users[1].headline ?? "",
                    users[1].f1 ?? "",
                    users[1].f2 ?? "",
                    users[1].f3 ?? "",
                    users[1].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[1].fname ?? "",
                  (users[1].distance ?? "") + "ft",
                  users[1].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[2].fname ?? "",
                    users[2].lastActive ?? "",
                    users[2].headline ?? "",
                    users[2].f1 ?? "",
                    users[2].f2 ?? "",
                    users[2].f3 ?? "",
                    users[2].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[2].fname ?? "",
                  (users[2].distance ?? "") + "ft",
                  users[2].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[3].fname ?? "",
                    users[3].lastActive ?? "",
                    users[3].headline ?? "",
                    users[3].f1 ?? "",
                    users[3].f2 ?? "",
                    users[3].f3 ?? "",
                    users[3].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[3].fname ?? "",
                  (users[3].distance ?? "") + "ft",
                  users[3].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[4].fname ?? "",
                    users[4].lastActive ?? "",
                    users[4].headline ?? "",
                    users[4].f1 ?? "",
                    users[4].f2 ?? "",
                    users[4].f3 ?? "",
                    users[4].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[4].fname ?? "",
                  (users[4].distance ?? "") + "ft",
                  users[4].profileURL ?? ""),
            ),
          ),
        ];
      }
      if (users.length == 6) {
        return <Widget>[
          Positioned(
            top: (MediaQuery.of(context).size.height / 4.5),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[0].fname ?? "",
                    users[0].lastActive ?? "",
                    users[0].headline ?? "",
                    users[0].f1 ?? "",
                    users[0].f2 ?? "",
                    users[0].f3 ?? "",
                    users[0].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[0].fname ?? "",
                  (users[0].distance ?? "") + "ft",
                  users[0].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[1].fname ?? "",
                    users[1].lastActive ?? "",
                    users[1].headline ?? "",
                    users[1].f1 ?? "",
                    users[1].f2 ?? "",
                    users[1].f3 ?? "",
                    users[1].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[1].fname ?? "",
                  (users[1].distance ?? "") + "ft",
                  users[1].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[2].fname ?? "",
                    users[2].lastActive ?? "",
                    users[2].headline ?? "",
                    users[2].f1 ?? "",
                    users[2].f2 ?? "",
                    users[2].f3 ?? "",
                    users[2].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[2].fname ?? "",
                  (users[2].distance ?? "") + "ft",
                  users[2].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[3].fname ?? "",
                    users[3].lastActive ?? "",
                    users[3].headline ?? "",
                    users[3].f1 ?? "",
                    users[3].f2 ?? "",
                    users[3].f3 ?? "",
                    users[3].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[3].fname ?? "",
                  (users[3].distance ?? "") + "ft",
                  users[3].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[4].fname ?? "",
                    users[4].lastActive ?? "",
                    users[4].headline ?? "",
                    users[4].f1 ?? "",
                    users[4].f2 ?? "",
                    users[4].f3 ?? "",
                    users[4].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[4].fname ?? "",
                  (users[4].distance ?? "") + "ft",
                  users[4].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 9),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[5].fname ?? "",
                    users[5].lastActive ?? "",
                    users[5].headline ?? "",
                    users[5].f1 ?? "",
                    users[5].f2 ?? "",
                    users[5].f3 ?? "",
                    users[5].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[5].fname ?? "",
                  (users[5].distance ?? "") + "ft",
                  users[5].profileURL ?? ""),
            ),
          ),
        ];
      }
      if (users.length == 7) {
        return <Widget>[
          Positioned(
            top: (MediaQuery.of(context).size.height / 4.5),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[0].fname ?? "",
                    users[0].lastActive ?? "",
                    users[0].headline ?? "",
                    users[0].f1 ?? "",
                    users[0].f2 ?? "",
                    users[0].f3 ?? "",
                    users[0].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[0].fname ?? "",
                  (users[0].distance ?? "") + "ft",
                  users[0].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[1].fname ?? "",
                    users[1].lastActive ?? "",
                    users[1].headline ?? "",
                    users[1].f1 ?? "",
                    users[1].f2 ?? "",
                    users[1].f3 ?? "",
                    users[1].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[1].fname ?? "",
                  (users[1].distance ?? "") + "ft",
                  users[1].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[2].fname ?? "",
                    users[2].lastActive ?? "",
                    users[2].headline ?? "",
                    users[2].f1 ?? "",
                    users[2].f2 ?? "",
                    users[2].f3 ?? "",
                    users[2].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[2].fname ?? "",
                  (users[2].distance ?? "") + "ft",
                  users[2].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[3].fname ?? "",
                    users[3].lastActive ?? "",
                    users[3].headline ?? "",
                    users[3].f1 ?? "",
                    users[3].f2 ?? "",
                    users[3].f3 ?? "",
                    users[3].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[3].fname ?? "",
                  (users[3].distance ?? "") + "ft",
                  users[3].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[4].fname ?? "",
                    users[4].lastActive ?? "",
                    users[4].headline ?? "",
                    users[4].f1 ?? "",
                    users[4].f2 ?? "",
                    users[4].f3 ?? "",
                    users[4].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[4].fname ?? "",
                  (users[4].distance ?? "") + "ft",
                  users[4].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 9),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[5].fname ?? "",
                    users[5].lastActive ?? "",
                    users[5].headline ?? "",
                    users[5].f1 ?? "",
                    users[5].f2 ?? "",
                    users[5].f3 ?? "",
                    users[5].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[5].fname ?? "",
                  (users[5].distance ?? "") + "ft",
                  users[5].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 9),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[6].fname ?? "",
                    users[6].lastActive ?? "",
                    users[6].headline ?? "",
                    users[6].f1 ?? "",
                    users[6].f2 ?? "",
                    users[6].f3 ?? "",
                    users[6].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[6].fname ?? "",
                  (users[6].distance ?? "") + "ft",
                  users[6].profileURL ?? ""),
            ),
          ),
        ];
      }
      if (users.length == 8) {
        return <Widget>[
          Positioned(
            top: (MediaQuery.of(context).size.height / 4.5),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[0].fname ?? "",
                    users[0].lastActive ?? "",
                    users[0].headline ?? "",
                    users[0].f1 ?? "",
                    users[0].f2 ?? "",
                    users[0].f3 ?? "",
                    users[0].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[0].fname ?? "",
                  (users[0].distance ?? "") + "ft",
                  users[0].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[1].fname ?? "",
                    users[1].lastActive ?? "",
                    users[1].headline ?? "",
                    users[1].f1 ?? "",
                    users[1].f2 ?? "",
                    users[1].f3 ?? "",
                    users[1].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[1].fname ?? "",
                  (users[1].distance ?? "") + "ft",
                  users[1].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[2].fname ?? "",
                    users[2].lastActive ?? "",
                    users[2].headline ?? "",
                    users[2].f1 ?? "",
                    users[2].f2 ?? "",
                    users[2].f3 ?? "",
                    users[2].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[2].fname ?? "",
                  (users[2].distance ?? "") + "ft",
                  users[2].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[3].fname ?? "",
                    users[3].lastActive ?? "",
                    users[3].headline ?? "",
                    users[3].f1 ?? "",
                    users[3].f2 ?? "",
                    users[3].f3 ?? "",
                    users[3].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[3].fname ?? "",
                  (users[3].distance ?? "") + "ft",
                  users[3].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[4].fname ?? "",
                    users[4].lastActive ?? "",
                    users[4].headline ?? "",
                    users[4].f1 ?? "",
                    users[4].f2 ?? "",
                    users[4].f3 ?? "",
                    users[4].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[4].fname ?? "",
                  (users[4].distance ?? "") + "ft",
                  users[4].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 9),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[5].fname ?? "",
                    users[5].lastActive ?? "",
                    users[5].headline ?? "",
                    users[5].f1 ?? "",
                    users[5].f2 ?? "",
                    users[5].f3 ?? "",
                    users[5].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[5].fname ?? "",
                  (users[5].distance ?? "") + "ft",
                  users[5].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 9),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[6].fname ?? "",
                    users[6].lastActive ?? "",
                    users[6].headline ?? "",
                    users[6].f1 ?? "",
                    users[6].f2 ?? "",
                    users[6].f3 ?? "",
                    users[6].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[6].fname ?? "",
                  (users[6].distance ?? "") + "ft",
                  users[6].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 9),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[7].fname ?? "",
                    users[7].lastActive ?? "",
                    users[7].headline ?? "",
                    users[7].f1 ?? "",
                    users[7].f2 ?? "",
                    users[7].f3 ?? "",
                    users[7].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[7].fname ?? "",
                  (users[7].distance ?? "") + "ft",
                  users[7].profileURL ?? ""),
            ),
          ),
        ];
      }
      if (users.length == 9) {
        return <Widget>[
          Positioned(
            top: (MediaQuery.of(context).size.height / 4.5),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[0].fname ?? "",
                    users[0].lastActive ?? "",
                    users[0].headline ?? "",
                    users[0].f1 ?? "",
                    users[0].f2 ?? "",
                    users[0].f3 ?? "",
                    users[0].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[0].fname ?? "",
                  (users[0].distance ?? "") + "ft",
                  users[0].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[1].fname ?? "",
                    users[1].lastActive ?? "",
                    users[1].headline ?? "",
                    users[1].f1 ?? "",
                    users[1].f2 ?? "",
                    users[1].f3 ?? "",
                    users[1].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[1].fname ?? "",
                  (users[1].distance ?? "") + "ft",
                  users[1].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[2].fname ?? "",
                    users[2].lastActive ?? "",
                    users[2].headline ?? "",
                    users[2].f1 ?? "",
                    users[2].f2 ?? "",
                    users[2].f3 ?? "",
                    users[2].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[2].fname ?? "",
                  (users[2].distance ?? "") + "ft",
                  users[2].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[3].fname ?? "",
                    users[3].lastActive ?? "",
                    users[3].headline ?? "",
                    users[3].f1 ?? "",
                    users[3].f2 ?? "",
                    users[3].f3 ?? "",
                    users[3].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[3].fname ?? "",
                  (users[3].distance ?? "") + "ft",
                  users[3].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[4].fname ?? "",
                    users[4].lastActive ?? "",
                    users[4].headline ?? "",
                    users[4].f1 ?? "",
                    users[4].f2 ?? "",
                    users[4].f3 ?? "",
                    users[4].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[4].fname ?? "",
                  (users[4].distance ?? "") + "ft",
                  users[4].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 9),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[5].fname ?? "",
                    users[5].lastActive ?? "",
                    users[5].headline ?? "",
                    users[5].f1 ?? "",
                    users[5].f2 ?? "",
                    users[5].f3 ?? "",
                    users[5].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[5].fname ?? "",
                  (users[5].distance ?? "") + "ft",
                  users[5].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 9),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[6].fname ?? "",
                    users[6].lastActive ?? "",
                    users[6].headline ?? "",
                    users[6].f1 ?? "",
                    users[6].f2 ?? "",
                    users[6].f3 ?? "",
                    users[6].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[6].fname ?? "",
                  (users[6].distance ?? "") + "ft",
                  users[6].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 9),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[7].fname ?? "",
                    users[7].lastActive ?? "",
                    users[7].headline ?? "",
                    users[7].f1 ?? "",
                    users[7].f2 ?? "",
                    users[7].f3 ?? "",
                    users[7].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[7].fname ?? "",
                  (users[7].distance ?? "") + "ft",
                  users[7].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 9),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[8].fname ?? "",
                    users[8].lastActive ?? "",
                    users[8].headline ?? "",
                    users[8].f1 ?? "",
                    users[8].f2 ?? "",
                    users[8].f3 ?? "",
                    users[8].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[8].fname ?? "",
                  (users[8].distance ?? "") + "ft",
                  users[8].profileURL ?? ""),
            ),
          ),
        ];
      }
      if (users.length == 10) {
        return <Widget>[
          Positioned(
            top: (MediaQuery.of(context).size.height / 4.5),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[0].fname ?? "",
                    users[0].lastActive ?? "",
                    users[0].headline ?? "",
                    users[0].f1 ?? "",
                    users[0].f2 ?? "",
                    users[0].f3 ?? "",
                    users[0].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[0].fname ?? "",
                  (users[0].distance ?? "") + "ft",
                  users[0].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[1].fname ?? "",
                    users[1].lastActive ?? "",
                    users[1].headline ?? "",
                    users[1].f1 ?? "",
                    users[1].f2 ?? "",
                    users[1].f3 ?? "",
                    users[1].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[1].fname ?? "",
                  (users[1].distance ?? "") + "ft",
                  users[1].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[2].fname ?? "",
                    users[2].lastActive ?? "",
                    users[2].headline ?? "",
                    users[2].f1 ?? "",
                    users[2].f2 ?? "",
                    users[2].f3 ?? "",
                    users[2].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[2].fname ?? "",
                  (users[2].distance ?? "") + "ft",
                  users[2].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[3].fname ?? "",
                    users[3].lastActive ?? "",
                    users[3].headline ?? "",
                    users[3].f1 ?? "",
                    users[3].f2 ?? "",
                    users[3].f3 ?? "",
                    users[3].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[3].fname ?? "",
                  (users[3].distance ?? "") + "ft",
                  users[3].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[4].fname ?? "",
                    users[4].lastActive ?? "",
                    users[4].headline ?? "",
                    users[4].f1 ?? "",
                    users[4].f2 ?? "",
                    users[4].f3 ?? "",
                    users[4].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[4].fname ?? "",
                  (users[4].distance ?? "") + "ft",
                  users[4].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 9),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[5].fname ?? "",
                    users[5].lastActive ?? "",
                    users[5].headline ?? "",
                    users[5].f1 ?? "",
                    users[5].f2 ?? "",
                    users[5].f3 ?? "",
                    users[5].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[5].fname ?? "",
                  (users[5].distance ?? "") + "ft",
                  users[5].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 9),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[6].fname ?? "",
                    users[6].lastActive ?? "",
                    users[6].headline ?? "",
                    users[6].f1 ?? "",
                    users[6].f2 ?? "",
                    users[6].f3 ?? "",
                    users[6].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[6].fname ?? "",
                  (users[6].distance ?? "") + "ft",
                  users[6].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 9),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[7].fname ?? "",
                    users[7].lastActive ?? "",
                    users[7].headline ?? "",
                    users[7].f1 ?? "",
                    users[7].f2 ?? "",
                    users[7].f3 ?? "",
                    users[7].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[7].fname ?? "",
                  (users[7].distance ?? "") + "ft",
                  users[7].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 9),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[8].fname ?? "",
                    users[8].lastActive ?? "",
                    users[8].headline ?? "",
                    users[8].f1 ?? "",
                    users[8].f2 ?? "",
                    users[8].f3 ?? "",
                    users[8].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[8].fname ?? "",
                  (users[8].distance ?? "") + "ft",
                  users[8].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 5.5),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[9].fname ?? "",
                    users[9].lastActive ?? "",
                    users[9].headline ?? "",
                    users[9].f1 ?? "",
                    users[9].f2 ?? "",
                    users[9].f3 ?? "",
                    users[9].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[9].fname ?? "",
                  (users[9].distance ?? "") + "ft",
                  users[9].profileURL ?? ""),
            ),
          ),
        ];
      }
      if (users.length > 10) {
        return <Widget>[
          Positioned(
            top: (MediaQuery.of(context).size.height / 4.5),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[0].fname ?? "",
                    users[0].lastActive ?? "",
                    users[0].headline ?? "",
                    users[0].f1 ?? "",
                    users[0].f2 ?? "",
                    users[0].f3 ?? "",
                    users[0].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[0].fname ?? "",
                  (users[0].distance ?? "") + "ft",
                  users[0].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[1].fname ?? "",
                    users[1].lastActive ?? "",
                    users[1].headline ?? "",
                    users[1].f1 ?? "",
                    users[1].f2 ?? "",
                    users[1].f3 ?? "",
                    users[1].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[1].fname ?? "",
                  (users[1].distance ?? "") + "ft",
                  users[1].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[2].fname ?? "",
                    users[2].lastActive ?? "",
                    users[2].headline ?? "",
                    users[2].f1 ?? "",
                    users[2].f2 ?? "",
                    users[2].f3 ?? "",
                    users[2].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[2].fname ?? "",
                  (users[2].distance ?? "") + "ft",
                  users[2].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[3].fname ?? "",
                    users[3].lastActive ?? "",
                    users[3].headline ?? "",
                    users[3].f1 ?? "",
                    users[3].f2 ?? "",
                    users[3].f3 ?? "",
                    users[3].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[3].fname ?? "",
                  (users[3].distance ?? "") + "ft",
                  users[3].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 3.5),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[4].fname ?? "",
                    users[4].lastActive ?? "",
                    users[4].headline ?? "",
                    users[4].f1 ?? "",
                    users[4].f2 ?? "",
                    users[4].f3 ?? "",
                    users[4].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[4].fname ?? "",
                  (users[4].distance ?? "") + "ft",
                  users[4].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 9),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[5].fname ?? "",
                    users[5].lastActive ?? "",
                    users[5].headline ?? "",
                    users[5].f1 ?? "",
                    users[5].f2 ?? "",
                    users[5].f3 ?? "",
                    users[5].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[5].fname ?? "",
                  (users[5].distance ?? "") + "ft",
                  users[5].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 9),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[6].fname ?? "",
                    users[6].lastActive ?? "",
                    users[6].headline ?? "",
                    users[6].f1 ?? "",
                    users[6].f2 ?? "",
                    users[6].f3 ?? "",
                    users[6].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[6].fname ?? "",
                  (users[6].distance ?? "") + "ft",
                  users[6].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 9),
            left: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[7].fname ?? "",
                    users[7].lastActive ?? "",
                    users[7].headline ?? "",
                    users[7].f1 ?? "",
                    users[7].f2 ?? "",
                    users[7].f3 ?? "",
                    users[7].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[7].fname ?? "",
                  (users[7].distance ?? "") + "ft",
                  users[7].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 9),
            right: (MediaQuery.of(context).size.width / 24),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[8].fname ?? "",
                    users[8].lastActive ?? "",
                    users[8].headline ?? "",
                    users[8].f1 ?? "",
                    users[8].f2 ?? "",
                    users[8].f3 ?? "",
                    users[8].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[8].fname ?? "",
                  (users[8].distance ?? "") + "ft",
                  users[8].profileURL ?? ""),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height / 5.5),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[9].fname ?? "",
                    users[9].lastActive ?? "",
                    users[9].headline ?? "",
                    users[9].f1 ?? "",
                    users[9].f2 ?? "",
                    users[9].f3 ?? "",
                    users[9].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[9].fname ?? "",
                  (users[9].distance ?? "") + "ft",
                  users[9].profileURL ?? ""),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 21),
            left: (MediaQuery.of(context).size.width / 2) - screenSizeAva(),
            child: GestureDetector(
              onTap: () {
                tapNearbyUser(
                    users[10].fname ?? "",
                    users[10].lastActive ?? "",
                    users[10].headline ?? "",
                    users[10].f1 ?? "",
                    users[10].f2 ?? "",
                    users[10].f3 ?? "",
                    users[10].profileURL ?? "");
              },
              child: avatarGen(
                  0xffc4c4c4,
                  screenSizeAva(),
                  users[10].fname ?? "",
                  (users[10].distance ?? "") + "ft",
                  users[10].profileURL ?? ""),
            ),
          ),
        ];
      }
      return <Widget>[];
    }

    List<Widget> UserStreamTest2() {
      return <Widget>[
        StreamBuilder<List<UserLoc>>(
            stream: DatabaseService().nearbyUsers,
            builder: (_, AsyncSnapshot<List<UserLoc>> snapshot5) {
              if (snapshot5.connectionState == ConnectionState.active) {
                var nUserAttr = snapshot5.data;
                print("Length:");
                print(nUserAttr!.length);

                DateTime now = DateTime.now();
                UserLoc myLoc = nUserAttr.firstWhere(
                  (element) => element.uid == userAttd3!.uid,
                );

                nUserAttr.forEach((element) {
                  DateTime ago = element.time!.toDate();
                  int minago = now.difference(ago).inMinutes;
                  element.lastActive = minago.toString();

                  int distanceInFeet = ((Geolocator.distanceBetween(
                              myLoc.position?['geopoint'].latitude,
                              myLoc.position?['geopoint'].longitude,
                              element.position?['geopoint'].latitude,
                              element.position?['geopoint'].longitude)) *
                          3.281)
                      .round();

                  element.distance = distanceInFeet.toString();
                });

                // Remove older than 30 and same user id
                nUserAttr.removeWhere((item) => item.uid == userAttd3!.uid);
                nUserAttr.removeWhere(
                    (item) => int.parse(item.lastActive ?? "") > 900);
                return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(children: displayUsers(nUserAttr)));
              }

              return Text("");
            })
      ];
    }

    // Streambuilder - working
    //List<Widget> UserStreamTest() {
    //  final dbService = Provider.of<DatabaseService>(context);
    //  return <Widget>[
    //    StreamBuilder<List<UserLoc>>(
    //        stream: dbService.nearbyUsers,
    //        builder: (_, AsyncSnapshot<List<UserLoc>> snapshot1) {
    //          if (snapshot1.connectionState == ConnectionState.active &&
    //              snapshot1.hasData) {
    //            return FutureBuilder<List<NearUserAttDB>>(
    //                future: dbService.allNearbyUsersAttr(snapshot1.data!),
    //                builder: (_, AsyncSnapshot<List<NearUserAttDB>> snapshot5) {
    //                  if (snapshot5.connectionState == ConnectionState.done) {
    //                    var nUserAttr = snapshot5.data;
    //                    print("Length:");
    //                    print(nUserAttr!.length);
//
    //                    return SizedBox(
    //                        width: MediaQuery.of(context).size.width,
    //                        height: MediaQuery.of(context).size.height,
    //                        child: Stack(
    //                            children: List<Widget>.generate(
    //                                nUserAttr.length,
    //                                (i) => displayUsers(nUserAttr)[i])));
    //                  }
//
    //                  return Text("");
    //                });
    //          }
//
    //          return Text("");
    //        })
    //  ];
    //}

    //List<Widget> PopulateUsers() {
    //  return <Widget>[
    //    SizedBox(
    //                        width: MediaQuery.of(context).size.width,
    //                        height: MediaQuery.of(context).size.height,
    //                        child: Stack(
    //                            children: List<Widget>.generate(
    //                                widget.nUserAttr.length,
    //                                (i) => displayUsers(widget.nUserAttr)[i])))
    //
    //  ];
    //}

    //final nearbyUserAttr = widget.data;

    //nearbyUserAttr.removeLast();
    //print(nearbyUserAttr.length);
    //if (nearbyUserAttr.length > 1) {
    //  nearbyUserAttr.sort(
    //      (a, b) => int.parse(a.distance!).compareTo(int.parse(b.distance!)));
    //  //nearbyUserAttr.reversed;
    //}

    // Populate the UI
    List<Widget> UIpopulate() {
      return <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),

        Positioned(
          top: (MediaQuery.of(context).size.height / 2) - 175,
          child: conCircles(350),
        ),
        Positioned(
          top: (MediaQuery.of(context).size.height / 2) - 275,
          child: conCircles(550),
        ),
        Positioned(
          top: (MediaQuery.of(context).size.height / 2) - 375,
          child: conCircles(750),
        ),
        Positioned(
          bottom: 30,
          child: RichText(
            text: const TextSpan(children: <TextSpan>[
              TextSpan(
                text: 'Profiles within ',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xffc4c4c4),
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: '1000ft',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff79DFFF),
                  fontSize: 18,
                ),
              ),
            ]),
          ),
        ),
        //Positioned(
        //  bottom: 25,
        //  left: 22,
        //  child: GestureDetector(
        //    onTap: () {
        //      tapActivity();
        //    },
        //    child: Transform.rotate(
        //      angle: 0.52, //set the angel
        //      child: Icon(
        //        //Icons.pan_tool_outlined,
        //        Icons.pan_tool,
        //        size: 40.0,
        //        //color: Color(0xffc4c4c4),
        //        color: Color(0xff79DFFF),
        //      ),
        //    ),
        //  ),
        //),
        //Positioned(
        //  bottom: 50,
        //  left: 64,
        //  child: GestureDetector(
        //    onTap: () {
        //      tapActivity();
        //    },
        //    child: RichText(
        //      text: const TextSpan(children: <TextSpan>[
        //        TextSpan(
        //          text: '2',
        //          style: TextStyle(
        //            fontWeight: FontWeight.w700,
        //            color: Color(0xff79DFFF),
        //            fontSize: 20,
        //          ),
        //        ),
        //      ]),
        //    ),
        //  ),
        //),
        Positioned(
          bottom: 32,
          right: 25,
          child: GestureDetector(
            onTap: () {
              tapSettings(userAttd2?.user?.hidden ?? false);
            },
            child: RichText(
              text: const TextSpan(children: <TextSpan>[
                TextSpan(
                  text: '...',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xffc4c4c4),
                    fontSize: 30,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ];
    }

    // Own Profile
    List<Widget> OwnProfilePopulate() {
      return <Widget>[
        Positioned(
          top: (MediaQuery.of(context).size.height / 2) - 70,
          child: GestureDetector(
            onTap: () {
              tapOwnProfile(
                  userAttd2?.user?.fname ?? "No name",
                  userAttd2?.user?.headline ?? "No headline",
                  userAttd2?.user?.f1 ?? "No fun fact 1",
                  userAttd2?.user?.f2 ?? "No fun fact 2",
                  userAttd2?.user?.f3 ?? "No fun fact 3",
                  userAttd2?.user?.profileURL ?? "");
            },
            child: avatarGen(
                0xff79DFFF,
                70,
                userAttd2?.user?.fname ?? "No name",
                "",
                userAttd2?.user?.profileURL ?? ""),
          ),
        ),
      ];
    }

    print("build");
    return Scaffold(
      backgroundColor: const Color(0xfff2fcff),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
            alignment: AlignmentDirectional.center,
            children: UIpopulate() + OwnProfilePopulate() + UserStreamTest2()
            //displayUsers(nearbyUserAttr),
            ),
      ),
    );
  }
}

Widget conCircles(double rad) => Container(
      width: rad,
      height: rad,
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        //color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(rad)),
        border: Border.all(
          width: 2,
          color: const Color(0xffF0F0F0),
        ),
      ),
    );

Widget avatarGen(
        int cVal, double rad, String name, String dist, String imageID) =>
    Column(
      children: [
        CircleAvatar(
          backgroundColor: Color(cVal),
          radius: rad,
          // ignore: prefer_const_constructors
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageID),
            radius: rad - 5,
          ),
        ),
        RichText(
          text: TextSpan(children: <TextSpan>[
            TextSpan(
              text: name + " ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xffc4c4c4),
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: dist,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xffc4c4c4),
                fontSize: 16,
              ),
            ),
          ]),
        ),
      ],
    );
