import 'package:flutter/material.dart';
import 'package:risa2/src/router/routing_constants.dart';
import 'package:risa2/src/screens/landing/landing.dart';
import 'src/router/router.dart' as router;

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'RISA';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
          primaryColor: Color(0xff4643D3),
          accentColor: Colors.green,
          buttonColor: Color(0xff4643D3),
          fontFamily: "Cascadia"),
      onGenerateRoute: router.generateRoute,
      initialRoute: landingPageViewRoute,
      home: LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
