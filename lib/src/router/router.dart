import 'package:flutter/material.dart';
import 'package:risa2/src/screens/home/home.dart';
import 'package:risa2/src/screens/landing/landing.dart';
import 'package:risa2/src/screens/login/login_screen.dart';
import 'routing_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case landingPageViewRoute:
      return MaterialPageRoute(builder: (context) => LandingPage());
    case loginViewRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case homeViewRoute:
      return MaterialPageRoute(builder: (context) => HomeScreen());
    default:
      return MaterialPageRoute(builder: (context) => LandingPage());
  }
}
