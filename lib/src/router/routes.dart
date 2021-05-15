import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../screens/cctv/cctv_screen.dart';

import '../screens/check/check_detail_screen.dart';
import '../screens/check/check_screen.dart';
import '../screens/check_master/add_check_master_screen.dart';
import '../screens/check_master/check_master_screen.dart';
import '../screens/check_master/edit_check_master_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/landing/landing.dart';
import '../screens/login/login_screen.dart';
import '../screens/stock/add_stock_screen.dart';
import '../screens/stock/decrement_stock_screen.dart';
import '../screens/stock/edit_stock_screen.dart';
import '../screens/stock/increment_stock_screen.dart';
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
  static const String stockAdd = '/stock-add';
  static const String stockEdit = '/stock-edit';
  static const String stockIncrement = '/stock-increment';
  static const String stockDecrement = '/stock-decrement';
  static const String cctv = '/cctv';

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
        return transitionFade(CheckScreen());
      case checkMaster:
        return transitionFade(CheckMasterScreen());
      case checkMasterAdd:
        return transitionFade(AddCheckMasterScreen());
      case checkMasterEdit:
        return transitionFade(EditCheckMasterScreen());
      case checkDetail:
        return transitionFade(CheckDetailScreen());
      case stock:
        return transitionFade(StockScreen());
      case stockDetail:
        return transitionFade(StockDetailScreen());
      case stockAdd:
        return transitionFade(AddStockScreen());
      case stockEdit:
        return transitionFade(EditStockScreen());
      case stockIncrement:
        return transitionFade(IncrementStockScreen());
      case stockDecrement:
        return transitionFade(DecrementStockScreen());
      case cctv:
        return transitionFade(CctvScreen());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}

PageTransition<dynamic> transitionFade(Widget screen) {
  return PageTransition(child: screen, type: PageTransitionType.fade);
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}
