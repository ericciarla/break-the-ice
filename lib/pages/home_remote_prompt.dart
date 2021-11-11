import 'dart:async';
import 'dart:ui';
import 'editprofile.dart';
import 'home.dart';
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

class home_remote_prompt extends StatefulWidget {
  const home_remote_prompt({Key? key}) : super(key: key);

  @override
  _home_remote_promptState createState() => _home_remote_promptState();
}

class _home_remote_promptState extends State<home_remote_prompt> {
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

  void tapHideProfile() {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Hide Profile'),
        content: const Text(
            'Do you want to hide your profile? You will not be able to see other profiles or be seen'),
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

  void tapSettings() {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.groups),
                    title: Text('In Person Mode'),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    tapHideProfile();
                  },
                  child: ListTile(
                    leading: Icon(Icons.snooze),
                    title: Text('Hide Profile'),
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

  void tapNearbyUser(String fname, String distance, String headline, String f1,
      String f2, String f3, String imageID) {
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
                              image: AssetImage('images/$imageID.jpeg'),
                              height: (MediaQuery.of(context).size.width) - 70,
                              width: (MediaQuery.of(context).size.width) - 70,
                              fit: BoxFit.fitWidth,
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
                        text: "$fname ",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xff5a5a5a),
                          fontSize: 32,
                        ),
                      ),
                      TextSpan(
                        text: distance,
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
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Transform.rotate(
                          angle: 0, //set the angel
                          child: Icon(
                            //Icons.pan_tool_outlined,
                            Icons.chat_bubble,
                            size: 20.0,
                            //color: Color(0xffc4c4c4),
                            color: Color(0xffffffff),
                          ),
                        ),
                        label: Text('Chat'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff79DFFF)),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                                vertical: 12.8, horizontal: 65.0),
                          ),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          tapReport();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 22.0, bottom: 5),
                          child: Text(
                            'Report',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xffc4c4c4),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                              image: AssetImage('images/$imageID.jpeg'),
                              height: (MediaQuery.of(context).size.width) - 70,
                              width: (MediaQuery.of(context).size.width) - 70,
                              fit: BoxFit.fitWidth,
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
                                      builder: (context) => EditProfile()),
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
  Widget build(BuildContext context) {
    // Streams
    //final user = Provider.of<UserAtt?>(context);
    final userAttd = Provider.of<UserAttDB?>(context);

    //print(userAttd?.fname ?? "No name");
    //final nearbyUserAttr = Provider.of<List<UserAttDB>>(context);

    //if (nearbyUserAttr.length > 0) {
    //  print("nearby users:");
    //  nearbyUserAttr.forEach((element) {
    //    print(element.fname);
    //  });
    //}

    // Update location
    // DatabaseService().updateLocation();
    // const waitTime = Duration(seconds: 10);
    // Timer.periodic(waitTime, (Timer t) => DatabaseService().updateLocation());

    return MaterialApp(
      title: 'Break The Ice',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xfff2fcff),
      ),
      home: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
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
                            text: 'What do you think?',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xffc4c4c4),
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff79DFFF),
                              fontSize: 18,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      left: 22,
                      child: GestureDetector(
                        onTap: () {
                          //tapActivity();
                        },
                        child: Icon(
                          //Icons.pan_tool_outlined,
                          Icons.mic,
                          size: 40.0,
                          //color: Color(0xffc4c4c4),
                          color: Color(0xff79DFFF),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 32,
                      right: 25,
                      child: GestureDetector(
                        onTap: () {
                          tapSettings();
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

                    // Populate with nearby users under here
                    // Top Row 1
                    Positioned(
                      top: 50,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        width: (MediaQuery.of(context).size.width * .75),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color(0xffF0F0F0),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          "What are your thoughts on our company's recent entrance into the EV market?",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xff3d3d3d),
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Top Row 2
                    Positioned(
                      top: (MediaQuery.of(context).size.height / 3.5),
                      right: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser(
                              "Marcus",
                              "",
                              "Sales Manger - Enterprise",
                              "I am from Michigan",
                              "I love football",
                              "My favorite book is The Alchemist",
                              "p4");
                        },
                        child: avatarGen(
                            0xff79dfff, screenSizeAva(), "Marcus", "", "p4"),
                      ),
                    ),
                    Positioned(
                      top: (MediaQuery.of(context).size.height / 4.5),
                      left: (MediaQuery.of(context).size.width / 2) -
                          screenSizeAva(),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser(
                              "Paul",
                              "",
                              "Product Designer",
                              "I am a black belt in Jiu Jitsu",
                              "My child is an olympian",
                              "I lived in Brazil for 5 years",
                              "p5");
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Paul", "", "p5"),
                      ),
                    ),
                    Positioned(
                      top: (MediaQuery.of(context).size.height / 3.5),
                      left: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser(
                              "Aziz",
                              "",
                              "Data Scientist - Product",
                              "Product analytics",
                              "Rocketry",
                              "Backpacking across Europe",
                              "p6");
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Aziz", "", "p6"),
                      ),
                    ),
                    // Bottom Row 1
                    Positioned(
                      bottom: (MediaQuery.of(context).size.height / 3.5),
                      right: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser(
                              "Chris",
                              "",
                              "UI/UX Designer",
                              "Tips for a good UI and UX",
                              "My favorite place in the world is Madrid",
                              "My first day working here",
                              "p7");
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Chris", "", "p7"),
                      ),
                    ),

                    Positioned(
                      bottom: (MediaQuery.of(context).size.height / 3.5),
                      left: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser(
                              "Maria",
                              "",
                              "Software Engineer - Enterprise",
                              "I have lived in 3 different countries",
                              "My favorite project working here",
                              "I am a professional rower",
                              "p8");
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Maria", "", "p8"),
                      ),
                    ),
                    // Bottom Row 2
                    Positioned(
                      bottom: (MediaQuery.of(context).size.height / 9),
                      right: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser(
                              "Pamela",
                              "",
                              "Finance Manager - Enterprise",
                              "Originally from Florida",
                              "Pilates",
                              "I have been to over 10 counties",
                              "p9");
                        },
                        child: avatarGen(
                            0xff79dfff, screenSizeAva(), "Pamela", "", "p9"),
                      ),
                    ),
                    Positioned(
                      bottom: (MediaQuery.of(context).size.height / 5.5),
                      left: (MediaQuery.of(context).size.width / 2) -
                          screenSizeAva(),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser(
                              "Michael",
                              "",
                              "Product Designer - Enterprise",
                              "Designing an engaging product",
                              "Proud UVermont Alumni",
                              "Hiking over 30 mountians",
                              "p10");
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Michael", "", "p10"),
                      ),
                    ),
                    Positioned(
                      bottom: (MediaQuery.of(context).size.height / 9),
                      left: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser(
                              "Viktoria",
                              "",
                              "Marketing - Enterprise",
                              "Making a Product Viral",
                              "Originally from Russia",
                              "I love hiking",
                              "p11");
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Viktoria", "", "p11"),
                      ),
                    ),

                    // Own profile
                    Positioned(
                      top: (MediaQuery.of(context).size.height / 2) - 70,
                      child: GestureDetector(
                        onTap: () {
                          tapOwnProfile(
                              "Holly",
                              "Head of Product",
                              "Designing a delightful experience",
                              "Traveling to Italy with my family",
                              "Hiking",
                              "p12");
                        },
                        child: avatarGen(0xff79DFFF, 70, "You", "", "p12"),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
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
            backgroundImage: AssetImage('images/$imageID.jpeg'),
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
