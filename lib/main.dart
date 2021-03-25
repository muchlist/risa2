import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/providers/auth.dart';
import 'package:risa2/src/providers/histories.dart';
import 'package:risa2/src/providers/improves.dart';
import 'package:risa2/src/router/routes.dart';
import 'package:flutter/services.dart';
import 'package:risa2/src/screens/landing/landing.dart';

final storage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'RISA';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthModel()),
        ChangeNotifierProvider(create: (context) => HistoryModel()),
        ChangeNotifierProvider(create: (context) => ImproveModel())
      ],
      child: MaterialApp(
        title: _title,
        theme: ThemeData(
            primaryColor: Color.fromRGBO(70, 67, 211, 1),
            accentColor: Colors.white,
            buttonColor: Color.fromRGBO(70, 67, 211, 1),
            fontFamily: "Cascadia"),
        onGenerateRoute: RouteGenerator.generateRoute,
        home: LandingPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
