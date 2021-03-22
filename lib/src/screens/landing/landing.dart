import 'package:flutter/material.dart';
import 'package:risa2/src/router/routes.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String _token = "";

  _loadToken() {
    // var prefs = await SharedPreferences.getInstance();
    // _token = (prefs.getString(tokenSaved) ?? "");
    _token = "xx";
    if (_token == "") {
      Future(() {
        // Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.login,
        //     ModalRoute.withName(RouteGenerator.login));
        Navigator.pushReplacementNamed(context, RouteGenerator.login);
      });
    } else {
      Future(() {
        // Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.home,
        //     ModalRoute.withName(RouteGenerator.home));
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
