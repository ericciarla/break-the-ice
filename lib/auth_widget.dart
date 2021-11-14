import 'package:btiui/pages/loading.dart';
import 'package:btiui/pages/welcome.dart';
import 'package:btiui/services/auth_service.dart';
import 'package:btiui/services/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';

/// Builds the signed-in or non signed-in UI, depending on the user snapshot.
/// This widget should be below the [MaterialApp].
/// An [AuthWidgetBuilder] ancestor is required for this widget to work.
class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key, required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<UserAtt?> userSnapshot;

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  
  @override
  Widget build(BuildContext context) {
      if (widget.userSnapshot.connectionState == ConnectionState.active) {
        final auth = Provider.of<AuthService>(context, listen: false);
        return widget.userSnapshot.hasData
            ? Wrapper(widget.userSnapshot.data!)
            : Welcome();
      }
      return Scaffold(
        body: Loading(),
      );
  
  }
}
