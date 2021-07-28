import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../router/routes.dart';
import '../../utils/utils.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _expired = 0;
  int _epochNow = DateTime.now().toInt();

  _loadExpired() async {
    _expired = App.getExpired();
    if (_expired < _epochNow || App.getToken() == "") {
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
    _loadExpired();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text(". . .")),
    );
  }
}
