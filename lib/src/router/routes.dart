import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../screens/check/check_detail_screen.dart';
import '../screens/check/check_screen.dart';
import '../screens/check_master/add_check_master_screen.dart';
import '../screens/check_master/check_master_screen.dart';
import '../screens/check_master/edit_check_master_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/landing/landing.dart';
import '../screens/login/login_screen.dart';
import '../screens/stock/stock_detail_screen.dart';
import '../screens/stock/stock_screen.dart';

class RouteGenerator {
  static const String landing = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String check = '/check';
  static const String checkMaster = '/check-master';
  static const String checkMasterAdd = '/check-master-add';
  static const String checkMasterEdit = '/check-master-edit';
  static const String checkDetail = '/check-detail';
  static const String stock = '/stock';
  static const String stockDetail = '/stock-detail';

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
        return PageTransition(
            child: CheckScreen(), type: PageTransitionType.fade);
      case checkMaster:
        return PageTransition(
            child: CheckMasterScreen(), type: PageTransitionType.fade);
      case checkMasterAdd:
        return PageTransition(
            child: AddCheckMasterScreen(), type: PageTransitionType.fade);
      case checkMasterEdit:
        return PageTransition(
            child: EditCheckMasterScreen(), type: PageTransitionType.fade);
      case checkDetail:
        return PageTransition(
            child: CheckDetailScreen(), type: PageTransitionType.fade);
      case stock:
        return PageTransition(
            child: StockScreen(), type: PageTransitionType.fade);
      case stockDetail:
        return PageTransition(
            child: StockDetailScreen(), type: PageTransitionType.fade);
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}
