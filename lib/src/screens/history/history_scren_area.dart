import 'package:flutter/material.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var authModel = Provider.of<AuthProvider>(context);
    // var accessToken = authModel.userData?.accessToken ?? "";
    // var error = authModel.error ?? "";

    return SafeArea(
      child: Column(
        children: [
          // Text(accessToken),
          // Text(error),
          // ElevatedButton(
          //     onPressed: () {
          //       authModel.login("1191122712", "Pelindo34d");
          //     },
          //     child: Text("Login")),
          // ElevatedButton(
          //     onPressed: () {
          //       authModel.logout();
          //     },
          //     child: Text("Logout")),
        ],
      ),
    );
  }
}
