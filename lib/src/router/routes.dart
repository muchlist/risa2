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
import '../screens/computer/add_computer_screen.dart';
import '../screens/computer/computer_detail_screen.dart';
import '../screens/computer/computer_screen.dart';
import '../screens/computer/edit_computer_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/history/histories_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/improve/add_improve_screen.dart';
import '../screens/improve/edit_improve_screen.dart';
import '../screens/improve/improve_detail_screen.dart';
import '../screens/improve/improves_screen.dart';
import '../screens/improve/increment_improve_screen.dart';
import '../screens/landing/landing.dart';
import '../screens/login/login_screen.dart';
import '../screens/other/add_other_screen.dart';
import '../screens/other/edit_other_screen.dart';
import '../screens/other/other_detail_screen.dart';
import '../screens/other/other_screen.dart';
import '../screens/pdf/pdf_screen.dart';
import '../screens/stock/add_stock_screen.dart';
import '../screens/stock/decrement_stock_screen.dart';
import '../screens/stock/edit_stock_screen.dart';
import '../screens/stock/increment_stock_screen.dart';
import '../screens/stock/stock_detail_screen.dart';
import '../screens/stock/stock_screen.dart';
import '../screens/vendor_check/vendor_check_screen.dart';

class RouteGenerator {
  static const String landing = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String history = '/histories';
  static const String check = '/check';
  static const String vendorCheck = '/vendor-check';
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
  static const String computerDetail = '/computer-detail';
  static const String computerAdd = '/computer-add';
  static const String computerEdit = '/computer-edit';
  static const String other = '/other';
  static const String otherDetail = '/other-detail';
  static const String otherAdd = '/other-add';
  static const String otherEdit = '/other-edit';
  static const String dashboard = '/dashboard';
  static const String pdf = '/pdf';

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
      case computerDetail:
        return transitionFade(ComputerDetailScreen());
      case computerAdd:
        return transitionFade(AddComputerScreen());
      case computerEdit:
        return transitionFade(EditComputerScreen());
      case other:
        return transitionFade(OtherScreen());
      case otherDetail:
        return transitionFade(OtherDetailScreen());
      case otherAdd:
        return transitionFade(AddOtherScreen());
      case otherEdit:
        return transitionFade(EditOtherScreen());
      case vendorCheck:
        return transitionFade(VendorCheckScreen());
      case dashboard:
        return transitionFade(DashboardScreen());
      case pdf:
        return transitionFade(PdfScreen());
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
