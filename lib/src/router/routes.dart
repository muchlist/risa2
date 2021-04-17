import 'package:flutter/material.dart';

import '../screens/check/check_detail_screen.dart';
import '../screens/check/check_screen.dart';
import '../screens/check_master/add_check_master_screen.dart';
import '../screens/check_master/check_master_screen.dart';
import '../screens/check_master/edit_check_master_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/landing/landing.dart';
import '../screens/login/login_screen.dart';

class RouteGenerator {
  static const String landing = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String check = '/check';
  static const String checkMaster = '/check-master';
  static const String checkMasterAdd = '/check-master-add';
  static const String checkMasterEdit = '/check-master-edit';
  static const String checkDetail = '/check-detail';

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
      case checkMaster:
        return MaterialPageRoute(builder: (_) => CheckMasterScreen());
      case checkMasterAdd:
        return MaterialPageRoute(builder: (_) => AddCheckMasterScreen());
      case checkMasterEdit:
        return MaterialPageRoute(builder: (_) => EditCheckMasterScreen());
      case checkDetail:
        return MaterialPageRoute(builder: (_) => CheckDetailScreen());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}
