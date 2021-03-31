import 'package:flutter/material.dart';
import 'package:risa2/src/router/routes.dart';

import '../../const.dart';
import '../../globals.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String _token = "";

  _loadToken() async {
    _token = App.localStorage!.getString(TOKEN_SAVED) ?? "";
    if (_token == "") {
      await Future(() {
        Navigator.pushReplacementNamed(context, RouteGenerator.login);
      });
    } else {
      await Future(() {
        Navigator.pushReplacementNamed(context, RouteGenerator.home);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: const Text(". . .")),
    );
  }
}
