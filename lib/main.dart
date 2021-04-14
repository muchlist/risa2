import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'src/api/services/auth_service.dart';
import 'src/api/services/check_service.dart';
import 'src/api/services/checkp_service.dart';
import 'src/api/services/general_service.dart';
import 'src/api/services/history_service.dart';
import 'src/api/services/improve_service.dart';
import 'src/config/pallatte.dart';
import 'src/globals.dart';
import 'src/providers/auth.dart';
import 'src/providers/checks.dart';
import 'src/providers/checks_master.dart';
import 'src/providers/generals.dart';
import 'src/providers/histories.dart';
import 'src/providers/improves.dart';
import 'src/router/routes.dart';
import 'src/screens/landing/landing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init SharedPrefs
  await App.init();

  // add font licensi
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  // Set notification bar tot transfarent
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  ));

  // Run App
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'RISA';

  final generalService = GeneralService();
  final historyService = HistoryService();
  final checkService = CheckService();
  final checkMasterService = CheckpService();
  final authService = AuthService();
  final improveService = ImproveService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(authService)),
        ChangeNotifierProvider(
            create: (context) => HistoryProvider(historyService)),
        ChangeNotifierProvider(
            create: (context) => ImproveProvider(improveService)),
        ChangeNotifierProvider(
            create: (context) => GeneralProvider(generalService)),
        ChangeNotifierProvider(
            create: (context) => CheckProvider(checkService)),
        ChangeNotifierProvider(
            create: (context) => CheckMasterProvider(checkMasterService)),
      ],
      child: MaterialApp(
        title: _title,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(backgroundColor: Pallete.background),
            scaffoldBackgroundColor: Pallete.background,
            primaryColor: Colors.grey,
            accentColor: Pallete.green,
            iconTheme: const IconThemeData(color: Colors.black),
            fontFamily: GoogleFonts.montserrat().fontFamily,
            textTheme: GoogleFonts.montserratTextTheme()),
        onGenerateRoute: RouteGenerator.generateRoute,
        home: LandingPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
