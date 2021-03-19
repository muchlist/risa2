import 'package:flutter/material.dart';
import 'package:risa2/src/router/routes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: Text("Click"),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (_) => LoginScreen()));
          Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.login,
              ModalRoute.withName(RouteGenerator.login));
        },
      )),
    );
  }
}
