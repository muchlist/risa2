import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../screens/cctv/add_cctv_screen.dart';
import '../screens/cctv/cctv_detail_screen.dart';
import '../screens/cctv/cctv_screen.dart';
import '../screens/cctv/edit_cctv_screen.dart';
import '../screens/check/check_detail_screen.dart';
import '../screens/check/check_screen.dart';
import '../screens/check_master/add_check_master_screen.dart';
import '../screens/check_master/check_master_screen.dart';
import '../screens/check_master/edit_check_master_screen.dart';
import '../screens/computer/computer_screen.dart';
import '../screens/history/histories_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/improve/add_improve_screen.dart';
import '../screens/improve/edit_improve_screen.dart';
import '../screens/improve/improve_detail_screen.dart';
import '../screens/improve/improves_screen.dart';
import '../screens/improve/increment_improve_screen.dart';
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
  static const String history = '/histories';
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
  static const String cctvDetail = '/cctv-detail';
  static const String cctvAdd = '/cctv-add';
  static const String cctvEdit = '/cctv-edit';
  static const String improveChange = '/improve-change';
  static const String improve = '/improve';
  static const String improveDetail = '/improve-detail';
  static const String improveAdd = '/improve-add';
  static const String improveEdit = '/improve-edit';
  static const String computer = '/computer';

  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landing:
        return MaterialPageRoute(builder: (_) => LandingPage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case history:
        return transitionFade(HistoriesScreen());
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
      case cctvDetail:
        return transitionFade(CctvDetailScreen());
      case cctvAdd:
        return transitionFade(AddCctvScreen());
      case cctvEdit:
        return transitionFade(EditCctvScreen());
      case improve:
        return transitionFade(ImproveScreen());
      case improveDetail:
        return transitionFade(ImproveDetailScreen());
      case improveChange:
        return transitionFade(IncrementImproveScreen());
      case improveAdd:
        return transitionFade(AddImproveScreen());
      case improveEdit:
        return transitionFade(EditImproveScreen());
      case computer:
        return transitionFade(ComputerScreen());
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
