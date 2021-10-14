import 'dart:ui';
import 'package:btiui/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:btiui/models/user_model.dart';
import 'editprofile.dart';
import 'filters.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'dart:math';
import '../services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:btiui/models/user_model_db.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Filters()),
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.filter_alt),
                    title: Text('Filters'),
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
              children: const <Widget>[
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
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xffc4c4c4),
                    radius: 25,
                    // ignore: prefer_const_constructors
                    child: CircleAvatar(
                      backgroundImage: const AssetImage('images/prof.jpeg'),
                      radius: 23,
                    ),
                  ),
                  title: Text('Eric waved at You'),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xffc4c4c4),
                    radius: 25,
                    // ignore: prefer_const_constructors
                    child: CircleAvatar(
                      backgroundImage: const AssetImage('images/prof.jpeg'),
                      radius: 23,
                    ),
                  ),
                  title: Text('You waved at Eric'),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void tapNearbyUser() {
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
                              image: AssetImage('images/prof.jpeg'),
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
                                color: Color(0xff5a5a5a),
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
                        text: "Eric ",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xff5a5a5a),
                          fontSize: 32,
                        ),
                      ),
                      TextSpan(
                        text: "50ft",
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xff5a5a5a),
                          fontSize: 32,
                        ),
                      ),
                    ]),
                  ),
                  Text(
                    'Data Scientist at Ford',
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
                    children: const <Widget>[
                      ListTile(
                        leading: Icon(Icons.question_answer_outlined),
                        title: Text(
                          'Planes and Aviation',
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
                          'Data Science and Economics',
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
                          'Philosophy and Stoicism',
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
                          angle: 0.52, //set the angel
                          child: Icon(
                            //Icons.pan_tool_outlined,
                            Icons.pan_tool,
                            size: 20.0,
                            //color: Color(0xffc4c4c4),
                            color: Color(0xffffffff),
                          ),
                        ),
                        label: Text('Wave'),
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

  void tapOwnProfile() {
    final userAttrDB = Provider.of<List<UserAttDB>>(context, listen: false);
    var fname = userAttrDB[0].fname;
    var headline = userAttrDB[0].headline;
    var f1 = userAttrDB[0].f1;
    var f2 = userAttrDB[0].f2;
    var f3 = userAttrDB[0].f3;
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
                              image: AssetImage('images/prof.jpeg'),
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
                                color: Color(0xff5a5a5a),
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
                              text: "${fname}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xff5a5a5a),
                                fontSize: 32,
                              ),
                            ),
                          ]),
                        ),
                        Text(
                          '${headline}',
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
                                '${f1}',
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
                                '${f2}',
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
                                '${f3}',
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
    final user = Provider.of<UserAtt?>(context);
    final userAttrDB = Provider.of<List<UserAttDB>>(context);

    if (userAttrDB.length > 0) {
      print(userAttrDB[0].fname);
    }

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
                            text: 'Profiles within ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xffc4c4c4),
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: '500ft',
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
                          tapActivity();
                        },
                        child: Transform.rotate(
                          angle: 0.52, //set the angel
                          child: Icon(
                            //Icons.pan_tool_outlined,
                            Icons.pan_tool,
                            size: 40.0,
                            //color: Color(0xffc4c4c4),
                            color: Color(0xff79DFFF),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 64,
                      child: GestureDetector(
                        onTap: () {
                          tapActivity();
                        },
                        child: RichText(
                          text: const TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: '3',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xff79DFFF),
                                fontSize: 20,
                              ),
                            ),
                          ]),
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
                      top: (MediaQuery.of(context).size.height / 9),
                      right: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser();
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Eric", "21ft"),
                      ),
                    ),
                    Positioned(
                      top: (MediaQuery.of(context).size.height / 21),
                      left: (MediaQuery.of(context).size.width / 2) -
                          screenSizeAva(),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser();
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Eric", "21ft"),
                      ),
                    ),
                    Positioned(
                      top: (MediaQuery.of(context).size.height / 9),
                      left: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser();
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Eric", "21ft"),
                      ),
                    ),
                    // Top Row 2
                    Positioned(
                      top: (MediaQuery.of(context).size.height / 3.5),
                      right: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser();
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Eric", "21ft"),
                      ),
                    ),
                    Positioned(
                      top: (MediaQuery.of(context).size.height / 4.5),
                      left: (MediaQuery.of(context).size.width / 2) -
                          screenSizeAva(),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser();
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Eric", "21ft"),
                      ),
                    ),
                    Positioned(
                      top: (MediaQuery.of(context).size.height / 3.5),
                      left: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser();
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Eric", "21ft"),
                      ),
                    ),
                    // Bottom Row 1
                    Positioned(
                      bottom: (MediaQuery.of(context).size.height / 3.5),
                      right: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser();
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Eric", "21ft"),
                      ),
                    ),

                    Positioned(
                      bottom: (MediaQuery.of(context).size.height / 3.5),
                      left: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser();
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Eric", "21ft"),
                      ),
                    ),
                    // Bottom Row 2
                    Positioned(
                      bottom: (MediaQuery.of(context).size.height / 9),
                      right: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser();
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Eric", "21ft"),
                      ),
                    ),
                    Positioned(
                      bottom: (MediaQuery.of(context).size.height / 5.5),
                      left: (MediaQuery.of(context).size.width / 2) -
                          screenSizeAva(),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser();
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Eric", "21ft"),
                      ),
                    ),
                    Positioned(
                      bottom: (MediaQuery.of(context).size.height / 9),
                      left: (MediaQuery.of(context).size.width / 24),
                      child: GestureDetector(
                        onTap: () {
                          tapNearbyUser();
                        },
                        child: avatarGen(
                            0xffc4c4c4, screenSizeAva(), "Eric", "21ft"),
                      ),
                    ),

                    // Own profile
                    Positioned(
                      top: (MediaQuery.of(context).size.height / 2) - 70,
                      child: GestureDetector(
                        onTap: () {
                          tapOwnProfile();
                        },
                        child: avatarGen(0xff79DFFF, 70, "You", ""),
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

Widget avatarGen(int cVal, double rad, String name, String dist) => Column(
      children: [
        CircleAvatar(
          backgroundColor: Color(cVal),
          radius: rad,
          // ignore: prefer_const_constructors
          child: CircleAvatar(
            backgroundImage: const AssetImage('images/prof.jpeg'),
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
