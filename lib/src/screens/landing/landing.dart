import 'package:flutter/material.dart';
import 'package:risa2/src/router/routing_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String _token = "";

  _loadToken() async {
    var prefs = await SharedPreferences.getInstance();
    _token = (prefs.getString(tokenSaved) ?? "");
    if (_token == "") {
      await Navigator.pushNamedAndRemoveUntil(
          context, loginViewRoute, ModalRoute.withName(loginViewRoute));
    } else {
      await Navigator.pushNamedAndRemoveUntil(
          context, homeViewRoute, ModalRoute.withName(homeViewRoute));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Loading ...")));
  }
}
