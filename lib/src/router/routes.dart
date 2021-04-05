import 'package:flutter/material.dart';
import '../screens/check/check_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/landing/landing.dart';
import '../screens/login/login_screen.dart';

class RouteGenerator {
  static const String landing = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String check = '/check';

  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landing:
        return MaterialPageRoute(builder: (_) => LandingPage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case check:
        return MaterialPageRoute(builder: (_) => CheckScreen());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}
