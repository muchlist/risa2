import 'package:flutter/material.dart';
import 'package:risa2/src/router/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String _token = "";

  _loadToken() async {
    var prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token") ?? "";
    if (_token == "") {
      // await Future(() {
      // Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.login,
      //     ModalRoute.withName(RouteGenerator.login));
      await Navigator.pushReplacementNamed(context, RouteGenerator.login);
      // });
    } else {
      // await Future(() {
      // Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.home,
      //     ModalRoute.withName(RouteGenerator.home));
      await Navigator.pushReplacementNamed(context, RouteGenerator.home);
      // });
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
