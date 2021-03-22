import 'package:flutter/material.dart';
import 'package:risa2/src/router/routes.dart';
import 'package:flutter/services.dart';
import 'package:risa2/src/screens/landing/landing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent, // transparent status bar
  ));
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
      onGenerateRoute: RouteGenerator.generateRoute,
      home: LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
